<%@ Control language="cs" ClassName="ProviderSettings" Inherits="System.Web.Administration.WebAdminUserControl"%>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server">

public string AccessDescription {
    get {
        string filteredText = AccessDescriptionBox.Text.Replace("\r\n", " ");
        AccessDescriptionBox.Text = filteredText;
        return filteredText;
    }
    set {
        AccessDescriptionBox.Text = value;
    }
}

public string AccessFileName {
    get {
        return AccessFileNameBox.Text;
    }
    set {
        AccessFileNameBox.Text = value;
    }
}

public string AccessFriendlyName {
    get {
        return AccessFriendlyNameBox.Text;
    }
    set {
        AccessFriendlyNameBox.Text = value;
    }
}

public DatabaseType CurrentDatabaseType {
    get {
        if (SqlRadioButton.Checked) {
            return DatabaseType.Sql;
        }
        else {
            return DatabaseType.Access;
        }
    }
    set {
        if (value == DatabaseType.Sql) {
            SqlRadioButton.Checked = true;
            AccessRadioButton.Checked = false;
            TestButton.Visible = !((WebAdminPage)Page).IsConfigLocalOnly();
            DatabaseInfoMultiView.ActiveViewIndex = 0;
        }
        else {
            SqlRadioButton.Checked = false;
            AccessRadioButton.Checked = true;
            TestButton.Visible = false;
            DatabaseInfoMultiView.ActiveViewIndex = 1;
        }
    }
}

public string SqlDatabaseName {
    get {
        return SqlDatabaseNameBox.Text;
    }
    set {
        SqlDatabaseNameBox.Text = value;
    }
}

public string SqlDescription {
    get {
        string filteredText = SqlDescriptionBox.Text.Replace("\r\n", " ");
        SqlDescriptionBox.Text = filteredText;
        return filteredText;
    }
    set {
        SqlDescriptionBox.Text = value;
    }
}

public string SqlFriendlyName {
    get {
        return SqlFriendlyNameBox.Text;
    }
    set {
        SqlFriendlyNameBox.Text = value;
    }
}

public string SqlLoginName {
    get {
        return SqlLoginNameBox.Text;
    }
    set {
        SqlLoginNameBox.Text = value;
    }
}

public string SqlLoginPassword {
    get {
        return SqlLoginPasswordBox.Text;
    }
    set {
        SqlLoginPasswordBox.Text = value;
    }
}

public bool SqlMixedMode {
    get {
        return SqlMixedModeCheckBox.Checked;
    }
    set {
        SqlMixedModeCheckBox.Checked = value;
    }
}

public string SqlServerName {
    get {
        return SqlServerNameBox.Text;
    }
    set {
        SqlServerNameBox.Text = value;
    }
}

public event EventHandler SaveClick{
    add {
        SaveButton.Click += value;
    }
    remove {
        SaveButton.Click -= value;
    }
}

public event EventHandler TestClick{
    add {
        TestButton.Click += value;
    }
    remove {
        TestButton.Click -= value;
    }
}

private void DatabaseCheckedChanged(object s, EventArgs e) {
    RadioButton radioButton = (RadioButton) s;

    if (radioButton.ID == "SqlRadioButton") {
        CurrentDatabaseType = DatabaseType.Sql;
        TestButton.Visible = !((WebAdminPage)Page).IsConfigLocalOnly();
    }
    else {
        CurrentDatabaseType = DatabaseType.Access;
        TestButton.Visible = false;
    }
}

public void Page_Init() {
    TestButton.Visible = !((WebAdminPage)Page).IsConfigLocalOnly() && CurrentDatabaseType == DatabaseType.Sql;
}

public void ResetUI() {
    AccessFileName = null;
    AccessFriendlyName = null;
    AccessDescription = null;
    CurrentDatabaseType = DatabaseType.Sql;
    SqlDatabaseName = null;
    SqlDescription = null;
    SqlFriendlyName = null;
    SqlLoginName = null;
    SqlLoginPassword = null;
    SqlMixedMode = false;
    SqlServerName = null;
}

