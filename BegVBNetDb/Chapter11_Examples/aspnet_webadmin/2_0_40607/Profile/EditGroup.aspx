<%@ page masterPageFile="~/WebAdminButtonRow.master" language="cs" inherits="System.Web.Administration.ProfilePage"%>
<%@ Register TagPrefix="Profile" TagName="PropertyListUserControl" Src="PropertyList.ascx"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">
private string _group;

private string Group {
    get {
        if (_group == null) {
            _group = HttpUtility.HtmlDecode(Request["group"]);
            if (_group == null) {
                _group = (string) Session["ProfileGroup"];
            }
            else {
                // We save the group name in session in case the page will be
                // loaded in the future through a back button action.  In this
                // case, it might not have the group name query parameter in the
                // URL.
                Session["ProfileGroup"] = _group;
            }
        }
        return _group;
    }
}

private void AddPropertiesLinkButton_Click(object s, EventArgs e) {
    MoveProperties(NoGroupPropertyList.Rows, true);
}

private void BindPropertyLists() {
    StringCollection noGroupPropertyNameCollection = GetGroupPropertyNameCollection(null);
    StringCollection inGroupPropertyNameCollection = GetGroupPropertyNameCollection(Group);

    // Identify the properties that have the same names in both groups
    StringCollection samePropertyNameCollection = new StringCollection();
    foreach (string name in noGroupPropertyNameCollection) {
        if (inGroupPropertyNameCollection.Contains(name)) {
            samePropertyNameCollection.Add(name);
        }
    }

    DataView dataView = GetGroupPropertyListDataView(noGroupPropertyNameCollection, samePropertyNameCollection);
    NoGroupPropertyList.DataSource = dataView;
    NoGroupPropertyList.DataBind();
    NoGroupPropertyList.SetPropertyCountLabel(dataView.Count, (string)GetPageResourceObject("AvailablePropertiesCountLabel"));

    dataView = GetGroupPropertyListDataView(inGroupPropertyNameCollection, samePropertyNameCollection);
    InGroupPropertyList.DataSource = dataView;
    InGroupPropertyList.DataBind();
    InGroupPropertyList.SetPropertyCountLabel(dataView.Count, (string)GetPageResourceObject("PropertiesInGroupCountLabel"));
}

private DataView GetGroupPropertyListDataView(StringCollection propertyNameCollection,
                                              StringCollection samePropertyNameCollection) {
    // TODO: Perf: It might not be needed if there are no properties.

    DataTable dataTable = new DataTable();
    dataTable.Locale = CultureInfo.InvariantCulture;  // FxCop
    dataTable.Columns.Add("Property", typeof(string));
    dataTable.Columns.Add("Enabled", typeof(bool));

    DataView dataView;

    foreach (string property in propertyNameCollection) {
        DataRow row = dataTable.NewRow();
        row[0] = property;
        row[1] = !(samePropertyNameCollection.Contains(property));
        dataTable.Rows.Add(row);
    }

    dataView = new DataView(dataTable);
    dataView.Sort = "Property ASC";

    return dataView;
}

