<%@ Page masterPageFile="~/WebAdmin.master" inherits="System.Web.Administration.SecurityPage"%>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server" language="cs">
private void BackToPreviousPage(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

protected void DisableRoleManager() {
    Configuration config = GetWebConfiguration(ApplicationPath);
    RoleManagerSection roleSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    roleSection.Enabled = false;
    UpdateConfig(config);
}

protected void EnableRoleManager() {
    Configuration config = GetWebConfiguration(ApplicationPath);
    RoleManagerSection roleSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    roleSection.Enabled = true;
    UpdateConfig(config);
}


public void Page_Init() {
    if (IsWindowsAuth()) {
        userManagementDisabler.ActiveViewIndex = 1;
    }
    string appPath = ApplicationPath;
    if (appPath != null && appPath.Length > 0) {
        application.Text = String.Format((string)GetPageResourceObject("SecurityManagementForSite"), appPath);
    }
}

public void Page_Load() {
    if (!IsPostBack) {
        CurrentUser = null;
        UpdateProviderUI();
    }
}

private void ToggleRoles(object s, EventArgs e) {
    if(IsRoleManagerEnabled()) {
        DisableRoleManager();
    }
    else {
        EnableRoleManager();
    }
    UpdateProviderUI();
}



private void UpdateProviderUI() {
    try {
        WebAdminMembershipUserHelperCollection users;
        string[] roles;
        MembershipAndRoleHelperInstance.GetUsersAndRoles(out users, out roles);
        userCount.Text = users.Count.ToString();
        if (IsRoleManagerEnabled()) {
            if (roles != null) {
                roleCount.Text = roles.Length.ToString();
            }
            else {
                roleCount.Text = "0";
            }
            roleCount.Visible = true;
            roleMessage.Text = (string)GetPageResourceObject("ExistingRoles"); 
            waLink5.Visible = true;
            waLink6.Visible = true;
            waLabel5.Visible = false;
            waLabel6.Visible = false;
            toggleRoles.Text = (string)GetPageResourceObject("DisableRoles");
        }
        else {
            roleCount.Visible = false;
            roleMessage.Text = (string)GetPageResourceObject("RolesNotEnabled");
            // Cannot disable a hyperlink, so "replace" it with a label.
            waLink5.Visible = false;
            waLink6.Visible = false;
            waLabel5.Visible = true;
            waLabel6.Visible = true;
            toggleRoles.Text = (string)GetPageResourceObject("EnableRoles"); 
        }
    }
    catch (Exception e){
        WebAdminBasePage.SetCurrentException(Context, e);
        Response.Redirect("security0.aspx"); // States that there is a problem with the selected data store and redirects to chooseProvider.aspx
    }
}


</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" id="application" text="<%$ Resources: SecurityManagement %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table id="hook" height="100%" width="100%">
        <tr>
            <td width="600" valign="top">
                <table width="100%" valign="top">
                    <tr>
                        <td class="bodyTextNoPadding" colspan="3">
                            <asp:literal runat="server" text="<%$ Resources: Explanation %>"/>
                            <br/><br/>
                             <asp:hyperlink runat=server id="linkhook" navigateUrl="~/security/wizard/wizard.aspx" text="<%$ Resources:SecurityLink %>"/>
                            <br/><br/>
                            <asp:literal runat="server" text="<%$ Resources: ClickLinksInstruction %>"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="33%" height="100%">
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr class="callOutStyle">
                                    <td><asp:literal runat="server" text="<%$ Resources: Users %>"/></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td>
                                    <asp:multiview runat="server" id="userManagementDisabler" activeViewIndex="0">
                                    <asp:view runat="server">
                                        
                                        <asp:literal runat="server" text="<%$ Resources: ExistingUsers %>"/> <asp:label runat="server" id="userCount" font-bold="true" text="0"/><br/>
                                        <asp:hyperlink runat="server" id="waLink3" navigateUrl="~/security/users/addUser.aspx" text="<%$ Resources:CreateUser %>"/><br/>
                                        <asp:hyperlink runat="server" id="waLink4" navigateUrl="~/security/users/manageUsers.aspx" text="<%$ Resources:ManageUsers %>"/><br/>
                                        </asp:view>
                                        <asp:view runat="server">
                                        <asp:literal runat="server" text="<%$ Resources: WindowsAuthExplanation %>"/>
                                        </asp:view>
                                        </asp:multiview>
                                        <br/>
                                        <asp:hyperlink runat="server" navigateUrl="~/security/setUpAuthentication.aspx" text="<%$ Resources:SelectAuth %>"/>
                                        </td>
                                </tr>
                            </table>
                        </td>
                        <td width="33%" height="100%">
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr class="callOutStyle">
                                    <td><asp:Literal runat="server" Text="<% $ Resources: Roles%>" /></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td>
                                        <asp:label runat="server" id="roleMessage" text="<%$ Resources: ExistingRoles%>"/>
                                        <asp:label runat="server" id="roleCount" font-bold="true" text="0"/>
                                        <br/>
                                        <asp:linkButton runat="server" id="toggleRoles" onclick="ToggleRoles" text="Enable roles"/><br/>
                                        <asp:label runat="server" id="waLabel5" enabled="false" text="<%$ Resources:CreateRoles %>"/>
                                        <asp:hyperlink runat="server" id="waLink5" navigateUrl="~/security/roles/manageAllRoles.aspx" text="<%$ Resources:CreateRoles %>"/><br/>
                                        <asp:label runat="server" id="waLabel6" enabled="false" text="<%$ Resources:ManageRoles %>"/>
                                        <asp:hyperlink runat="server" id="waLink6" navigateUrl="~/security/roles/manageAllRoles.aspx" text="<%$ Resources:ManageRoles %>"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="33%" height="100%">
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr class="callOutStyle">
                                    <td><asp:Literal runat="server" Text="<% $ Resources: AccessRules%>" /></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td>
                                        <asp:hyperlink runat="server" id="waLink7" navigateUrl="~/security/permissions/createPermission.aspx" text="<%$ Resources:CreateAccessRules %>"/>
                                        <asp:label runat="server" id="waLabel7" enabled="false" visible="false" text="<%$ Resources:CreateAccessRules %>"/><br/>
                                        <asp:hyperlink runat="server" id="waLink8" navigateUrl="~/security/permissions/managePermissions.aspx" text="<%$ Resources:ManageAccessRules %>"/>
                                        <asp:label runat="server" id="waLabel8" enabled="false" visible="false" text="<%$ Resources:ManageAccessRules%>"/><br/>
                                        
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:content>


