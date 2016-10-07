<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProfilePage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private bool IsSortUp {
    get {
        return (SortInfoField.Value == "U");
    }
    set {
        if (value) {
            SortInfoField.Value = "U";
        }
        else {
            SortInfoField.Value = null;
        }
    }
}

private void AddNewGroup_Click(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    bool validToUpdate = true;
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection propertySettings = profile.PropertySettings;

    string group = NewGroupTextBox.Text;

    // Check if the group already exists as a group or a property without group
    if (ProfileUtil.HasProperty(propertySettings, group, null) ||
        ProfileUtil.HasGroup(propertySettings, group)) {
        CustomVal.IsValid = false;
        CustomVal.ErrorMessage = (string)GetPageResourceObject("GroupNameHasBeenDefinedError");
        validToUpdate = false;
        NewGroupTextBox.Focus();
    }
    else {
        ProfileUtil.CreateGroup(propertySettings, group);
    }

    if (validToUpdate) {
        UpdateConfig(config);
        NewGroupTextBox.Text = null;
    }

    BindGroups();
}

private void BindGroups() {
    // TODO: Perf: It might not be needed if there are no groups.

    DataTable dataTable = new DataTable();
    dataTable.Locale = CultureInfo.InvariantCulture;  // FxCop
    dataTable.Columns.Add("Group", typeof(string));
    dataTable.Columns.Add("Local", typeof(bool));

    string appPath = ApplicationPath;
    string parentPath = GetParentPath(appPath);

    // Use the parent list to mark the properties that are inherited from parent
    // config where they should not be editable
    Configuration parentConfig = GetWebConfiguration(parentPath);
    ProfileSection parentProfile = (ProfileSection) parentConfig.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection parentPropertySettings = parentProfile.PropertySettings;
    ProfileGroupSettingsCollection parentGroupPropertySettings = parentPropertySettings.GroupSettings;

    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection propertySettings = profile.PropertySettings;

    foreach (ProfileGroupSettings group in propertySettings.GroupSettings) {
        DataRow row = dataTable.NewRow();
        row[0] = group.Name;
        row[1] = (parentGroupPropertySettings[group.Name] == null);
        dataTable.Rows.Add(row);
    }

    DataView dataView = new DataView(dataTable);

    if (IsSortUp) {
        dataView.Sort = "Group DESC";
    }
    else {
        dataView.Sort = "Group ASC";
    }
    
    GroupGridView.DataSource = dataView;
    GroupGridView.DataBind();

    // Display the label of # of properties
    int totalCount = dataView.Count;
    string numOfGroupsText = String.Format((string)GetPageResourceObject("NumOfGroupsLabel"), totalCount.ToString(CultureInfo.InvariantCulture));
    if (totalCount == 0) {
        NumOfGroupsLabel.Visible = true;
        NumOfGroupsLabel.Text = (string)GetPageResourceObject("NoGroupPropertiesLabel");
    }
    else if (totalCount <= GroupGridView.PageSize) {
        NumOfGroupsLabel.Visible = true;
        NumOfGroupsLabel.Text = numOfGroupsText;
    }
    else {
        // Merge the text in the pager row
        NumOfGroupsLabel.Visible = false;

        TableCell labelCell = new TableCell();
        labelCell.HorizontalAlign = HorizontalAlign.Left;
        labelCell.VerticalAlign = VerticalAlign.Top;
        labelCell.ColumnSpan = 2;
        labelCell.Text = numOfGroupsText;

        GridViewRow pagerRow = GroupGridView.BottomPagerRow;
        TableCell pagerCell = pagerRow.Cells[0];
        pagerCell.ColumnSpan -= 2;
        pagerRow.Cells.AddAt(0, labelCell);
    }
}

void GroupGridView_DataBound(object s, GridViewRowEventArgs e) {
    GridViewRow row = e.Row;
    if (IsSortUp) {
        if (row.RowType == DataControlRowType.Header) {
            Image sortImage = (Image) row.FindControl("SortImage");
            if (sortImage != null) {
                sortImage.ImageUrl = "~/Images/sortUp.gif";
            }
        }
    }
}