private StringCollection GetGroupPropertyNameCollection(string group) {
    string appPath = ApplicationPath;
    Configuration config = GetWebConfiguration(appPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection properties = profile.PropertySettings;

    if (group == null || group.Length == 0) {
        string parentPath = GetParentPath(appPath);
        config = GetWebConfiguration(parentPath);
        profile = (ProfileSection) config.GetSection("system.web/profile");
        ProfilePropertySettingsCollection parentProperties = profile.PropertySettings;
        return ProfileUtil.GetPropertyNamesWithNoGroup(parentProperties, properties);
    }
    else {
        return ProfileUtil.GetPropertyNamesFromGroup(properties.GroupSettings, group);
    }
}

private void InGroupPropertyList_PageIndexChanged(object s, GridViewPageEventArgs e) {
    InGroupPropertyList.PageIndex = e.NewPageIndex;
    BindPropertyLists();
}

private void MoveProperties(GridViewRowCollection sourceRows, bool addToGroup) {
    bool anyChecked = false;
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;

    foreach (GridViewRow row in sourceRows) {
        CheckBox checkBox = (CheckBox) row.FindControl("SelectedCheckBox");
        if (checkBox.Checked) {
            anyChecked = true;
            string property = row.Cells[1].Text;

            string sourceGroup = (addToGroup) ? null : Group;
            ProfilePropertySettings propertySettings = ProfileUtil.GetProperty(profileElement, property, sourceGroup);
            ProfileUtil.DeleteProperty(profileElement, property, sourceGroup);

            if (addToGroup) {
                ProfileGroupSettings groupSettings = ProfileUtil.GetGroup(profileElement, Group);
                groupSettings.PropertySettings.Add(propertySettings);
            }
            else {
                profileElement.Add(propertySettings);
            }
        }
    }

    if (anyChecked) {
        UpdateConfig(config);
        BindPropertyLists();
    }
}

private void NoGroupPropertyList_PageIndexChanged(object s, GridViewPageEventArgs e) {
    NoGroupPropertyList.PageIndex = e.NewPageIndex;
    BindPropertyLists();
}

private void Page_Init() {
    InGroupPropertyList.GroupName = Group;
}

private void Page_Load() {
    if (!IsPostBack) {
        TitleLiteral.Text = String.Format((string)GetPageResourceObject("Title"), Group);
        NewPropertyHyperLink.NavigateUrl = "CreateProperty.aspx?group=" + HttpUtility.HtmlEncode(Group);
        BindPropertyLists();
    }
}

private void RemovePropertiesLinkButton_Click(object s, EventArgs e) {
    MoveProperties(InGroupPropertyList.Rows, false);
}

</script>

<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:literal runat="server" id="TitleLiteral"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table height="100%" width="100%" cellspacing="0" cellpadding="1">
                    <tr class="bodyText" align="left" valign="top" height="1%">
                        <td>
                            <asp:literal runat="server" Text="<%$ Resources:Instructions %>"/>
                        </td>
                    </tr>
                    <tr valign="top" align="left" height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                    <td width="49%">
                                        <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                                            <tr height="1%">
                                                <td>
                                                    <Profile:PropertyListUserControl runat="server" id="NoGroupPropertyList"
                                                                                             HeaderText="<%$ Resources:AvailablePropertiesHeader %>"
                                                                                             OnPageIndexChanging="NoGroupPropertyList_PageIndexChanged"
                                                                                             EmptyDataText="<%$ Resources:NoAvailablePropertiesText %>"/>
                                                </td>
                                            </tr>
                                            <tr><td/></tr>
                                        </table>
                                    </td>
                                    <td width="2%">
                                        <table cellspacing="0" height="100%" width="100%" cellpadding="0">
                                            <tr align="left" valign="top" height="30">
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="bodyTextLeftPadding5" style="padding-right:5;padding-top:10" align="left" valign="top" height="1%">
                                                <td nowrap="nowrap">
                                                    <asp:Image runat="server" ImageUrl="~/Images/moveRightArrow.gif"/>
                                                    <asp:LinkButton runat="server" id="AddPropertiesLinkButton" Text="<%$ Resources:AddToGroupButtonLabel %>"
                                                                    OnClick="AddPropertiesLinkButton_Click"
                                                                    ToolTip="<%$ Resources:AddToGroupToolTip %>"/>
                                                </td>
                                            </tr>
                                            <tr class="bodyTextLeftPadding5" style="padding-right:5;padding-top:10" align="left" valign="top" height="1%">
                                                <td nowrap="nowrap">
                                                    <asp:Image runat="server" ImageUrl="~/Images/moveLeftArrow.gif"/>
                                                    <asp:LinkButton runat="server" id="RemovePropertiesLinkButton" Text="<%$ Resources:RemoveFromGroupButtonLabel %>"
                                                                    OnClick="RemovePropertiesLinkButton_Click"
                                                                    ToolTip="<%$ Resources:RemoveFromGroupToolTip %>"/>
                                                </td>
                                            </tr>
                                            <tr><td/></tr>
                                        </table>
                                    </td>
                                    <td width="49%">
                                        <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                                            <tr height="1%">
                                                <td>
                                                    <Profile:PropertyListUserControl runat="server" id="InGroupPropertyList"
                                                                                             HeaderText="<%$ Resources:PropertiesInGroupHeader %>"
                                                                                             OnPageIndexChanging="InGroupPropertyList_PageIndexChanged"
                                                                                             EmptyDataText="<%$ Resources:NoPropertiesInGroupText %>"/>
                                                </td>
                                            </tr>
                                            <tr><td/></tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="bodyText" align="left" valign="top">
                        <td>
                            <asp:HyperLink runat="server" id="NewPropertyHyperLink" Text="<%$ Resources:NewPropertyLinkText %>"/><br/>
                            <asp:HyperLink runat="server" NavigateUrl="ManageGroups.aspx" Text="<%$ Resources:ManageGroupsLinkText %>"/>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="100"/>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:GlobalResources,BackButtonLabel %>" id="BackButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>
