<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProfilePage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Diagnostics" %>
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

private void AddPropertyRow(DataTable dataTable,
                            string name, string group,
                            string dataType, bool local) {
    DataRow row = dataTable.NewRow();
    if (dataType == null || dataType.Length == 0) {
        dataType = "string";
    }
    else {
        dataType = GetFriendlyTypeName(dataType);
    }

    // Assume the columns are in expected order when the table is created
    row[0] = name;
    row[1] = group;
    row[2] = dataType;
    row[3] = local;

    dataTable.Rows.Add(row);
}

private void Alphabet_Click(object s, RepeaterCommandEventArgs e) {
    string searchText = (string) e.CommandArgument;
    if (searchText == "All") {
        SearchFilterField.Value = null;
    }
    else {
        SearchFilterField.Value = e.CommandArgument + "*'";
    }

    // Nice to have: change the letter appearance after it is clicked.
    // The code below is not complete yet.
/*    RepeaterItem repeaterItem = (RepeaterItem) e.Item;
    LinkButton linkButton = (LinkButton) repeaterItem.FindControl("alphabetLinkButton");
    if (linkButton != null) {
        linkButton.ForeColor = System.Drawing.Color.Empty;
    }
*/

    PropertyDataGrid.PageIndex = 0;
    BindProperties();
}

private void BindAlphabets() {
    // We only show the alphabet links if on English platform
    string cultureName = CultureInfo.CurrentCulture.Name;
    if (string.Compare("en", 0, cultureName, 0, 2, true, CultureInfo.InvariantCulture) != 0) {
        return;
    }

    ArrayList arr = new ArrayList();
    for (char c='A'; c <= 'Z'; c++) {
        arr.Add(c.ToString());
    }
    arr.Add("All");
    alphabetRepeater.DataSource = arr;
    alphabetRepeater.DataBind();
}

