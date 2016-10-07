<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" debug="true" inherits="System.Web.Administration.SecurityPage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="System.Web.Configuration" %>


<script runat="server">

private const string NOT_SET = "[not set]";
private const string HIDDEN = "[hidden]";
private Exception currentRequestException;


private void AddAnother_Click(object s, EventArgs e) {
    ResetUI();
    Master.SetDisplayUI(false);
}

private void AutoGenPasswordChanged(object s, EventArgs e) {

}

public void Cancel(object s, EventArgs e) {
    ClearTextBoxes();    
}

private void ClearTextBoxes() {
    UserID.Text = String.Empty;
    UserID.Enabled = true;
    Email.Text = String.Empty;
    Description.Text = String.Empty;
}

private void ClearCheckBoxes() {
}

private void OK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

public void Page_Load() {
    string userName = CurrentUser;
    if (!IsPostBack) {
        PopulateCheckboxes();
        UserID.Text = userName;
        UserID.Enabled = false;
        WebAdminMembershipUserHelper mu = MembershipHelperInstance.GetUser(userName, false /* isOnline */);
        RetrievePassword.Visible = MembershipHelperInstance.EnablePasswordRetrieval;

        if (mu == null) {
            return; // Review: scenarios where this happens.
        }
        Email.Text = mu.Email;
        ActiveUser.Checked = mu.IsApproved;
        string comment = mu.Comment;
        Description.Text = comment == null || comment == string.Empty ? NOT_SET : mu.Comment;        
    }
}

private void PopulateCheckboxes() {
    if (IsRoleManagerEnabled()) {
        CheckBoxRepeater.DataSource = RoleHelperInstance.GetAllRoles();
        CheckBoxRepeater.DataBind();
        if (CheckBoxRepeater.Items.Count > 0) {
            SelectRolesLabel.Text = (string)GetPageResourceObject("SelectRoles");
        }
        else {
            SelectRolesLabel.Text = (string)GetPageResourceObject("NoRolesDefined");
        }
    }
    else {
        SelectRolesLabel.Text = (string)GetPageResourceObject("RolesNotEnabled");
    }
}

public void ResetUI() {
    ClearTextBoxes();
    ClearCheckBoxes();
}

private void ServerCustomValidate(object s, ServerValidateEventArgs e) {
    if (currentRequestException == null) {
        e.IsValid = true;
        return;
    }
    CustomValidator v = (CustomValidator) s;
    v.ErrorMessage = currentRequestException.Message;
    e.IsValid = false;
}

public void SaveClick(object s, EventArgs e) {
   UpdateUser(s, e);
}

private void UpdateRoleMembership(string u) {
    if (u == null || u.Equals(String.Empty)) {
        return;
    }
    foreach(RepeaterItem i in CheckBoxRepeater.Items) {
        CheckBox c = (CheckBox)i.FindControl("checkbox1");
        UpdateRoleMembership(u, c);
    }
    // Clear the checkboxes
    CurrentUser = null;
    PopulateCheckboxes();
}

private void UpdateRoleMembership(string u, CheckBox box) {
    // Array manipulation because cannot use Roles static method (need different appPath).
    string[] users = new string[1];
    users[0] = u;
    string role = box.Text;
    string[] roles = new string[1];
    roles[0] = role;

    bool boxChecked = box.Checked;
    bool userInRole = RoleHelperInstance.IsUserInRole(u, role);

    try {
        if (boxChecked && !userInRole) {
            RoleHelperInstance.AddUsersToRoles(users, roles);
        }
        else if (!boxChecked && userInRole) {
            RoleHelperInstance.RemoveUsersFromRoles(users, roles);
        }
    }
    catch (Exception ex) {
        PlaceholderValidator.IsValid = false;
        PlaceholderValidator.ErrorMessage = ex.Message;
    }
}

public void UpdateUser(object s, EventArgs e) {
    if (!Page.IsValid) {
        return;
    }
    string userIDText = UserID.Text;
    string emailText = Email.Text;
    try {
        WebAdminMembershipUserHelper mu = MembershipHelperInstance.GetUser(UserID.Text, false /* isOnline */);
        mu.Email = Email.Text;
        if (
            Description.Text != null && !Description.Text.Equals(NOT_SET)) {
            mu.Comment = Description.Text;
        }

        mu.IsApproved = ActiveUser.Checked;
        MembershipHelperInstance.UpdateUser(mu);
        UpdateRoleMembership(userIDText);
    }
    catch (Exception ex) {
        PlaceholderValidator.IsValid = false;
        PlaceholderValidator.ErrorMessage = ex.Message;
        return;
    }
    
    // Go to confirmation
    DialogMessage.Text = String.Format((string)GetPageResourceObject("Successful"), userIDText);
    AddAnother.Visible = false;
    Master.SetDisplayUI(true);

    ResetUI();       
}
</script>

