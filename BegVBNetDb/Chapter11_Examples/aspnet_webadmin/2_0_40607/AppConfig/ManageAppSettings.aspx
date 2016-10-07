<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private enum LocationType {
    Local = 0,
    Inherited = 1,
    Overridden = 2,
}

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private void AddAppSettingRow(DataTable dataTable, string name, string value, LocationType locationType) {
    DataRow row = dataTable.NewRow();

    // Assume the columns are in expected order when the table is created
    row[0] = name;
    row[1] = value;
    row[2] = locationType;

    dataTable.Rows.Add(row);
}

private void BindAppSettings() {
    // TODO: Perf: It might not be needed if there are no application settings.

    DataTable dataTable = new DataTable();
    dataTable.Locale = CultureInfo.InvariantCulture;  // FxCop

    dataTable.Columns.Add("Name", typeof(string));
    dataTable.Columns.Add("Value", typeof(string));
    dataTable.Columns.Add("LocationType", typeof(LocationType));

    string appPath = ApplicationPath;
    string parentPath = GetParentPath(appPath);

    Configuration parentConfig = GetWebConfiguration(parentPath);
    AppSettingsSection parentAppSettingsSection = (AppSettingsSection) parentConfig.GetSection("appSettings");
    NameValueCollection parentSettings = parentAppSettingsSection.Settings;

    Configuration config = GetWebConfiguration(appPath);
    AppSettingsSection appSettingsSection = (AppSettingsSection) config.GetSection("appSettings");
    NameValueCollection settings = appSettingsSection.Settings;

    for (int i = 0; i < settings.Count; i++) {
        string name = settings.GetKey(i);
        string value = settings[name];
        string parentValue = parentSettings[name];
        if (parentValue != null && parentValue != value) {
            AddAppSettingRow(dataTable, name, value, LocationType.Overridden);
            parentSettings.Remove(name);
        }
        else if (parentValue == null) {
            AddAppSettingRow(dataTable, name, value, LocationType.Local);
        }
        else {
            // we have something which is getting inherited but not getting overridden...
            AddAppSettingRow(dataTable, name, value, LocationType.Inherited);
        }
    }

    DataView dataView = new DataView(dataTable);
    dataView.Sort = "Name ASC";

    AppSettingGridView.DataSource = dataView;
    AppSettingGridView.DataBind();

    // Display the label of # of app settings
    int totalCount = dataView.Count;
    string numOfAppSettingsText = String.Format((string)GetPageResourceObject("NumOfAppSettingsText"), totalCount.ToString(CultureInfo.InvariantCulture));
    if (totalCount <= AppSettingGridView.PageSize) {
        NumOfAppSettingsLabel.Visible = true;
        NumOfAppSettingsLabel.Text = numOfAppSettingsText;
    }
    else {
        // Merge the text in the pager row
        NumOfAppSettingsLabel.Visible = false;

        TableCell labelCell = new TableCell();
        labelCell.HorizontalAlign = HorizontalAlign.Left;
        labelCell.VerticalAlign = VerticalAlign.Top;
        labelCell.ColumnSpan = 4;
        labelCell.Text = numOfAppSettingsText;

        GridViewRow pagerRow = AppSettingGridView.BottomPagerRow;
        TableCell pagerCell = pagerRow.Cells[0];
        pagerCell.ColumnSpan -= 4;
        pagerRow.Cells.AddAt(0, labelCell);
    }
}

void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        if (appPath != null && !appPath.Equals(String.Empty)) {
            MainTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        BindAppSettings();
    }
}

