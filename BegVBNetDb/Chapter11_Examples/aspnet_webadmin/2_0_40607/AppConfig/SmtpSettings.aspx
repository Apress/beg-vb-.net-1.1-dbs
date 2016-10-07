<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ register TagPrefix="webadmin" namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private const string _smtpAuthenticateFieldName = "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate";
private const string _sendUserNameFieldName = "http://schemas.microsoft.com/cdo/configuration/sendusername";
private const string _sendPasswordFieldName = "http://schemas.microsoft.com/cdo/configuration/sendpassword";

private int PasswordCharLen {
    get {
        object o = ViewState["!PasswordCharLen"];
        if (o == null) {
            return 0;
        }
        return (int)o;
    }
    set {
        ViewState["!PasswordCharLen"] = value;
    }
}

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private void Authentication_ValueChanged(object s, EventArgs e) {
    ToggleSenderInfoUI(BasicRadioButton.Checked);
}

private void Page_Load() {
    string appPath = ApplicationPath;
    if (!IsPostBack) {
        if (appPath != null && !appPath.Equals(String.Empty)) {
            ConfigureSMTPTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        Configuration config = GetWebConfiguration(appPath);
        SmtpMailSection smtpMailSection = (SmtpMailSection) config.GetSection("system.web/smtpMail");

        ServerNameTextBox.Text = smtpMailSection.ServerName;
        ServerPortTextBox.Text = Convert.ToString(smtpMailSection.ServerPort, CultureInfo.InvariantCulture);
        FromTextBox.Text = smtpMailSection.From;

        int authenticateMode;
        FieldSettings fieldSettings = smtpMailSection.Fields[_smtpAuthenticateFieldName];
        if (fieldSettings == null) {
            authenticateMode = 0;
        }
        else {
            authenticateMode = Convert.ToInt32(fieldSettings.Value, CultureInfo.InvariantCulture);
        }

        switch (authenticateMode) {
            case 0:
                NoneRadioButton.Checked = true;
                break;
            case 1:
                BasicRadioButton.Checked = true;
                break;
            case 2:
                NTLMRadioButton.Checked = true;
                break;
            // TODO: Remove the exception as this is to capture development error where the radio button group is not set properly.
            //       Note that it does not need to be localized.
            default:
                throw new Exception("Unexpected config value for smtpauthenticate field!");
        }

        fieldSettings = smtpMailSection.Fields[_sendUserNameFieldName];
        if (fieldSettings != null) {
            UserNameTextBox.Text = fieldSettings.Value;
        }

        PasswordCharLen = 0;
        PasswordTextBox.Text = "";
        fieldSettings = smtpMailSection.Fields[_sendPasswordFieldName];
        if (fieldSettings != null) {
            PasswordCharLen = fieldSettings.Value.Length;
            
            StringBuilder szFakePassword = new StringBuilder("");
            for (int i = 0; i < PasswordCharLen; i++) {
                szFakePassword.Append("*");
            }
            
            PasswordTextBox.Text = szFakePassword.ToString();
        }

        ToggleSenderInfoUI(authenticateMode == 1);
    }
}

private void SaveButton_Click(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    SmtpMailSection smtpMailSection = (SmtpMailSection) config.GetSection("system.web/smtpMail");

    smtpMailSection.ServerName = ServerNameTextBox.Text;
    smtpMailSection.ServerPort = Convert.ToInt32(ServerPortTextBox.Text, CultureInfo.InvariantCulture);
    smtpMailSection.From = FromTextBox.Text;

    string authenticationMode;
    if (NoneRadioButton.Checked) {
        authenticationMode = "0";
    }
    else if (BasicRadioButton.Checked) {
        authenticationMode = "1";
    }
    else {
        authenticationMode = "2";
    }

    FieldSettingsCollection fields = smtpMailSection.Fields;
    SetField(fields, _smtpAuthenticateFieldName, authenticationMode);

    if (0 == String.Compare(authenticationMode,"1")) {
        SetField(fields, _sendUserNameFieldName, UserNameTextBox.Text);
        if (PasswordCharLen != 0) {
            StringBuilder szFakePassword = new StringBuilder("");
            for (int i = 0; i < PasswordCharLen; i++) {
                szFakePassword.Append("*");
            }
        
            if (0 == string.Compare(PasswordTextBox.Text.ToString(),szFakePassword.ToString())) {
                // user didn't change anything, we don't have to re-set something we didn't change.
            }
            else {
                // password was changed, set it
                SetField(fields, _sendPasswordFieldName, PasswordTextBox.Text);
            }
        }
        else {
            // creating a new password
            SetField(fields, _sendPasswordFieldName, PasswordTextBox.Text);
        }
    }
    else {
        SetField(fields, _sendUserNameFieldName, "");
        SetField(fields, _sendPasswordFieldName, "");
    }
    UpdateConfig(config);

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

private void SetField(FieldSettingsCollection fields, string name, string value) {
    FieldSettings fieldSettings = fields[name];
    if (value.Length == 0) {
        if (fieldSettings != null) {
            fields.Remove(name);
        }
    }
    else {
        if (fieldSettings == null) {
            fieldSettings = new FieldSettings();
            fieldSettings.Name = name;
            fieldSettings.Type = "System.String";
            fields.Add(fieldSettings);
        }
        fieldSettings.Value = value;
    }
}

private void ToggleSenderInfoUI(bool enabled) {
    UserNameLabel.Enabled = enabled;
    UserNameTextBox.Enabled = enabled;
    PasswordLabel.Enabled = enabled;
    PasswordTextBox.Enabled = enabled;
}

// Confirmation's related handlers
void ConfirmOK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}
</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Label runat="server" id="ConfigureSMTPTitle" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="90%" cellspacing="0" cellpadding="0">
        <tr class="bodyTextNoPadding">
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/><br/>
                <br/>
                <asp:Literal runat="server" Text="<%$ Resources:AuthenticationInfoNote %>"/>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp; 
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" height="100%" width="60%" cellpadding="4" rules="none"
                       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left:10;padding-right:10;">
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" border="0">
                                <tr>
                                    <td>
                                        <table class="bodyText" cellspacing="0" height="100%" width="100%" cellpadding="4" border="0">
                                            <tr>
                                                <td width="1%">
                                                    <asp:Label runat="server" AssociatedControlID="ServerNameTextBox" Text="<%$ Resources:ServerNameLabel %>"/>
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" id="ServerNameTextBox"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%">
                                                    <asp:Label runat="server" AssociatedControlID="ServerPortTextBox" Text="<%$ Resources:ServerPortLabel %>"/>
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" id="ServerPortTextBox"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%">
                                                    <asp:Label runat="server" AssociatedControlID="FromTextBox" Text="<%$ Resources:FromLabel %>"/>
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" id="FromTextBox"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left:10;padding-right:10;">
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" border="0">
                                <tr>
                                    <td>
                                        <table class="bodyText" cellspacing="0" height="100%" width="100%" cellpadding="4" border="0">
                                            <tr>
                                                <td colspan="4">
                                                    <asp:Label runat="server" Text="<%$ Resources:AuthenticationLabel %>"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%"/>
                                                <td width="1%" valign="top">
                                                    <asp:RadioButton runat="server" id="NoneRadioButton" GroupName="Authentication"
                                                                     AutoPostBack="true" OnCheckedChanged="Authentication_ValueChanged"/>
                                                </td>
                                                <td width="1%">
                                                    <asp:Label runat="server" AssociatedControlID="NoneRadioButton" Text="<%$ Resources:NoneRadioButtonText %>"/>
                                                </td>
                                                <td/>
                                            </tr>
                                            <tr>
                                                <td width="1%"/>
                                                <td width="1%" valign="top">
                                                    <asp:RadioButton runat="server" id="BasicRadioButton" GroupName="Authentication"
                                                                     AutoPostBack="true" OnCheckedChanged="Authentication_ValueChanged"/>
                                                </td>
                                                <td width="1%" colspan="2">
                                                    <asp:Label runat="server" AssociatedControlID="BasicRadioButton" Text="<%$ Resources:BasicRadioButtonText %>"/><br/>
                                                    <asp:Literal runat="server" Text="<%$ Resources:BasicAuthDesc %>"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%"/>
                                                <td width="1%"/>
                                                <td width="1%">
                                                    <asp:Label id="UserNameLabel" runat="server" AssociatedControlID="UserNameTextBox"
                                                               Text="<%$ Resources:SenderUserNameLabel %>"/>
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" id="UserNameTextBox"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%"/>
                                                <td width="1%"/>
                                                <td width="1%">
                                                    <asp:Label id="PasswordLabel" runat="server" AssociatedControlID="PasswordTextBox"
                                                               Text="<%$ Resources:SenderPasswordLabel %>"/>
                                                </td>
                                                <td>
                                                    <%-- We need a special password textbox control to retain the text in asterisks in the textbox --%>
                                                    <webadmin:PasswordValueTextBox runat="server" id="PasswordTextBox" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="1%"/>
                                                <td width="1%" valign="top">
                                                    <asp:RadioButton runat="server" id="NTLMRadioButton" GroupName="Authentication"
                                                                     AutoPostBack="true" OnCheckedChanged="Authentication_ValueChanged"/>
                                                </td>
                                                <td width="1%" colspan="2">
                                                    <asp:Label runat="server" AssociatedControlID="NTLMRadioButton" Text="<%$ Resources:NTLMRadioButtonText %>"/><br/>
                                                    <asp:Literal runat="server" Text="<%$ Resources:NTLMAuthDesc %>"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="userDetailsWithFontSize" valign="top" height="100%">
                        <td style="padding-left:10;padding-right:10;" align="right">
                            <asp:Button runat="server" Text="<%$ Resources:GlobalResources,SaveButtonLabel %>" OnClick="SaveButton_Click" width="100"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr height="100%"><td/></tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:GlobalResources,BackButtonLabel %>" id="BackButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:ConfirmationText %>"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="AppConfigHome.aspx" Text="<%$ Resources:AppConfigCommon,AppConfigHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="ConfirmOK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="75"/>
</asp:content>