<asp:content runat="server" contentplaceholderid="buttons">
<asp:button text="Back" id="DoneButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:UpdateUser %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="content">

<div style="width:750">
<asp:literal runat="server" text="<%$ Resources:Instructions %>" />

<br/><br/>
</div>
<br/>

<table cellspacing="0" cellpadding="0" border="0"  width="750">
    <tbody>
    <tr align="left" valign="top">
        <td width="62%" height="100%" class="lbBorders">

            <table cellspacing="0" width="100%" cellpadding="0" border="0">
                <tr class="callOutStyleLowLeftPadding">
                    <td colspan="4">User</td>
                </tr>
                <tr>
                    <td>
                        <table class="bodyText" bordercolor="#CCDDEF">
                            <tr>
                                <td width="2em"></td>
                                <td><asp:Label runat="server" AssociatedControlID="UserID" Text="<%$ Resources:UserID %>"/></td>
                                <td>
                                    <asp:textbox runat="server" id="UserID" maxlength="255" tabindex="101"/>
                                </td>
                                <td colSpan="3"><asp:hyperlink id="RetrievePassword" runat="server" navigateUrl="~/security/users/retrievePassword.aspx" text="<%$ Resources:RetrievePassword %>"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="2em"><img src="../../Images/requiredBang.gif" alt="Required"/></td>
                                <td><asp:Label runat="server" AssociatedControlID="Email" Text="<%$ Resources:EmailAddress %>"/></td>
                                <td>
                                    <asp:textbox runat="server" id="Email" maxlength="128" tabindex="102"/>
                                </td>
                                <td colspan="3"><asp:checkbox runat="server" id="ActiveUser" text="<%$ Resources:ActiveUser %>" checked="true"/></td>
                            </tr>

                            <tr>
                                <td width="2em"></td>
                                <td ><asp:Label runat="server" AssociatedControlID="Description" Text="<%$ Resources:Description %>"/></td>
                                <td>
                                    <asp:textbox runat="server" id="Description" />
                                </td>
                               <td colSpan="3"><asp:button runat="server" id="SaveButton" onClick="SaveClick" text="<%$ Resources:Save %>" width="100"/>
                                </td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
        </td>
        <td width="32%" height="100%">
            <table  borderwidth="1px" cellpadding="0" cellspacing="0" height="100%" width="100%">
                <tbody>
                <tr class="callOutStyleLowLeftPadding" height="1">
                    <td valign="top">Roles</td>
                </tr>
                <tr valign="top">
                    <td  class="userDetailsWithFontSize" height="100%">
                        <asp:panel runat="server" id="Panel1" scrollbars="auto" valign="top">
                        <asp:label runat="server" id="SelectRolesLabel" text="<%$ Resources:SelectRoles%>"/>
                        <br/>
                        <asp:repeater runat="server" id="CheckBoxRepeater">
                        <itemtemplate>
                        <asp:checkbox runat="server" id="checkBox1" text='<%# Container.DataItem.ToString()%>' checked="<%# (CurrentUser == null) ? false : RoleHelperInstance.IsUserInRole(CurrentUser, Container.DataItem.ToString())%>"/>
                        <br/>
                        </itemtemplate>
                        </asp:repeater>
                        </asp:panel>
                    </td>
                </tr>
    </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
            (<asp:image runat="server" imageurl="../../Images/requiredBang.gif" alternateText="<%$ Resources:Required %>"/>) 
                                Required field

</div>
<br/>
<asp:validationsummary runat="server" headertext="<%$ Resources:PleaseCorrect %>"/>
<asp:requiredfieldvalidator runat="server" controltovalidate="UserID" enableclientscript="false" errormessage="<%$ Resources:UserIDRequired %>" display="none"/>
<asp:regularexpressionvalidator runat="server" controltovalidate="Email" enableclientscript="false" errormessage="<%$ Resources:InvalidEmailFormat %>" display="none" validationexpression="\S+@\S+\.\S+"/>
<asp:requiredfieldvalidator runat="server" controltovalidate="Email" enableclientscript="false" errormessage="<%$ Resources:EmailRequired %>" display="none"/>
<asp:customvalidator runat="server" id="PlaceholderValidator" controltovalidate="UserID" enableclientscript="false" errormessage="<%$ Resources:InvalidInput %>" onservervalidate="ServerCustomValidate" display="none"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
<asp:literal runat="server" text="<%$ Resources:UserManagement %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
<asp:literal runat="server" id="DialogMessage" />

</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="~/security/Security.aspx" Text="<%$ Resources:GoHome %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" id="AddAnother" enableViewState="false" OnClick="AddAnother_Click" Text="<%$ Resources:AddAnother %>" width="100"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="OK_Click" Text="<%$ Resources:OK %>" width="75"/>
</asp:content>
