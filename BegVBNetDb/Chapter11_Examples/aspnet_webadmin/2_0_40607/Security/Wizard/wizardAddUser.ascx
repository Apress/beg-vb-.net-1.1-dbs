<%@ Control Inherits="System.Web.Administration.WebAdminUserControl" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Register TagPrefix="admin" Namespace="System.Web.Administration" Assembly="System.Web" %>

<script runat="server" language="cs">
public void AutoGenPasswordChanged(object s, EventArgs e) {
    bool autoGenPasswordChecked = autoGenPassword.Checked;
	createUser.AutoGeneratePassword = autoGenPasswordChecked;
	sendPassword.Enabled = !autoGenPasswordChecked;
    if (autoGenPassword.Checked) {
        sendPassword.Checked = true;        
    }
}


public void ContinueClick(object s, EventArgs e) {
    ((WizardPage)Page).SaveActiveView();
}

public void CreatedUser(object s, EventArgs e) {
    sendPassword.Visible = false;
    autoGenPassword.Visible = false;
    activeUser.Visible = false;
}

public void CreatingUser(object s, EventArgs e) {
    createUser.DisableCreatedUser = !activeUser.Checked;
    if (sendPassword.Checked) {
        createUser.MailDefinition.From = "administrator";

        // TODO: This shouldn't be needed but this is the current workaround to
        // have CreateUserWizard to send mail.  DevDiv DCR 29679 has been filed
        // to see if the requirement of setting BodyFileName can be removed.
        // Once that is done this workaround can be removed.
        createUser.MailDefinition.BodyFileName = "LocalResources/wizardAddUser.ascx.resx";
    }
    else {
        createUser.ClearMailDefinition();
    }
}

public void SendPasswordChanged(object s, EventArgs e) {
    if (sendPassword.Checked) {
        createUser.MailDefinition.From = "administrator";
    }
    else {
        createUser.ClearMailDefinition();
    }
}
</script>

<div class="bodyTextNoPadding" style="width:500">
<asp:literal runat="server" text="<%$ Resources:AddUserInstructions %>"/>
<br/><br/>
<table cellspacing="0" cellpadding="5" class="lrbBorders">
    <tr>
        <td class="callOutStyle"><asp:literal runat="server" text="<%$ Resources:CreateUser %>"/></td>
    </tr>
    <tr >
        <td>
             <admin:webadmincreateUserWizard runat=server id=createUser class="bodyText" createUserTitleText="" continueDestinationPageUrl="~/security/wizard/wizard.aspx" emailLabelText="<%$ Resources:EmailLabel %>" displayCancelButton="false" emailRegularExpression="\S+@\S+\.\S+" oncontinuebuttonclick="ContinueClick" oncreateduser="CreatedUser" oncreatinguser="CreatingUser">
             </admin:webadmincreateuserwizard>
        </td>
    </tr>
</table>
<asp:checkbox runat="server" id="sendPassword" text="<%$ Resources:SendPassword %>"/>
<asp:checkbox runat="server" id="autoGenPassword" autopostback="true" onCheckedChanged="AutoGenPasswordChanged" text="<%$ Resources:AutogenPassword %>"/>
<asp:checkbox runat="server" id="activeUser" checked="true" text="<%$ Resources:ActiveUser %>"/>
</div>
