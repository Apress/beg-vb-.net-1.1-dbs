<%@ Page MasterPageFile="WebAdminNoButtonRow.master" inherits="System.Web.Administration.WebAdminPage"%>
<%@ MasterType virtualPath="~/WebAdminNoButtonRow.master" %>
<%@ Import Namespace="System.Web.Configuration"%>
<%@ Import Namespace="System.Web.Hosting"%>
<%@ Import Namespace="System.Security" %> 
<%@ Import Namespace="System.Security.Principal" %> 
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Management" %>
<%@ Import Namespace="System.Web.Profile" %>
<%@ Reference virtualPath="WebAdminNoButtonRow.master" %>

<script runat="server" language="cs">
protected override bool CanSetApplicationPath {
    get {
        return true;
    }
}

private ProfileSection GetProfileSection(Configuration config) {
    return (ProfileSection) config.GetSection("system.web/profile");
}

protected override void OnInit(EventArgs e) {
    Master.SetNavigationBarSelectedIndex(0);
    try {
        SetApplicationPath(Page.User.Identity.Name);
    }
    catch (SecurityException ex) {
        Response.Redirect("home1.aspx");
    }
    base.OnInit(e);
}

public void Page_Load() {
    string id = Page.User.Identity.Name;
    if (id != null && !id.Equals(String.Empty)) {
        user.Text = String.Format((string)GetPageResourceObject("CurrentUserName"), id.ToUpper()); 
    }

    string appPath = ApplicationPath;   
    if (appPath != null && !appPath.Equals(String.Empty)) {
        application.Text = String.Format((string)GetPageResourceObject("Application"), appPath); 
    }
    if (IsWindowsAuth()) {
        existingUsersLiteral.Text = (string)GetPageResourceObject("WindowsAuth");
    }
    else {
        try {
            int total;
            WebAdminMembershipUserHelperCollection coll = MembershipHelperInstance.GetAllUsers(0, Int32.MaxValue, out total);
            existingUsersLiteral.Text = String.Format((string)GetPageResourceObject("ExistingUsers"), coll.Count.ToString()); 
        }
        catch {
            // Can happen, for example, if access is the default provider, but it is not available.
            existingUsersLiteral.Visible = false;
        }

    }

    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = GetProfileSection(config);
    if (profile.Enabled) {
        try {
            profileLiteral0.Text = String.Format((string)GetPageResourceObject("RegisteredProfiles"),  ProfileHelper.CountProfiles(ProfileAuthenticationOption.Authenticated).ToString()); 
            profileLiteral1.Text = String.Format((string)GetPageResourceObject("AnonymousProfiles"), ProfileHelper.CountProfiles(ProfileAuthenticationOption.Anonymous).ToString());
        }
        catch {
            // Can happen, for example, if access is the default provider, but it is not available.
            profileLiteral0.Visible = false;
            profileLiteral1.Visible = false;
        }
    }
}

</script>
<asp:content runat="server" contentplaceholderid="titleBar">
 <asp:literal runat="server" text="<%$ Resources: Home %>"/>
</asp:content>
<asp:content runat="server" contentplaceholderid="content">
<table width="100%" height="100%" >
    <tr>
        <td width="62%" valign="top" class="bodyTextNoPadding" style="padding-left:0;">
            <div style="font-size:1.5em; font-weight:bold" nowrap>
                <asp:label runat="server" id="welcome" text="<%$ Resources:Welcome %>"/>
            </div>
            <br/>
            <asp:literal runat="server" id="application"/>
            <br/>
            <asp:literal runat="server" id="user"/>
            <br/>
            <br/>

            <table cellspacing="0" cellpadding="0" rules="none" onrowcommand="LinkButtonClick" class="allBorders" border="0">
                <tr class="gridAlternatingRowStyle8" >
                    <td >
                        <a id="hook" href="security/security.aspx"><asp:literal runat="server" text="<%$ Resources:Security %>"/></a>
                    </td><td>
                        <asp:literal runat="server" text="<%$ Resources: EnablesSecurity %>"/>
                        <br/>
                        <asp:literal runat="server" id="existingUsersLiteral"/>
                    </td>
                </tr>
                <tr class="gridRowStyle8">
                    <td >
                        <a id="ProfileHomeLink" href="profile/profilehome.aspx"><asp:literal runat="server" text="<%$ Resources:Profile %>"/></a>
                    </td><td>
                        <asp:literal runat="server" text="<%$ Resources: EnablesProfile %>"/>
                    <asp:literal runat="server" id="profileLiteral0"/>
                    <asp:literal runat="server" id="profileLiteral1"/>
                    </td>
                </tr>   <tr class="gridAlternatingRowStyle8" >
                    <td >
                        <a id="AppConfigHomeLink" href="appConfig/AppConfigHome.aspx"><asp:literal runat="server" text="<%$ Resources:AppConfig %>"/></a>
                    </td><td>
                        <asp:literal runat="server" text="<%$ Resources: EnablesConfig %>"/>                    
                    </td>
                </tr><tr class="gridRowStyle8">
                       <td>
                        <a id="ProviderLink" href="providers/chooseProviderManagement.aspx"><asp:literal runat="server" text="<%$ Resources:ProviderConfig %>"/></a>
                    </td><td>
                     <asp:literal runat="server" text="<%$ Resources: EnablesData %>"/>                                           
                    </td>
                </tr>    
            </table>
    </tr>
</table>
</asp:content>

