<%@ Page masterPageFile="~/WebAdmin.master" inherits="System.Web.Administration.ProvidersPage" debug="true"%>
<%@ MasterType virtualPath="~/WebAdmin.master" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server" language=cs>
public void Page_Load() {
    System.Configuration.Configuration config = GetWebConfiguration(ApplicationPath);
    MembershipSection membershipSection = (MembershipSection)config.GetSection("system.web/membership");
    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    PageCountersElement pageCountersElement = siteCountersSection.PageCounters;
    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");

    string defaultProvider = membershipSection.DefaultProvider;
    string connectionStringName = membershipSection.Providers[defaultProvider].Parameters["connectionStringName"];
    if (defaultProvider == roleManagerSection.DefaultProvider &&
        defaultProvider == profileSection.DefaultProvider &&
        defaultProvider == siteCountersSection.DefaultProvider &&
        ((pageCountersElement.DefaultProvider.Length > 0) ? (defaultProvider == pageCountersElement.DefaultProvider) : true) &&
        connectionStringName == roleManagerSection.Providers[defaultProvider].Parameters["connectionStringName"] &&
        connectionStringName == profileSection.Providers[defaultProvider].Parameters["connectionStringName"] &&
        connectionStringName == siteCountersSection.Providers[defaultProvider].Parameters["connectionStringName"]) {
        providerLiteral.Text = String.Format((string)GetPageResourceObject("CurrentProvider"), defaultProvider);
    }
}
</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:literal runat="server" text="<%$ Resources:ConfigureProviders %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
<asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
<br/><br/>
<asp:literal runat=server id=providerLiteral/>
<asp:HyperLink id="hook" runat="server" NavigateUrl="~/Providers/ManageConsolidatedProviders.aspx" text="<%$ Resources:SelectSame %>"/>
<br/>
<asp:HyperLink runat="server" NavigateUrl="~/Providers/ManageProviders.aspx" text="<%$ Resources:SelectDifferent%>" />
</asp:content>

    