void AppSettingGridView_Delete(object source, GridViewDeleteEventArgs e) {
    GridViewRow row = AppSettingGridView.Rows[e.RowIndex];
    TableCell nameCell = row.Cells[1];
    Name.Value = nameCell.Text;
    DeleteName.Text = String.Format((string)GetPageResourceObject("ConfirmationText"), nameCell.Text);

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

void AppSettingGridView_Edit(object s, GridViewEditEventArgs e) {
    StringBuilder editUrl = new StringBuilder();
    editUrl.Append("EditAppSetting.aspx?name=");

    GridViewRow row = AppSettingGridView.Rows[e.NewEditIndex];
    TableCell nameCell = row.Cells[1];
    editUrl.Append(HttpUtility.HtmlEncode(nameCell.Text.ToString()));

    editUrl.Append("&value=");
    TableCell valueCell = row.Cells[2];
    editUrl.Append(HttpUtility.HtmlEncode(valueCell.Text.ToString()));

    Response.Redirect(editUrl.ToString());
}

void AppSettingGridView_PageIndexChanged(object s, GridViewPageEventArgs e) {
    AppSettingGridView.PageIndex = e.NewPageIndex;
    BindAppSettings();
}

// Confirmation's related handlers
void Yes_Click(object s, EventArgs e) {

    string appPath = ApplicationPath;
    string parentPath = GetParentPath(appPath);

    Configuration parentConfig = GetWebConfiguration(parentPath);
    AppSettingsSection parentAppSettingsSection = (AppSettingsSection) parentConfig.GetSection("appSettings");
    NameValueCollection parentSettings = parentAppSettingsSection.Settings;
    
    Configuration config = GetWebConfiguration(ApplicationPath);
    AppSettingsSection appSettingsSection = (AppSettingsSection) config.GetSection("appSettings");

    // check if this is an inherited setting that
    // we are trying to remove.
    string parentValue = parentSettings[Name.Value];
    if (parentValue != null) {
        // add an identical entry that the parent already has, so local entry gets deleted
        appSettingsSection.Settings[Name.Value] = parentValue;
    }
    else {
        appSettingsSection.Settings.Remove(Name.Value);
    }
    
    UpdateConfig(config);

    // Before data binding again, we need to adjust the current page index if
    // this is the last property to be deleted on this page
    if (AppSettingGridView.PageIndex != 0) {
        int totalCount = AppSettingGridView.Rows.Count - 1;
        if ((totalCount % AppSettingGridView.PageSize) == 0) {
            AppSettingGridView.PageIndex -= 1;
        }
    }

    // Re-populate data and return to the content page
    BindAppSettings();
    Master.SetDisplayUI(false);
}

void No_Click(object s, EventArgs e) {
    BindAppSettings();
    Master.SetDisplayUI(false);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" id="MainTitle" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
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
                    <tr height="1%">
                        <td>
                            <table height="100%" width="100%" cellspacing="0" cellpadding="0"
                                   rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr align="left" valign="top">
                                    <td class="lbBorders">
                                        <asp:GridView runat="server" id="AppSettingGridView" width="100%" cellspacing="0" cellpadding="5" border="0"
                                                      AutoGenerateColumns="false"
                                                      OnRowDeleting="AppSettingGridView_Delete" OnRowEditing="AppSettingGridView_Edit"
                                                      AllowPaging="true" PageSize="7" OnPageIndexChanging="AppSettingGridView_PageIndexChanged"
                                                      UseAccessibleHeader="true">
                                            <rowstyle cssclass="gridRowStyle" />
                                            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                                            <pagersettings mode="Numeric" Position="Bottom" />
                                            <pagerstyle cssClass="gridPagerStyle" HorizontalAlign="Right" />
                                            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>

                                            <Columns>
                                                <asp:TemplateField ItemStyle-Width="15%" HeaderText="<%$ Resources:SourceHeader %>">
                                                    <ItemTemplate>
                                                        <%# PropertyConverter.EnumToString(typeof(LocationType), DataBinder.Eval(Container.DataItem, "LocationType"))%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:BoundField HeaderText="<%$ Resources:NameHeader %>" DataField="Name" ItemStyle-Width="20%"/>

                                                <asp:BoundField HeaderText="<%$ Resources:ValueHeader %>" DataField="Value" ItemStyle-Width="20%"/>

                                                <asp:TemplateField ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" commandname="Edit" forecolor="blue"
                                                                        Text='<%# (((LocationType) DataBinder.Eval(Container.DataItem, "LocationType")) == LocationType.Inherited) ? (string)GetPageResourceObject("OverrideLinkText") : (string)GetPageResourceObject("EditLinkText") %>'
                                                                        ToolTip='<%# (((LocationType) DataBinder.Eval(Container.DataItem, "LocationType")) == LocationType.Inherited) ? (string)GetPageResourceObject("OverrideLinkToolTip") : (string)GetPageResourceObject("EditLinkToolTip") %>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" commandname="Delete" forecolor="blue"
                                                                        Text="<%$ Resources:DeleteLinkText %>" ToolTip="<%$ Resources:DeleteLinkToolTip %>"
                                                                        Enabled='<%# (((LocationType) DataBinder.Eval(Container.DataItem, "LocationType")) == LocationType.Inherited) ? false : true %>'/>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:Gridview>
                                    </td>
                                </tr>
                                <tr class="gridPagerStyle" style="padding-left:5;">
                                    <td>
                                        <asp:Label runat="server" id="NumOfAppSettingsLabel"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="bodyText" valign="top" align="left">
                        <td>
                            <asp:HyperLink runat="server" NavigateUrl="CreateAppSetting.aspx" Text="<%$ Resources:CreateAppSettingLinkText %>"/>
                        <td>
                    </tr>
                </table>
            </td>
            <td width="100"/>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:Button Text="<%$ Resources:GlobalResources,BackButtonLabel %>" id="BackButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:Literal runat="server" Text="<%$ Resources:DeleteAppSettingTitle %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <asp:HiddenField runat="server" id="Name"/>
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td>
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:Literal runat="server" id="DeleteName"/>
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
