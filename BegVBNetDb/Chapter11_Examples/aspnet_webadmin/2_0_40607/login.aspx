<%@ Page masterPageFile="WebAdminNoButtonRow.master" inherits="System.Web.Administration.WebAdminPage"%>
<%@ MasterType virtualPath="WebAdminNoButtonRow.master" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Security" %> 


<script runat="server" language="cs">
protected override bool CanSetApplicationPath {
    get {
        return true;
    }
}

private void DisplayAccessDenied() {
    status.Text = (string)GetPageResourceObject("AccessDenied"); 
}

private void LoginClicked(object s, EventArgs e) {
    string userNameText = userName.Text;
    if (userNameText == String.Empty) {
        status.Text = (string)GetPageResourceObject("UserNameNonEmpty");
        return;
    }
    bool valid = false;
    valid = Membership.ValidateUser(userNameText, password.Text);

    if (!valid) {
        DisplayAccessDenied();
        return;
    }
    try {
        SetApplicationPath(userNameText);
        System.Web.Security.FormsAuthentication.RedirectFromLoginPage(userNameText, false);
    }
    catch(SecurityException ex) {
        DisplayAccessDenied();
    }
}

public void Page_Init() {
    if (!Request.IsLocal && IsConfigLocalOnly()) {
        Server.Transfer("error.aspx");
    }
    userName.Focus();
}

public void Page_Load() {
    Master.SetNavigationBarSelectedIndex(0);
    if (!IsPostBack) {
        string applicationPath = ApplicationPath; // Nonempty
        string qsAppPath = GetQueryStringAppPath();
        if (applicationPath != null && applicationPath.Length > 0) {
            appName.Text = String.Format((string)GetPageResourceObject("ReturnToApp"), applicationPath);
        }
        else if (qsAppPath != null && qsAppPath.Length > 0) {
            appName.Text = String.Format((string)GetPageResourceObject("ReturnToApp"), qsAppPath);
        }
        else /* e.g., Cassini */ {
      //      returnLiteral.Visible = false;
            appName.Visible = false;
        }
    }
}

protected internal void ReturnToApplication(object s, EventArgs e) {
    string applicationUrl = ApplicationPath;
    if (applicationUrl != null && applicationUrl.Length != 0) {
        Response.Redirect(applicationUrl);
    }
}
</script>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources: Welcome %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
<table height="100%" width="100%">
    <tr>
        <td valign="top"><br/>
            <table cellspacing="0" width="38%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;" valign="top">
                <tr class="callOutStyle">
                    <td>
                        <asp:label runat="server" text="<%$ Resources: LogIn %>"/>
                    </td>
                </tr>
                <tr class="bodyTextNoPadding">
                    <td>
                        <table width="38%">
                            <tr>
                                <td class="bodyTextNoPadding">
                                    <asp:label  runat="server" id="label1" text="<%$ Resources: UserName %>"/>
                                    <br/>
                                    <asp:textbox runat="server" id="userName" width="12em"/>

                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="bodyTextNoPadding">

                                    <asp:label runat="server" id="label2" text="<%$ Resources: Password %>" />
                                    <br/>
                                    <asp:textbox runat="server" id="password" width="12em" textmode="password"/>
                                </td>
                                <td align="right" valign="bottom">
                                    <asp:button runat="server" id="button1" commandname="Submit" text="<%$ Resources:LogInButton %>" onclick="LoginClicked"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:label runat="server" id="status" cssclass="bodyTextNoPadding" forecolor="red" enableviewstate="false"/>
        </td>
    </tr>
    <tr>
        <td>
            <asp:linkbutton runat="server" id="appName" cssclass="bodyTextNoPadding" onclick="ReturnToApplication"/>
        </td>
    </tr>
</table>
</asp:content>


