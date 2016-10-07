<%@ Page masterPageFile="~/WebAdminButtonRow.master" inherits="System.Web.Administration.SecurityPage"%>

<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server" language="CS">
public void AddRole(object s, EventArgs e) {
}

private string GetDirectory(string path) {
    if (path == null) {
        return null; // Review: can this happen?
    }
    return path.Substring(path.LastIndexOf('/') + 1);
}

protected override void OnInit(EventArgs e) {
    base.OnInit(e);
    if(!IsPostBack) {
        // Note: treenodes persist when added in Init, before loadViewState
        TreeNode n = new TreeNode(GetDirectory(ApplicationPath), ApplicationPath);
        tv.Nodes.Add(n);
        n.Selected = true;
        PopulateChildren(n);
        CurrentPath = ApplicationPath;
    }
}

public void Page_Init() {
    if (IsWindowsAuth()) {
        findUsersLink.Visible = false;
    }
}

public void Page_Load() {
    if(!IsPostBack) {
        if (IsRoleManagerEnabled()) {
            roles.DataSource = RoleHelperInstance.GetAllRoles();
            roles.DataBind();
            if (roles.Items.Count == 0) {
                ListItem item = new ListItem((string)GetPageResourceObject("NoRoles"));
                roles.Items.Add(item);
                roles.Enabled = false;
                roleRadio.Enabled = false;
                roleRadio.Checked = false;
                userRadio.Checked = true;
            }
        }
        else {
            ListItem item = new ListItem((string)GetPageResourceObject("RolesDisabled"));
            roles.Items.Add(item);
            roles.Enabled = false;
            roleRadio.Enabled = false;
            roleRadio.Checked = false;
            userRadio.Checked = true;
        }

        StringBuilder builder = new StringBuilder();
        bool firstTime = true;
        foreach(string mu in UserCollection.Keys) {
            if (!firstTime) {
                builder.Append(",");
            }
            else {
                firstTime = false;
            }
            builder.Append(mu);
        }
        userName.Text = builder.ToString();
    }
}

protected void TreeNodeExpanded(Object sender, TreeNodeEventArgs e) {
    foreach(TreeNode child in e.Node.ChildNodes) {
        PopulateChildren(child);
    }
}

protected void TreeNodeSelected(object sender, EventArgs e) {
    CurrentPath = ((TreeView)sender).SelectedNode.Value;
}

protected void UpdateAndReturnToPreviousPage(object s, EventArgs e) {
    ClearUserCollection();
    if(!IsRuleValid(placeholderValidator, userRadio, userName, roleRadio, roles)) {
        return;
    }
    SecurityUtility.AddPermissionRule(this, CurrentPath, userName, roles, userRadio, roleRadio, allUsersRadio, anonymousUsersRadio, grantRadio, denyRadio);
    ReturnToPreviousPage(s, e);
}

</script>


<asp:content runat="server" contentplaceholderid="buttons">
<asp:button runat="server" id="button1" text="<%$ Resources:OK %>" onclick="UpdateAndReturnToPreviousPage" width="110"/>
<asp:button runat="server" id="button2" text="<%$ Resources:Cancel %>" onclick="ReturnToPreviousPage" width="110"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:AddNewAccess %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="content" >
<div style="width:80%">
<asp:literal runat="server" text="<%$ Resources:Instructions %>" />
    </div>
<table width="80%">
    <tr>
        <td width="80%">
            <table cellspacing="0" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                <tr class="callOutStyle">
                    <td colspan="2"><asp:literal runat="server" text="<%$ Resources:AddNewAccess %>" /></td>
                </tr>
                <tr>
                    <td class="bodyTextNoPadding" width="36%"><b><asp:literal runat="server" text="<%$ Resources:SelectDirForRule %>"/></b>
                        <table cellspacing="0" cellpadding="4" rules="rows" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;width:100%;border-collapse:collapse;">
                            <tr>
                                <td>
                                    <asp:panel runat="server" id="panel1" scrollbars="both" height="150px" cssclass="bodyTextNoPadding">
                                    <asp:treeview runat="server" id="tv" onTreeNodeExpanded="TreeNodeExpanded" onSelectedNodeChanged="TreeNodeSelected" rootNodeImageUrl="../../images/folder.gif" parentnodeimageurl="../../images/folder.gif" leafnodeimageurl="../../images/folder.gif">
                                    <nodestyle cssclass="bodyTextLowPadding"/>
                                    <selectednodestyle cssclass="bodyTextLowPaddingSelected"/>
                                    </asp:treeview>

                                    </asp:panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td height="100%" valign="top">
                        <table border="0" cellpadding="0" cellspacing="0" class="bodyTextNoPadding" height="100%" width="100%" align="center">
                            <tr>
                                <td width="50%"><b><asp:literal runat="server" text="<%$ Resources:RuleAppliesTo %>"/></b></td>
                                <td><b><asp:literal runat="server" text="<%$ Resources:Permission %>"/></b></td>
                            </tr>
                            <tr>
                                <td width="62%">
                                    <asp:radiobutton runat="server" id="roleRadio" checked="true" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="roleRadio"><asp:literal runat="server" text="<%$ Resources:Role %>"/></asp:label>
                                    <asp:dropdownlist runat="server" id="roles"/>
                                    </td>
                                <td>
                                    <asp:radiobutton runat="server" id="grantRadio" groupname="grantDeny" />
                                    <asp:label runat="server" associatedcontrolid="grantRadio"><asp:literal runat="server" text="<%$ Resources:Allow %>"/></asp:label></td>
                            </tr>
                            <tr>
                                <td width="62%">
                                    <asp:radiobutton runat="server" id="userRadio" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="userRadio"><asp:literal runat="server" text="<%$ Resources:User %>"/></asp:label>
                                    <asp:textbox runat="server" id="userName"/>
                                    <br/><asp:hyperlink runat="server" id="findUsersLink" navigateUrl="../users/findusers.aspx"><asp:literal runat="server" text="<%$ Resources:SearchForUsers %>"/></asp:hyperlink>
                                    </td>
                                <td>
                                    <asp:radioButton runat="server" id="denyRadio" checked="true" groupName="grantDeny"/>
                                    <asp:label runat="server" associatedcontrolid="denyRadio"><asp:literal runat="server" text="<%$ Resources:Deny %>"/></asp:label>
                                </td>
                            </tr>
                            <tr>
                                <td width="62%">
                                    <asp:radiobutton runat="server" id="allUsersRadio" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="allUsersRadio"><asp:literal runat="server" text="<%$ Resources:AllUsers %>"/></asp:label></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="62%">
                                    <asp:radiobutton runat="server" id="anonymousUsersRadio" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="anonymousUsersRadio"><asp:literal runat="server" text="<%$ Resources:AnonymousUsers %>"/></asp:label></td>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:customvalidator runat="server" id="placeholderValidator" enableclientscript="false" errormessage="Invalid input" display="dynamic"/>
</asp:content>

