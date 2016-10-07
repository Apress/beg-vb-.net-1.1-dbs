<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProvidersPage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Register TagPrefix="uc" TagName="ProviderList" Src="ProviderList.ascx"%>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private int _parentProviderCount = 0;

private string CurrentProvider {
    get {
        return (string)Session["WebAdminManageConsolidatedProvidersCurrentProvider"];
    }
    set {
        Session["WebAdminManageConsolidatedProvidersCurrentProvider"] = value;
    }
}



private void BackToPreviousPage(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

private void BindProviderList(ProviderListUserControl providerList) {
    string appPath = ApplicationPath;
    int trailingSlash = appPath.LastIndexOf("/");
    string parentAppPath = appPath.Substring(0, trailingSlash);
    if (parentAppPath != null && parentAppPath.Length == 0) {
        parentAppPath = null;
    }

    Configuration config = GetWebConfiguration(appPath);
    MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");

  
    Configuration parentConfig = GetWebConfiguration(parentAppPath);
    MembershipSection membershipParentSection = (MembershipSection)parentConfig.GetSection("system.web/membership");
    RoleManagerSection roleManagerParentSection = (RoleManagerSection)parentConfig.GetSection("system.web/roleManager");
    ProfileSection profileParentSection = (ProfileSection)parentConfig.GetSection("system.web/profile");
    SiteCountersSection siteCountersParentSection = (SiteCountersSection)parentConfig.GetSection("system.web/siteCounters");

    ProviderSettingsCollection providers = new ProviderSettingsCollection();

    ProviderSettingsCollection membershipProviders = membershipSection.Providers;
    ProviderSettingsCollection roleManagerProviders = roleManagerSection.Providers;
    ProviderSettingsCollection profileProviders = profileSection.Providers;
    ProviderSettingsCollection siteCountersProviders = siteCountersSection.Providers;

    
    ProviderSettingsCollection membershipParentProviders = membershipParentSection.Providers;
    ProviderSettingsCollection roleManagerParentProviders = roleManagerParentSection.Providers;
    ProviderSettingsCollection profileParentProviders = profileParentSection.Providers;
    ProviderSettingsCollection siteCountersParentProviders = siteCountersParentSection.Providers;

    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");

    foreach (System.Configuration.ProviderSettings mps in membershipProviders) {
        string name = mps.Name;
        string connectionString = mps.Parameters["connectionStringName"];
        
        if (!HasProviderInProviderSettings(roleManagerProviders, name, connectionString) ||
            !HasProviderInProviderSettings(profileProviders, name, connectionString) ||
            !HasProviderInProviderSettings(siteCountersProviders, name, connectionString)) {
            continue;
        }

        providers.Add(mps);

        // Check if the same provider shows up in the parent config.
        if (!HasProviderInProviderSettings(membershipParentProviders, name, connectionString) ||
            !HasProviderInProviderSettings(roleManagerParentProviders, name, connectionString) ||
            !HasProviderInProviderSettings(profileParentProviders, name, connectionString) ||
            !HasProviderInProviderSettings(siteCountersParentProviders, name, connectionString)) {
            continue;
        }

        // The provider also exists in the parent config.

        string cs = GetConnectionString(connectionString /* name of the connection string */);        
        if (mps.Type.Contains("SqlMembershipProvider")) {
            string server, db;
            ParseSqlConnectionString(cs, out server, out db);
            if (server == "127.0.0.1") {
                server = "&lt;localhost&gt;";
            }
            StringBuilder builder = new StringBuilder();
            if (server != null && server.Length > 0) {
                builder.Append("<b>Server:</b> " + server + "<br/>");
            }
            if (db != null && db.Length > 0) {
                builder.Append("<b>Database:</b> " + db);
            }
            mps.Parameters["description"] = builder.ToString();
        }
        else {
            string file = ParseAccessConnectionString(cs);
            mps.Parameters["description"] = file;
        }

        _parentProviderCount++;
    }

    providerList.DataSource = providers;
    providerList.ParentProviderCount = _parentProviderCount;
    string defaultProvider = membershipSection.DefaultProvider;
    if ((defaultProvider == roleManagerSection.DefaultProvider) && (defaultProvider == profileSection.DefaultProvider)) {

        for (int i = 0; i < providers.Count; i++) {
            if (providers[i].Name == defaultProvider) {
                providerList.SelectedIndex = i;
            }
        }

        Session["DefaultProvider"] = defaultProvider;
    }
    providerList.DataBind();
}

private void BindProviderLists() {
    BindProviderList(ProviderList);
}

private void DeleteProvider(object s, ProviderListUserControl.ProviderEventArgs e) {
    string service = null;
    areYouSureLiteral.Text = String.Format((string)GetPageResourceObject("AreYouSure"), e.ProviderName);
    CurrentProvider = e.ProviderName;
    DeleteYesButton.CommandArgument = e.ServiceName;
    mv1.ActiveViewIndex = 0;
    BindProviderLists();
    Master.SetDisplayUI(true);
}

private bool HasProviderInProviderSettings(ProviderSettingsCollection providerSettings, string name, string connectionString) {
    bool found = false;
    foreach (System.Configuration.ProviderSettings ps in providerSettings) {
        if (ps.Name == name && ps.Parameters["connectionStringName"] == connectionString) {
            found = true;
            break;
        }
    }
    return found;
}

private void Page_Load() {
    if (!IsPostBack) {
        BindProviderLists();
    }
}

private void SelectProvider(object s, ProviderListUserControl.ProviderEventArgs e) {
    RadioButton radioButton = (RadioButton) s;
    Configuration config = GetWebConfiguration(ApplicationPath);

    MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    PageCountersElement pageCountersElement = siteCountersSection.PageCounters;

    membershipSection.DefaultProvider = e.ProviderName;
    roleManagerSection.DefaultProvider = e.ProviderName;
    profileSection.DefaultProvider = e.ProviderName;
    siteCountersSection.DefaultProvider = e.ProviderName;
    pageCountersElement.DefaultProvider = null;  // By default it will picks up the one from SiteCounters

    UpdateConfig(config);
    BindProviderLists();
}

void DeleteYesButton_Command(object s, CommandEventArgs e) {
    string defaultProvider = (string)Session["DefaultProvider"];
    Configuration config = GetWebConfiguration(ApplicationPath);
        
    MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    PageCountersElement pageCountersElement = siteCountersSection.PageCounters;

    if (defaultProvider == membershipSection.DefaultProvider) {
        membershipSection.DefaultProvider = null;
    }
    if (defaultProvider == roleManagerSection.DefaultProvider) {
        roleManagerSection.DefaultProvider = null;
    }
    if (defaultProvider == profileSection.DefaultProvider) {
        profileSection.DefaultProvider = null;
    }
    if (defaultProvider == siteCountersSection.DefaultProvider) {
        siteCountersSection.DefaultProvider = null;
    }
    if (defaultProvider == pageCountersElement.DefaultProvider) {
        pageCountersElement.DefaultProvider = null;
    }
    string currentProvider = CurrentProvider;
    membershipSection.Providers.Remove(currentProvider);
    roleManagerSection.Providers.Remove(currentProvider);
    profileSection.Providers.Remove(currentProvider);
    siteCountersSection.Providers.Remove(currentProvider);

    UpdateConfig(config);
    BindProviderLists();
    Master.SetDisplayUI(false);
}

void DeleteNoButton_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

private void TestConnection(object s, EventArgs e) {
    bool good = base.TestConnection(s, e);
    LinkButton b = (LinkButton) s;
    bool isSql = b.CommandName.Contains("Sql");
    string servername, database;
    string connectionString = GetConnectionString(b.CommandArgument);
    if (isSql) {
        ParseSqlConnectionString(connectionString, out servername, out database);
    }
    else {
        database = ParseAccessConnectionString(connectionString);
    }

    mv1.ActiveViewIndex = 1;
    testConnectionLiteral.Text = TestConnectionText(good, isSql, database);

    OKButton.Visible = true;
    DeleteYesButton.Visible = false;
    DeleteNoButton.Visible = false;
    Master.SetDisplayUI(true /* confirmation */);
}

private void OK_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:literal runat="server" text="<%$ Resources:ManageProviders %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="10" width="100%" cellspacing="0" cellpadding="0" valign="top" align="left">
        <tr class="bodyTextNoPadding" height="1%">
            <td>
                <asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr><td>&nbsp</td></tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="ProviderList"
                                 HeaderText="<%$ Resources:Provider %>"
                                 ServiceName="all"
                                 AddProviderLinkText="<%$ Resources:AddNewProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:GlobalResources,BackButtonLabel %>" id="BackButton" onclick="BackToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
<asp:literal runat="server" text="<%$ Resources:ProviderManagement %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <asp:multiview runat="server" id="mv1" enableViewState="false" activeViewIndex="0">
    <asp:view runat="server">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td valign="top">
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:literal runat="server" id="areYouSureLiteral"/>
            </td>
        </tr>
    </table>
    </asp:view>
    <asp:view runat="server">
        <asp:label runat="server" id="testConnectionLiteral"/>
    </asp:view>
    </asp:multiview>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" id="DeleteYesButton" enableViewState="false" OnCommand="DeleteYesButton_Command" Text="<%$ Resources:Yes %>" width="75"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" id="DeleteNoButton" enableViewState="false" OnClick="DeleteNoButton_Click" Text="<%$ Resources:No %>" width="75"/>
    <asp:Button runat="server" id="OKButton" enableViewState="false" OnClick="OK_Click" Text="<%$ Resources:OK %>" visible="false" width="75"/>
</asp:content>