void GroupGridView_Delete(object source, GridViewDeleteEventArgs e) {
    GridViewRow row = GroupGridView.Rows[e.RowIndex];
    Literal groupLiteral = (Literal) row.FindControl("GroupLiteral");
    string group = groupLiteral.Text;
    PropertyGroup.Value = group;
    DeleteGroupConfirmation.Text = String.Format((string)GetPageResourceObject("DeleteGroupConfirmationText"), group);

    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");

    RootProfilePropertySettingsCollection propertySettings = profile.PropertySettings;
    StringCollection propertyNames = ProfileUtil.GetPropertyNamesFromGroup(propertySettings.GroupSettings, group);

    if (propertyNames.Count > 0) {
        PropertiesDataList.DataSource = propertyNames;
        PropertiesDataList.DataBind();
    }

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

void GroupGridView_Edit(object s, GridViewEditEventArgs e) {
    GridViewRow row = GroupGridView.Rows[e.NewEditIndex];
    Literal groupLiteral = (Literal) row.FindControl("GroupLiteral");
    Response.Redirect("EditGroup.aspx?group=" + HttpUtility.HtmlEncode(groupLiteral.Text.ToString()));
}

void GroupGridView_PageIndexChanged(object s, GridViewPageEventArgs e) {
    GroupGridView.PageIndex = e.NewPageIndex;
    BindGroups();
}

void GroupGridView_Sort(object s, GridViewSortEventArgs e) {
    // Mark the change of the sorting order
    IsSortUp = !IsSortUp;
    BindGroups();
}

void GroupNameValidity_ServerValidate(object source, ServerValidateEventArgs args) {
    args.IsValid = ProfileUtil.CheckNameForValidity(args.Value);
}

void Page_Load() {
    if (!IsPostBack) {
        BindGroups();
    }
}

// Confirmation's related handlers
void DeleteYes_Click(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection propertySettings = profile.PropertySettings;
    ProfileUtil.DeleteGroup(propertySettings, PropertyGroup.Value);
    UpdateConfig(config);

    // Re-populate data and return to the content page
    BindGroups();
    Master.SetDisplayUI(false);
}

void DeleteNo_Click(object s, EventArgs e) {
    BindGroups();
    Master.SetDisplayUI(false);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <asp:HiddenField runat="server" id="SortInfoField"/>

    <table height="100%" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table height="100%" width="100%" cellspacing="0" cellpadding="1">
                    <tr class="bodyText" height="1%">
                        <td>
                            <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/>
                        </td>
                    </tr>
                    <tr height="1%"><td>&nbsp;</td></tr>
                    <tr valign="top" align="left" height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all"
                                               bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                            <tr class="callOutStyle" align="left">
                                                <td>
                                                    <asp:Literal runat="server" Text="<%$ Resources:AddNewGroupTitle %>"/>
                                                </td>
                                            </tr>
                                            <tr class="bodyText" align="left">
                                                <td>
                                                    <%-- An invisible textbox at the end of the line is to submit the page on enter, raising server side onclick --%>
                                                    <asp:Label runat="server" AssociatedControlID="NewGroupTextBox" Text="<%$ Resources:NewGroupNameLabel %>"/>&nbsp;<asp:TextBox runat=server id="NewGroupTextBox"/>&nbsp;<asp:Button runat=server id="AddNewGroupButton" Text="<%$ Resources:AddNewGroupButtonLabel %>" OnClick="AddNewGroup_Click"/>&nbsp;<input type="text" style="visibility:hidden;width:0px;" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                        </td>
                    </tr>
                    <tr height="1%"><td>&nbsp;</td></tr>
                    <tr height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0"
                                   rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr align="left" valign="top">
                                    <td>
                                        <asp:GridView runat="server" id="GroupGridView" width="100%" cellspacing="0" cellpadding="5" border="0"
                                                      AutoGenerateColumns="false" OnRowDatabound="GroupGridView_DataBound"
                                                      OnRowDeleting="GroupGridView_Delete" OnRowEditing="GroupGridView_Edit"
                                                      AllowPaging="true" PageSize="7" OnPageIndexChanging="GroupGridView_PageIndexChanged"
                                                      AllowSorting="true" OnSorting="GroupGridView_Sort" UseAccessibleHeader="true">
                                            <rowstyle cssclass="gridRowStyle" />
                                            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                                            <pagersettings mode="Numeric" Position="Bottom" />
                                            <pagerstyle cssClass="gridPagerStyle" HorizontalAlign="Right" />
                                            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>

                                            <Columns>
                                                <asp:TemplateField HeaderText="<%$ Resources:DeleteGroupHeader %>" ItemStyle-Width="30%">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" commandname="Delete" forecolor="blue"
                                                                        text="<%$ Resources:DeleteButtonLabel %>" ToolTip="<%$ Resources:DeleteToolTip %>"
                                                                        Enabled='<%#DataBinder.Eval(Container.DataItem, "Local")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField ItemStyle-Width="30%">
                                                    <HeaderTemplate>
                                                        <asp:LinkButton runat="server" Text="<%$ Resources:GroupNameHeader %>" forecolor="white"
                                                                        CommandName="Sort" CausesValidation="false"/>
                                                        <asp:Image runat="server" id="SortImage" ImageUrl="~/Images/sortDown.gif"/>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:Literal runat="server" id="GroupLiteral" Text='<%#DataBinder.Eval(Container.DataItem, "Group")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="<%$ Resources:EditGroupPropertyHeader %>">
                                                    <ItemTemplate>
                                                        <asp:LinkButton id="EditGroupLink" runat="server" commandname="Edit" forecolor="blue"
                                                                        text="<%$ Resources:EditButtonLabel %>" ToolTip="<%$ Resources:EditToolTip %>"
                                                                        Enabled='<%#DataBinder.Eval(Container.DataItem, "Local")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:Gridview>
                                    </td>
                                </tr>
                                <tr class="gridPagerStyle" style="padding-left:5;">
                                    <td>
                                        <asp:Label runat="server" id="NumOfGroupsLabel"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="bodyText">
                        <td>
                            <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"/>
                            <asp:RequiredFieldValidator runat="server" EnableClientScript="false" ControlToValidate="NewGroupTextBox"
                                                        ErrorMessage="<%$ Resources:GroupNameRequiredError %>" Display="none"/>
                            <asp:CustomValidator runat="server" EnableClientScript="false" Display="none" ControlToValidate="NewGroupTextBox"
                                                 OnServerValidate="GroupNameValidity_ServerValidate"
                                                 ErrorMessage="<%$ Resources:GroupNameInvalidError %>"/>
                            <asp:CustomValidator runat="server" EnableClientScript="false" Display="none" Enabled="false" id="CustomVal"/>
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

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <asp:HiddenField runat=server id="PropertyGroup"/>
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td valign="top">
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:Literal runat="server" id="DeleteGroupConfirmation"/><br/><br/>
                <asp:DataList runat="server" id="PropertiesDataList" EnableViewState="False">
                    <HeaderStyle CssClass="bodyTextNoPadding"/>
                    <ItemStyle CssClass="bodyTextNoPadding" Font-Bold="true"/>

                    <HeaderTemplate>
                        <asp:Literal runat="server" Text="<%$ Resources:PropertyListHeader %>"/>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Container.DataItem %>
                    </ItemTemplate>
                </asp:DataList>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="DeleteYes_Click" Text="<%$ Resources:GlobalResources,YesButtonLabel %>" width="75"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="DeleteNo_Click" Text="<%$ Resources:GlobalResources,NoButtonLabel %>" width="75"/>
</asp:content>