private void BindProperties() {
    // TODO: Perf: It might not be needed if there are no properties.

    DataTable dataTable = new DataTable();
    dataTable.Locale = CultureInfo.InvariantCulture;  // FxCop

    dataTable.Columns.Add("Name", typeof(string));
    dataTable.Columns.Add("Group", typeof(string));
    dataTable.Columns.Add("DataType", typeof(string));
    dataTable.Columns.Add("Local", typeof(bool));

    string appPath = ApplicationPath;
    string parentPath = GetParentPath(appPath);

    // Use the parent list to mark the properties that are inherited from parent
    // config where they should not be editable
    Configuration parentConfig = GetWebConfiguration(parentPath);
    ProfileSection parentProfile = (ProfileSection) parentConfig.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection parentPropertySettings = parentProfile.PropertySettings;
    ProfileGroupSettingsCollection parentGroupPropertySettings = parentPropertySettings.GroupSettings;

    Configuration config = GetWebConfiguration(appPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;

    foreach (ProfilePropertySettings property in profileElement) {
        bool local = (parentPropertySettings[property.Name] == null);
        AddPropertyRow(dataTable, property.Name, (string)GetPageResourceObject("NoGroupLabel"),
                       property.Type, local);
    }

    foreach (ProfileGroupSettings group in profileElement.GroupSettings) {
        bool local = (parentGroupPropertySettings[group.Name] == null);
        foreach (ProfilePropertySettings property in group.PropertySettings) {
            AddPropertyRow(dataTable, property.Name, group.Name, property.Type, local);
        }
    }

    DataView dataView = new DataView(dataTable);

    if (IsSortUp) {
        dataView.Sort = "Name DESC";
    }
    else {
        dataView.Sort = "Name ASC";
    }

    string searchFilter = SearchFilterField.Value;
    if (searchFilter != null && searchFilter.Length > 0) {
        dataView.RowFilter = "Name LIKE '" + searchFilter;
    }
    PropertyDataGrid.DataSource = dataView;
    PropertyDataGrid.DataBind();

    // Display the label of # of properties
    int totalCount = dataView.Count;
    string numOfPropertiesText = String.Format((string)GetPageResourceObject("NumOfPropertiesLabel"), totalCount.ToString(CultureInfo.InvariantCulture));
    if (totalCount <= PropertyDataGrid.PageSize) {
        NumOfPropertiesLabel.Visible = true;
        NumOfPropertiesLabel.Text = numOfPropertiesText;
    }
    else {
        // Merge the text in the pager row
        NumOfPropertiesLabel.Visible = false;

        TableCell labelCell = new TableCell();
        labelCell.HorizontalAlign = HorizontalAlign.Left;
        labelCell.VerticalAlign = VerticalAlign.Top;
        labelCell.ColumnSpan = 4;
        labelCell.Text = numOfPropertiesText;

        GridViewRow pagerRow = PropertyDataGrid.BottomPagerRow;
        TableCell pagerCell = pagerRow.Cells[0];
        pagerCell.ColumnSpan -= 4;
        pagerRow.Cells.AddAt(0, labelCell);
    }
}

string GetFriendlyTypeName(string typeName) {
    string resolvedName = ProfileUtil.ResolveFullTypeName(typeName);
    if (resolvedName != null) {
        resolvedName = ProfileUtil.ResolveFriendlyTypeName(resolvedName);
        Debug.Assert(resolvedName != null);
    }
    return (resolvedName == null) ? typeName : resolvedName;
}

void Page_Load() {
    if (!IsPostBack) {
        BindAlphabets();
        BindProperties();
    }
}

void PropertyDataGrid_DataBound(object s, GridViewRowEventArgs e) {
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

void PropertyDataGrid_Delete(object source, GridViewDeleteEventArgs e) {
    GridViewRow row = PropertyDataGrid.Rows[e.RowIndex];
    Label nameLabel = (Label) row.FindControl("NameLabel");
    TableCell groupCell = row.Cells[3];

    PropertyName.Value = nameLabel.Text;
    DeletePropertyConfirmation.Text = String.Format((string)GetPageResourceObject("DeletePropertyConfirmationText"), nameLabel.Text);

    // GetPageResourceObject decode special character such as &lt; and &gt;
    // so we need to do the same before comparison.
    // REVIEW: Should we use some XML decode method instead?
    string group = HttpUtility.HtmlDecode(groupCell.Text);
    if (group != (string)GetPageResourceObject("NoGroupLabel")) {
        PropertyGroup.Value = group;
    }
    else {
        PropertyGroup.Value = null;
    }

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

void PropertyDataGrid_Edit(object s, GridViewEditEventArgs e) {
    string editUrl = "EditProperty.aspx?name=";

    GridViewRow row = PropertyDataGrid.Rows[e.NewEditIndex];
    Label nameLabel = (Label) row.FindControl("NameLabel");
    TableCell groupCell = row.Cells[3];

    editUrl += HttpUtility.HtmlEncode(nameLabel.Text.ToString());
    string group = HttpUtility.HtmlDecode(groupCell.Text);
    if (group != (string)GetPageResourceObject("NoGroupLabel")) {
        editUrl += "&group=" + HttpUtility.HtmlEncode(group);
    }

    Response.Redirect(editUrl);
}

void PropertyDataGrid_PageIndexChanged(object s, GridViewPageEventArgs e) {
    PropertyDataGrid.PageIndex = e.NewPageIndex;
    BindProperties();
}

void PropertyDataGrid_Sort(object s, GridViewSortEventArgs e) {
    // Mark the change of the sorting order
    IsSortUp = !IsSortUp;
    BindProperties();
}

void Search_Click(object s, EventArgs e) {
    string searchFilter = SearchFilterTextBox.Text;
    if (searchFilter != null && searchFilter.Length > 0) {
        SearchFilterField.Value = "*" + searchFilter + "*'";
    }
    PropertyDataGrid.PageIndex = 0;
    BindProperties();
    SearchFilterTextBox.Focus();
}

// Confirmation's related handlers
void Yes_Click(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;
    ProfileUtil.DeleteProperty(profileElement, PropertyName.Value, PropertyGroup.Value);
    UpdateConfig(config);

    // Before data binding again, we need to adjust the current page index if
    // this is the last property to be deleted on this page
    if (PropertyDataGrid.PageIndex != 0) {
        int totalCount = PropertyDataGrid.Rows.Count - 1;
        if ((totalCount % PropertyDataGrid.PageSize) == 0) {
            PropertyDataGrid.PageIndex -= 1;
        }
    }

    // Re-populate data and return to the content page
    BindProperties();
    Master.SetDisplayUI(false);
}

void No_Click(object s, EventArgs e) {
    BindProperties();
    Master.SetDisplayUI(false);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <asp:HiddenField runat="server" id="SortInfoField"/>
    <asp:HiddenField runat="server" id="SearchFilterField"/>

    <table height="100%" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table height="100%" width="100%" cellspacing="0" cellpadding="1">
                    <tr class="bodyText" valign="top" align="left" height="1%">
                        <td>
                            <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/>
                        </td>
                    </tr>
                    <tr height="20"><td/></tr>
                    <tr valign="top" align="left" height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0" >
                                <tr>
                                    <td>
                                        <table cellspacing="0" height="100%" width="100%" cellpadding="4"
                                               class="lrbBorders" >
                                                <tr>
                                                    <td class="callOutStyle"><asp:Literal runat="server" Text="<%$ Resources:FindPropertiesTitle %>"/></td>
                                                </tr>
                                            <tr >
                                                <td class="bodyTextLowTopPadding">
                                                    <%-- An invisible textbox at the end of the line is to submit the page on enter, raising server side onclick --%>
                                                    <asp:Label runat="server" AssociatedControlID="SearchFilterTextBox" Text="<%$ Resources:FindPropertyLabel %>"/>&nbsp;<asp:TextBox runat=server id="SearchFilterTextBox"/>&nbsp;<asp:Button runat=server Text="<%$ Resources:GlobalResources,SearchButtonLabel %>" OnClick="Search_Click"/>&nbsp;<input type="text" style="visibility:hidden;width:0px;" /><br/>
                                                    <asp:repeater runat="server" id="alphabetRepeater" onitemcommand="Alphabet_Click">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" id="alphabetLinkButton" forecolor="blue" CausesValidation="false"
                                                                commandargument="<%#Container.DataItem%>" text="<%#Container.DataItem%>"/>
                                                            &nbsp;
                                                        </ItemTemplate>
                                                    </asp:repeater>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr height="15"><td/></tr>
                    <tr height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0"
                                   rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">

                                <tr align="left" valign="top">
                                    <td class="lbBorders">
                                        <asp:GridView runat="server" id="PropertyDataGrid" width="100%" cellspacing="0" cellpadding="5" border="0"
                                                      AutoGenerateColumns="false" OnRowDatabound="PropertyDataGrid_DataBound"
                                                      OnRowDeleting="PropertyDataGrid_Delete" OnRowEditing="PropertyDataGrid_Edit"
                                                      AllowPaging="true" PageSize="7" OnPageIndexChanging="PropertyDataGrid_PageIndexChanged"
                                                      AllowSorting="true" OnSorting="PropertyDataGrid_Sort" UseAccessibleHeader="true">
                                            <rowstyle cssclass="gridRowStyle" />
                                            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                                            <pagersettings mode="Numeric" Position="Bottom" />
                                            <pagerstyle cssClass="gridPagerStyle" HorizontalAlign="Right" />
                                            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>

                                            <Columns>
                                                <asp:TemplateField ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" commandname="Delete" forecolor="blue"
                                                                        text="<%$ Resources:GlobalResources,DeleteButtonLabel %>"
                                                                        ToolTip="<%$ Resources:DeleteToolTip %>"
                                                                        Enabled='<%#DataBinder.Eval(Container.DataItem, "Local")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField ItemStyle-Width="25%">
                                                    <HeaderTemplate>
                                                        <asp:LinkButton runat="server" Text="<%$ Resources:PropertyNameHeader %>" CommandName="Sort" forecolor="white" CausesValidation="false"/>
                                                        <asp:Image runat="server" id="SortImage" ImageUrl="~/Images/sortDown.gif"/>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" id="NameLabel" Text='<%#DataBinder.Eval(Container.DataItem, "Name")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" commandname="Edit" forecolor="blue"
                                                                        text="<%$ Resources:GlobalResources,EditButtonLabel %>"
                                                                        ToolTip="<%$ Resources:EditToolTip %>"
                                                                        Enabled='<%#DataBinder.Eval(Container.DataItem, "Local")%>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:BoundField HeaderText="<%$ Resources:MemberOfGroupHeader %>" DataField="Group" ItemStyle-Width="25%"/>

                                                <asp:BoundField HeaderText="<%$ Resources:DataTypeHeader %>" DataField="DataType"/>
                                            </Columns>
                                        </asp:Gridview>
                                    </td>
                                </tr>
                                <tr class="gridPagerStyle" style="padding-left:5;">
                                    <td>
                                        <asp:Label runat="server" id="NumOfPropertiesLabel"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="bodyText" valign="top" align="left">
                        <td>
                            <asp:HyperLink runat=server NavigateUrl="CreateProperty.aspx" Text="<%$ Resources:CreatePropertyLinkText %>"/>
                        <td>
                    </tr>
                    <tr class="bodyText">
                        <td>
                            <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"/>
                            <asp:RequiredFieldValidator runat="server" EnableClientScript="false" ControlToValidate="SearchFilterTextBox"
                                                        ErrorMessage="<%$ Resources:PropertyNameToSearchRequiredError %>" Display="none"/>
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
    <asp:HiddenField runat="server" id="PropertyGroup"/>
    <asp:HiddenField runat="server" id="PropertyName"/>
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td>
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:Literal runat=server id="DeletePropertyConfirmation"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="Yes_Click" Text="<%$ Resources:GlobalResources,YesButtonLabel %>" width="100"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="No_Click" Text="<%$ Resources:GlobalResources,NoButtonLabel %>" width="75"/>
</asp:content>
