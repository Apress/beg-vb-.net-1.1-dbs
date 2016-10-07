<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" debug="true" inherits="System.Web.Administration.SecurityPage"%>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register TagPrefix="admin" Namespace="System.Web.Administration" Assembly="System.Web" %>

<script runat="server">
public void AutoGenPasswordChanged(object s, EventArgs e) {
    createUser.DisableCreatedUser = !activeUser.Checked;
    bool autoGenPasswordChecked = autoGenPassword.Checked;
    createUser.AutoGeneratePassword = autoGenPasswordChecked;
    sendPassword.Enabled = !autoGenPasswordChecked;
    if (autoGenPassword.Checked) {
        sendPassword.Checked = true;
    }
}

public void CreatedUser(object s, EventArgs e) {
    sendPassword.Visible = false;   
    autoGenPassword.Visible = false;
    activeUser.Visible = false;
    panel1.Enabled = false;    
    UpdateRoleMembership(createUser.UserName);
}

public void CreatingUser(object s, EventArgs e) {
    createUser.DisableCreatedUser = !activeUser.Checked;
    if (sendPassword.Checked) {
        createUser.MailDefinition.From = (string) GetPageResourceObject("SendPasswordMailFrom");
        createUser.MailDefinition.Subject = (string) GetPageResourceObject("SendPasswordMailSubject");

        // TODO: This shouldn't be needed but this is the current workaround to
        // have CreateUserWizard to send mail.  DevDiv DCR 29679 has been filed
        // to see if the requirement of setting BodyFileName can be removed.
        // Once that is done this workaround can be removed.
        createUser.MailDefinition.BodyFileName = "LocalResources/addUser.aspx.resx";
    }
    else {
        createUser.ClearMailDefinition();
    }
}

public void Page_Init() {
// CONSIDER:    autoGenPassword.Visible = MembershipHelperInstance.EnablePasswordRetrieval;
}

public void Page_Load() {
    if (!IsPostBack) {
        PopulateCheckboxes();
    }
}

private void PopulateCheckboxes() {
    if (IsRoleManagerEnabled()) {
        checkBoxRepeater.DataSource = RoleHelperInstance.GetAllRoles();
        checkBoxRepeater.DataBind();
        if (checkBoxRepeater.Items.Count > 0) {
            selectRolesLabel.Text = (string) GetPageResourceObject("SelectRoles");
        }
        else {
            selectRolesLabel.Text = (string) GetPageResourceObject("NoRolesDefined");
        }
    }
    else {
        selectRolesLabel.Text = (string) GetPageResourceObject("RolesNotEnabled");
    }
}

private void SendingPasswordMail(object sender, MailMessageEventArgs e) {
    e.Message.Body = String.Format((string)GetPageResourceObject("SendPasswordMailBody"),
                                   createUser.UserName, createUser.Password);
}

private void UpdateRoleMembership(string u) {
    if (u == null || u.Equals(String.Empty)) {
        return;
    }
    foreach(RepeaterItem i in checkBoxRepeater.Items) {
        CheckBox c = (CheckBox)i.FindControl("checkbox1");
        UpdateRoleMembership(u, c);
    }
}

private void UpdateRoleMembership(string u, CheckBox box) {
    // Array manipulation because cannot use Roles static method (need different appPath).
    string[] users = new string[1];
    users[0] = u;
    string role = box.Text;
    string[] roles = new string[1];
    roles[0] = role;

    if (box.Checked && !RoleHelperInstance.IsUserInRole(u, role)) {
        RoleHelperInstance.AddUsersToRoles(users, roles);
    }
    else if (!box.Checked && RoleHelperInstance.IsUserInRole(u, role)) {
        RoleHelperInstance.RemoveUsersFromRoles(users, roles);
    }
}


</script>

<asp:content runat="server" contentplaceholderid="buttons">
<asp:button text="<%$ Resources:Back %>" id="doneButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:CreateUser %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">

<div style="width:750">
<asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
</div>
<br/>
<table>
<tr>
<td>
    <table cellspacing="0" cellpadding="5" class="lrbBorders">
    <tr>
        <td class="callOutStyle"><asp:literal runat="server" text="<%$ Resources:CreateUser %>"/></td>
    </tr>
    <tr >
        <td>
            <admin:webadmincreateUserWizard runat=server id=createUser displayCancelButton="false"
                class="bodyText" createUserTitleText="" continueDestinationPageUrl="~/security/users/addUser.aspx"
                emailLabelText="<%$ Resources:EmailLabel %>" emailRegularExpression="\S+@\S+\.\S+"
                oncancelclick="ReturnToPreviousPage" oncreateduser="CreatedUser" oncreatinguser="CreatingUser"
                onSendingMail="SendingPasswordMail"/>
        </td>
    </tr>
</table>

    </td><td height="100%">
            <table  borderwidth="1px" cellpadding="0" cellspacing="0" height="100%" width="100%">
                <tr class="callOutStyleLowLeftPadding" height="1">
                    <td valign="top"><asp:literal runat="server" text="<%$ Resources:Roles %>"/></td>
                </tr>
                <tr valign="top" height="100%">
                    <td  class="userDetailsWithFontSize" height="100%">
                        <asp:panel runat="server" id="panel1" scrollbars="auto" valign="top">
                        <asp:label runat="server" id="selectRolesLabel" text="<%$ Resources:SelectRoles %>"/>
                        <br/>
                        <asp:repeater runat="server" id="checkBoxRepeater">
                        <itemtemplate>
                        <asp:checkbox runat="server" id="checkBox1" text='<%# Container.DataItem.ToString()%>' />
                        <br/>
                        </itemtemplate>
                        </asp:repeater>
                        </asp:panel>
                    </td>
                </tr>
            </table>    
    </td>
    </tr>
</table>

<asp:checkbox runat="server" id="sendPassword" text="<%$ Resources:SendPassword %>"/>
<asp:checkbox runat="server" id="autoGenPassword" autopostback="true" onCheckedChanged="AutoGenPasswordChanged" text="<%$ Resources:AutogenPassword %>"/>
<asp:checkbox runat="server" id="activeUser" checked="true" text="<%$ Resources:ActiveUser %>"/>
</asp:content>
