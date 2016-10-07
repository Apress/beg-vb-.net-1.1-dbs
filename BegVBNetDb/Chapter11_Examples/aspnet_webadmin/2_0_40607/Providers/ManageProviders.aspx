<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProvidersPage"%>
<%@ Register TagPrefix="uc" TagName="ProviderList" Src="ProviderList.ascx"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">
private void BackToPreviousPage(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

private void BindProviderList(ProviderSettingsCollection providers,
                              string defaultProvider,
                              ProviderListUserControl providerList) {
    providerList.DataSource = providers;
    int i = 0;
    foreach(System.Configuration.ProviderSettings ps in providers){    
        if (ps.Name == defaultProvider) {
            providerList.SelectedIndex = i;
        }
        i++;
    }
    providerList.DataBind();
}

private void BindProviderLists() {
    Configuration config = GetWebConfiguration(ApplicationPath);

    MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
    MembershipProviderList.ParentProviderCount = ParentProviderCount("membership");
    BindProviderList(membershipSection.Providers, membershipSection.DefaultProvider, MembershipProviderList);

    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    RoleProviderList.ParentProviderCount = ParentProviderCount("roleManager");
    BindProviderList(roleManagerSection.Providers, roleManagerSection.DefaultProvider, RoleProviderList);

    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    ProfileProviderList.ParentProviderCount = ParentProviderCount("profile");
    BindProviderList(profileSection.Providers, profileSection.DefaultProvider, ProfileProviderList);

    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    SiteCountersProviderList.ParentProviderCount = ParentProviderCount("siteCounters");
    BindProviderList(siteCountersSection.Providers, siteCountersSection.DefaultProvider, SiteCountersProviderList);

    PageCountersProviderList.ParentProviderCount = SiteCountersProviderList.ParentProviderCount;
    string pageCountersDefaultProvider = siteCountersSection.PageCounters.DefaultProvider;
    if (pageCountersDefaultProvider == null || pageCountersDefaultProvider.Length == 0) {
        pageCountersDefaultProvider = siteCountersSection.DefaultProvider;
    }
    BindProviderList(siteCountersSection.Providers, pageCountersDefaultProvider, PageCountersProviderList);
}

private void DeleteProvider(object s, ProviderListUserControl.ProviderEventArgs e) {
    string service;
    switch (e.ServiceName) {
        case "membership":
            service = "Membership";
            break;
        case "roleManager":
            service = "RoleManager";
            break;
        case "profile":
            service = "Profile";
            break;
        case "siteCounters":
            service = "SiteCounters";
            break;
        case "pageCounters":
            service = "PageCounters";
            break;
        default:
            throw new HttpException("Unrecognizable service name: " + e.ServiceName);
    }

    areYouSureLiteral.Text = String.Format((string)GetPageResourceObject("AreYouSure"), service, e.ProviderName);
    DeleteYesButton.Visible = true;
    DeleteYesButton.CommandName = e.ProviderName;
    DeleteYesButton.CommandArgument = e.ServiceName;
    mv1.ActiveViewIndex = 0;
    BindProviderLists();
    Master.SetDisplayUI(true);
}

private void Page_Load() {
    if (!IsPostBack) {
        BindProviderLists();
    }
}

private void SelectProvider(object s, ProviderListUserControl.ProviderEventArgs e) {
    RadioButton radioButton = (RadioButton) s;

    Configuration config = GetWebConfiguration(ApplicationPath);
    switch (e.ServiceName) {
        case "membership":
            MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
            membershipSection.DefaultProvider = e.ProviderName;
            break;
        case "roleManager":
            RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
            roleManagerSection.DefaultProvider = e.ProviderName;
            break;
        case "profile":
            ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
            profileSection.DefaultProvider = e.ProviderName;
            break;
        case "siteCounters":
            SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
            siteCountersSection.DefaultProvider = e.ProviderName;
            break;
        case "pageCounters":
            siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
            siteCountersSection.PageCounters.DefaultProvider = e.ProviderName;
            break;
        default:
            throw new HttpException("Unrecognizable service name: " + e.ServiceName);
    }

    UpdateConfig(config);
    BindProviderLists();
}

// Confirmation's related handlers
void DeleteYesButton_Command(object s, CommandEventArgs e) {
    string appPath = ApplicationPath;
    string parentPath = GetParentPath(appPath);
    Configuration parentConfig = GetWebConfiguration(parentPath);
    Configuration config = GetWebConfiguration(appPath);
    switch ((string)e.CommandArgument) {
        case "membership":
            MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
            membershipSection.Providers.Remove(e.CommandName);

            if (membershipSection.DefaultProvider == e.CommandName) {
                MembershipSection membershipParentSection = (MembershipSection)parentConfig.GetSection("system.web/membership");
                membershipSection.DefaultProvider = membershipParentSection.DefaultProvider;
            }
            break;
        case "roleManager":
            RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
            roleManagerSection.Providers.Remove(e.CommandName);

            if (roleManagerSection.DefaultProvider == e.CommandName) {
                RoleManagerSection roleManagerParentSection = (RoleManagerSection)parentConfig.GetSection("system.web/roleManager");
                roleManagerSection.DefaultProvider = roleManagerParentSection.DefaultProvider;
            }
            break;
        case "profile":
            ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
            profileSection.Providers.Remove(e.CommandName);

            if (profileSection.DefaultProvider == e.CommandName) {
                ProfileSection profileParentSection = (ProfileSection)parentConfig.GetSection("system.web/profile");
                profileSection.DefaultProvider = profileParentSection.DefaultProvider;
            }
            break;
        case "siteCounters":
            SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
            siteCountersSection.Providers.Remove(e.CommandName);
            SiteCountersSection siteCountersParentSection = (SiteCountersSection)parentConfig.GetSection("system.web/siteCounters");

            if (siteCountersSection.DefaultProvider == e.CommandName) {
                siteCountersSection.DefaultProvider = siteCountersParentSection.DefaultProvider;
            }

            if (siteCountersSection.PageCounters.DefaultProvider == e.CommandName) {
                siteCountersSection.PageCounters.DefaultProvider = siteCountersParentSection.PageCounters.DefaultProvider;
            }
            break;
        case "pageCounters":
            siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
            siteCountersSection.Providers.Remove(e.CommandName);
            siteCountersParentSection = (SiteCountersSection)parentConfig.GetSection("system.web/siteCounters");

            if (siteCountersSection.PageCounters.DefaultProvider == e.CommandName) {
                siteCountersSection.PageCounters.DefaultProvider = siteCountersParentSection.PageCounters.DefaultProvider;
            }

            if (siteCountersSection.DefaultProvider == e.CommandName) {
                siteCountersSection.DefaultProvider = siteCountersParentSection.DefaultProvider;
            }
            break;
        default:
            throw new HttpException("Unrecognizable service name: " + e.CommandArgument);
    }

    UpdateConfig(config);
    BindProviderLists();
    Master.SetDisplayUI(false);
}

void DeleteNoButton_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

private int ParentProviderCount(string serviceName) {
    string parentPath = GetParentPath(ApplicationPath);
    Configuration parentConfig = GetWebConfiguration(parentPath);
    switch (serviceName) {
        case "membership":
            MembershipSection membershipSection = (MembershipSection)parentConfig.GetSection("system.web/membership");
            return membershipSection.Providers.Count;
        case "roleManager":
            RoleManagerSection roleManagerSection = (RoleManagerSection)parentConfig.GetSection("system.web/roleManager");
            return roleManagerSection.Providers.Count;
        case "profile":
            ProfileSection profileSection = (ProfileSection)parentConfig.GetSection("system.web/profile");
            return profileSection.Providers.Count;
        case "siteCounters":
        case "pageCounters":
            SiteCountersSection siteCountersSection = (SiteCountersSection)parentConfig.GetSection("system.web/siteCounters");
            return siteCountersSection.Providers.Count;
        default:
            return -1;
    }
}

private void TestConnection(object s, EventArgs e) {
    bool good = base.TestConnection(s, e);
    LinkButton b = (LinkButton) s;
    bool isSql = b.CommandName.Contains("Sql");
    bool isWindowsToken = b.CommandName.Contains("WindowsToken");
    string servername, database;
    if (isWindowsToken) {
        good = true;
        database = null;
    }
    else {
        string connectionString = GetConnectionString(b.CommandArgument);
        if (isSql) {
            ParseSqlConnectionString(connectionString, out servername, out database);
        }
        else {
            database = ParseAccessConnectionString(connectionString);
        }
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
    <table height="100%" width="100%" cellspacing="0" cellpadding="0" valign="top" align="left">
        <tr class="bodyTextNoPadding" height="1%">
            <td>
                <asp:literal runat="server" text="<%$ Resources:UseThisPage %>"/>
            </td>
        </tr>
        <tr height="1%">
            <td/>
                &nbsp;
            </td>
        </tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="MembershipProviderList"
                                 HeaderText="<%$ Resources:MembershipProvider %>" ServiceName="membership"
                                 AddProviderLinkText="<%$ Resources:AddMembershipProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection" />
            </td>
        </tr>
        <tr height="1%">
            <td/>
                &nbsp;
            </td>
        </tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="RoleProviderList"
                                 HeaderText="<%$ Resources:RoleProvider %>" ServiceName="roleManager"
                                 AddProviderLinkText="<%$ Resources:AddRoleProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection"/>
            </td>
        </tr>
        <tr height="1%">
            <td/>
                &nbsp;
            </td>
        </tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="ProfileProviderList"
                                 HeaderText="<%$ Resources:ProfileProvider %>" ServiceName="profile"
                                 AddProviderLinkText="<%$ Resources:AddProfileProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection"/>
            </td>
        </tr>
        <tr height="1%">
            <td/>
                &nbsp;
            </td>
        </tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="SiteCountersProviderList"
                                 HeaderText="<%$ Resources:SiteCounterProvider %>" ServiceName="siteCounters"
                                 AddProviderLinkText="<%$ Resources:AddSiteCounterProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection"/>
            </td>
        </tr>
        <tr height="1%">
            <td/>
                &nbsp;
            </td>
        </tr>
        <tr height="1%">
            <td>
                <uc:ProviderList runat="server" id="PageCountersProviderList"
                                 HeaderText="<%$ Resources:PageCounterProvider %>"  ServiceName="pageCounters"
                                 AddProviderLinkText="<%$ Resources:AddPageCounterProvider %>"
                                 OnDeleteProvider="DeleteProvider"
                                 OnSelectProvider="SelectProvider"
                                 OnTestConnection="TestConnection"/>
            </td>
        </tr>
        <tr height="93%">
            <td/>
                &nbsp;
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:Back %>" id="BackButton" onclick="BackToPreviousPage" runat="server"/>
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
                        <asp:literal runat="server" id="areYouSureLiteral" />
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
    <asp:Button runat="server" id="DeleteYesButton" OnCommand="DeleteYesButton_Command" Text="<%$ Resources:Yes %>" width="75"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" id="DeleteNoButton" enableViewState="false" OnClick="DeleteNoButton_Click" Text="<%$ Resources:No %>" width="75"/>
    <asp:Button runat="server" id="OKButton" enableViewState="false" OnClick="OK_Click" Text="<%$ Resources:OK%>" visible="false" width="75"/>
</asp:content>