private void SqlMixedModeCheckedChanged(object s, EventArgs e) {
    CheckBox mixedMode = (CheckBox) s;

    if (mixedMode.Checked) {
        MixedModeArea.ForeColor = Color.Empty;
        MixedModeArea.Enabled = true;
    }
    else {
        MixedModeArea.ForeColor = Color.Gray;
        MixedModeArea.Enabled = false;
    }
}

</script>

<asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
<br/>

<table cellspacing="0" height="100%" width="100%" rules="none"
       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
    <tr class="callOutStyle" valign="top" height="5%" cellpadding="4">
        <td style="padding-left:10;padding-right:10;"><asp:literal runat="server" text="<%$ Resources:DatabaseType %>"/></td>
    </tr>

    <tr valign="top">
        <td>
            <table height="100%" width="100%" frame="void" rules="cols"
                   bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                <tr>
                    <%-- left panel --%>
                    <td width="45%">
                        <table height="100%" width="100%" valign="top">
                            <tr height="1%">
                                <td>
                                    <table height="100%" width="100%" valign="top">
                                        <tr valign="top">
                                            <td><asp:RadioButton runat=server id="SqlRadioButton" AutoPostBack="true"
                                                                 OnCheckedChanged="DatabaseCheckedChanged" Checked="true"/>
                                            </td>
                                            <td>
                                                <table>
                                                    <tr valign="top" class="bodyText">
                                                        <td>
                                                            <asp:Label runat="server" AssociatedControlID="SqlRadioButton"
                                                                       Text="<%$ Resources:SQLServerDatabase %>" Font-Bold="true"/><br/>
                                                            <asp:literal runat="server" text="<%$ Resources:SQLServerExplanation %>"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table height="100%" width="100%" valign="top">
                                        <tr valign="top">
                                            <td><asp:RadioButton runat=server id="AccessRadioButton" AutoPostBack="true"
                                                                 OnCheckedChanged="DatabaseCheckedChanged"/>
                                            </td>
                                            <td>
                                                <table>
                                                    <tr valign="top" class="bodyText">
                                                        <td>
                                                            <asp:Label runat="server" AssociatedControlID="AccessRadioButton"
                                                                       Text="<%$ Resources:AccessDatabase %>" Font-Bold="true"/><br/>

                                                            <asp:literal runat="server" text="<%$ Resources:AccessExplanation %>"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>

                    <%-- right panel --%>
                    <td width="55%" style="background-color:#E0EBF5">
                        <asp:multiview runat="server" id="DatabaseInfoMultiView" ActiveViewIndex="0">
                            <asp:view runat="server">
                                <table height="100%" width="100%" valign="top">
                                    <tr valign="top" class="bodyText" height="1%">
                                        <td>
                                            <b><asp:literal runat="server" text="<%$ Resources:SQLServerConnectionInfo %>"/></b>
                                        </td>
                                    </tr>
                                    <tr height="1%">
                                        <td>
                                            <table>
                                                <tr valign="top" class="bodyText">
                                                    <td>
                                                        <asp:Label runat="server" width="150" Text="<%$ Resources:ServerName %>"/>
                                                        <asp:TextBox runat="server" id="SqlServerNameBox" Text="(local)" width="170"/><br/>
                                                        <asp:Label runat="server" width="150" Text="<%$ Resources:FriendlyName %>"/>
                                                        <asp:TextBox runat="server" id="SqlFriendlyNameBox" width="170"/><br/>
                                                        <asp:Label runat="server" width="150" Text="<%$ Resources:DatabaseName %>"/>
                                                        <asp:TextBox runat="server" id="SqlDatabaseNameBox" width="170"/>
                                                        <table valign="top" cellspacing="0" cellpadding="0" height="1%" width="100%">
                                                            <tr class="bodyTextNoPadding">
                                                                <td valign="top">
                                                                    <asp:Label runat="server" width="150" Text="<%$ Resources:Description %>"/>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox runat="server" id="SqlDescriptionBox" width="340" TextMode="MultiLine" Rows="3"/>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr height="1%">
                                        <td>
                                            <table height="100%" width="100%" valign="top">
                                                <tr valign="top">
                                                    <td><asp:CheckBox runat=server id="SqlMixedModeCheckBox" AutoPostBack="true"
                                                                      OnCheckedChanged="SqlMixedModeCheckedChanged"/>
                                                    </td>
                                                    <td>
                                                        <table>
                                                            <tr valign="top" class="bodyText">
                                                                <td>
                                                                    <asp:Label runat="server" AssociatedControlID="SqlMixedModeCheckBox" Text="<%$ Resources:MixedExplanation %>"/>
                                                                    <asp:Panel runat="server" id="MixedModeArea" ForeColor="Gray" Enabled="false">
                                                                        <asp:Label runat="server" width="120" Text="<%$ Resources:LoginName %>"/>
                                                                        <asp:TextBox runat="server" id="SqlLoginNameBox" width="170"/><br/>
                                                                        <asp:Label runat="server" width="120" Text="<%$ Resources:LoginPassword %>"/>
                                                                        <asp:TextBox runat="server" id="SqlLoginPasswordBox" TextMode="Password" width="170"/>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    <tr>
                                    <tr valign="top">
                                        <td>
                                            <asp:validationsummary runat="server" cssclass="bodyTextNoPadding" headertext="<%$ Resources:PleaseCorrect %>" ValidationGroup="Save"/>
                                            <asp:requiredfieldvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="SqlFriendlyNameBox" enableclientscript="true" errormessage="<%$ Resources:FriendlyNameRequired %>" display="none" ValidationGroup="Save"/>
                                            <asp:requiredfieldvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="SqlServerNameBox" enableclientscript="true" errormessage="<%$ Resources:ServerNameRequired %>" display="none" ValidationGroup="Save"/>
                                            <asp:requiredfieldvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="SqlDatabaseNameBox" enableclientscript="true" errormessage="<%$ Resources:DBNameRequired %>" display="none" ValidationGroup="Save"/>
                                        </td>
                                    </tr>
                                </table>
                            </asp:view>

                            <asp:view runat="server">
                                <table height="100%" width="100%" valign="top">
                                    <tr valign="top" class="bodyText" height="1%">
                                        <td>
                                            <asp:Label runat="server" width="120" Text="<%$ Resources:FriendlyName %>"/><br/>
                                            <asp:TextBox runat="server" id="AccessFriendlyNameBox" width="170"/><br/>
                                            <asp:Label runat="server" width="120" Text="<%$ Resources:FileName %>"/><br/>
                                            <asp:TextBox runat="server" id="AccessFileNameBox" width="170"/><br/>
                                            <asp:Label runat="server" width="120" Text="<%$ Resources:Description %>"/><br/>
                                            <asp:TextBox runat="server" id="AccessDescriptionBox" width="340" TextMode="MultiLine" Rows="3"/>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td>
                                            <asp:validationsummary runat="server" cssclass="bodyTextNoPadding" headertext="<%$ Resources:PleaseCorrect %>" ValidationGroup="Save"/>
                                            <asp:requiredfieldvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="AccessFriendlyNameBox" enableclientscript="true" errormessage="<%$ Resources:FriendlyNameRequired %>" display="none" ValidationGroup="Save"/>
                                            <asp:requiredfieldvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="AccessFileNameBox" enableclientscript="true" errormessage="<%$ Resources:DBNameRequired %>" display="none" ValidationGroup="Save"/>
                                            <asp:regularexpressionvalidator runat="server" cssclass="bodyTextNoPadding" controltovalidate="AccessFileNameBox" enableclientscript="true" errormessage="<%$ Resources:DBNameInvalid %>" display="none" validationGroup="Save" validationExpression="(^[^\/:*?<>|\\\.]+(\.mdb)?$)"/>
                                        </td>
                                    </tr>
                                </table>
                            </asp:view>
                        </asp:multiview>
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr class="userDetailsWithFontSize" height="50">
        <td style="padding-right:10;" align="right" valign="top" width="20%">
            <asp:Button runat=server id="TestButton" width="140" Text="<%$ Resources:TestConnection %>"/>
            <asp:Button runat=server id="SaveButton" width="100" Text="<%$ Resources:Save %>" ValidationGroup="Save"/>
        </td>
    </tr>
</table>
