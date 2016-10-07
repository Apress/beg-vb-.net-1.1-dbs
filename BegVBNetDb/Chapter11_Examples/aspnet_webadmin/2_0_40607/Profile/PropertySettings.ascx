<%@ Control language="cs" Inherits="System.Web.Administration.WebAdminUserControl"%>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private bool _anonymousEnabled;

public bool AllowAnonymous {
    get {
        return AnonymousCheckBox.Checked;
    }
    set {
        AnonymousCheckBox.Checked = value;
    }
}

public bool AnonymousEnabled {
    get {
        return _anonymousEnabled;
    }
    set {
        _anonymousEnabled = value;

        if (_anonymousEnabled) {
            AnonymousStatusPlaceHolder.Visible = false;
            AnonymousCheckBox.Enabled = true;
            MakeAnonymousLabel.ForeColor = Color.Empty;
        }
        else {
            AnonymousStatusPlaceHolder.Visible = true;
            AnonymousCheckBox.Enabled = false;
            MakeAnonymousLabel.ForeColor = Color.Gray;
        }
    }
}

public CustomValidator CustomValidator {
    get {
        return CustomVal;
    }
}

public string DefaultValue {
    get {
        if (NetTypeRadioButton.Checked) {
            return DefaultValueBox.Text;
        }
        else {
            return string.Empty;
        }
    }
    set {
        if (NetTypeRadioButton.Checked) {
            DefaultValueBox.Text = value;
        }
        else if (value != null && value.Length > 0) {
            // TODO: Remove the exception since it is only used to catch development error.
            //       No need to localize.
            throw new Exception("Default value not supported for custom type");
        }
    }
}

public string DataType {
    get {
        if (NetTypeRadioButton.Checked) {
            return TypeList.SelectedValue;
        }
        else {
            return TypeNameTextBox.Text;
        }
    }
    set {
        string resolvedTypeName = ProfileUtil.ResolveFullTypeName(value);
        if (resolvedTypeName != null) {
            TypeList.SelectedValue = resolvedTypeName;
            ResetTypeUI(true);
        }
        else {
            TypeNameTextBox.Text = value;
            ResetTypeUI(false);
        }
    }
}

public string GroupName {
    get {
        string groupName = string.Empty;
        if (GroupNames.SelectedIndex != 0) {
            groupName = GroupNames.SelectedValue;
        }
        return groupName;
    }
    set {
        GroupNames.SelectedValue = value;
    }
}

public bool IsCustomDataType {
    get {
        return CustomTypeRadioButton.Checked;
    }
}

public String PropertyName {
    get {
        return PropertyNameTextBox.Text;
    }
    set {
        PropertyNameTextBox.Text = value;
    }
}

public Button SaveButton {
    get {
        return Save;
    }
}

public event EventHandler EnableAnonymous {
    add {
        EnableAnonymousLinkButton.Click += value;
    }
    remove {
        EnableAnonymousLinkButton.Click -= value;
    }
}

void CustomTypeChanged(object sender, EventArgs e) {
    ResetTypeUI(false);
}

void DefaultValueValidity_ServerValidate(object source, ServerValidateEventArgs args) {
    if (NetTypeRadioButton.Checked) {
        try {
            object temp = ProfileUtil.ConvertStringValueForType(DataType, args.Value);
        }
        catch (Exception e){
            args.IsValid = false;
            DefaultValueValidityCustomVal.ErrorMessage = String.Format((string)GetPageResourceObject("ConversionErrorText"), e.Message);
        }
    }
}

void NameValidity_ServerValidate(object source, ServerValidateEventArgs args) {
    args.IsValid = ProfileUtil.CheckNameForValidity(args.Value);
}

void NetTypeChanged(object sender, EventArgs e) {
    ResetTypeUI(true);
}

void Page_Init(Object Src, EventArgs e) {
    TypeList.SelectedValue = "System.String";
}

public void PopulatePropertyGroupList(ProfileGroupSettingsCollection parentGroups,
                                      ProfileGroupSettingsCollection groups) {
    ListItem item = new ListItem((string)GetPageResourceObject("NoGroupItemText"), string.Empty);
    GroupNames.Items.Add(item);
    foreach (ProfileGroupSettings group in groups) {
        string groupName = group.Name;

        // We don't allow adding to an inherited group
        if (parentGroups[groupName] == null) {
            item = new ListItem(groupName, groupName);
            GroupNames.Items.Add(item);
        }
    }
}

public void ResetUI() {
    // left panel controls
    PropertyNameTextBox.Text = null;
    GroupNames.SelectedIndex = -1;
    AnonymousCheckBox.Checked = false;

    // right panel controls
    TypeList.SelectedValue = "System.String";
    DefaultValueBox.Text = null;
    TypeNameTextBox.Text = null;
    ResetTypeUI(true);
}

void ResetTypeUI(bool isNetType) {
    if (isNetType) {
        NetTypeRadioButton.Checked = true;
        DataTypeLabel.ForeColor = Color.Empty;
        DefaultValueLabel.ForeColor = Color.Empty;
        TypeList.Enabled = true;
        DefaultValueBox.Enabled = true;

        CustomTypeRadioButton.Checked = false;
        TypeNameLabel.ForeColor = Color.Gray;
        TypeNameTextBox.Enabled = false;
        TypeNameRequiredVal.Enabled = false;
    }
    else {
        NetTypeRadioButton.Checked = false;
        DataTypeLabel.ForeColor = Color.Gray;
        DefaultValueLabel.ForeColor = Color.Gray;
        TypeList.Enabled = false;
        DefaultValueBox.Enabled = false;

        CustomTypeRadioButton.Checked = true;
        TypeNameLabel.ForeColor = Color.Empty;
        TypeNameTextBox.Enabled = true;
        TypeNameRequiredVal.Enabled = true;
    }
}

</script>

<table cellspacing="0" height="100%" width="100%" rules="none"
       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
    <tr class="callOutStyle" valign="top" height="5%" cellpadding="4">
        <td style="padding-left:10;padding-right:10;"><asp:Literal runat="server" Text="<%$ Resources:Title %>"/></td>
    </tr>

    <tr valign="top">
        <td>
            <table height="100%" width="100%" frame="void" rules="cols"
                   bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                <tr>
                    <%-- left panel --%>
                    <td width="55%">
                        <table height="100%" width="100%" valign="top">
                            <tr valign="top" class="bodyText" height="10%">
                                <td>
                                    <table height="10%" width="100%" valign="top">
                                        <tr class="bodyText"><td><asp:Label runat="server" AssociatedControlID="PropertyNameTextBox" Text="<%$ Resources:PropertyNameLabel %>"/></td></tr>
                                        <tr class="bodyText"><td><asp:TextBox runat=server id="PropertyNameTextBox" maxLength="256" width="155"/></td></tr>
                                        <tr><td></td></tr>
                                        <tr class="bodyText"><td><asp:Label runat="server" AssociatedControlID="GroupNames" Text="<%$ Resources:PropertyGroupLabel %>"/></td></tr>
                                        <tr class="bodyText"><td><asp:DropDownList runat=server id="GroupNames" width="155"/></td></tr>
                                        <tr class="bodyText">
                                            <td>
                                                <asp:HyperLink runat=server NavigateUrl="ManageGroups.aspx"
                                                               text="<%$ Resources:ManageGroupsLinkText %>"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                            <tr valign="top">
                                <td>
                                    <table height="100%" width="100%" valign="top">
                                        <tr valign="top">
                                            <td><asp:CheckBox runat=server id="AnonymousCheckBox"/></td>
                                            <td>
                                                <table>
                                                    <tr valign="top" class="bodyText">
                                                        <td>
                                                            <asp:Label runat="server" id="MakeAnonymousLabel" AssociatedControlID="AnonymousCheckBox"
                                                                       text="<%$ Resources:ManageAnonymousDesc %>"/>
                                                        </td>
                                                    </tr>
                                                    <tr><td/></tr>
                                                    <tr valign="top" class="bodyText">
                                                        <td>
                                                            <asp:PlaceHolder runat="server" id="AnonymousStatusPlaceHolder">
                                                                <asp:Literal runat="server" Text="<%$ Resources:DisabledAnonymousText %>"/><br/>
                                                                <asp:LinkButton runat="server" id="EnableAnonymousLinkButton"
                                                                                ValidationGroup="NoValidation"
                                                                                Text="<%$ Resources:EnableAnonymousLinkText %>"/>
                                                            </asp:PlaceHolder>
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
                    <td width="45%">
                        <table height="100%" width="100%" valign="top">
                            <tr class="bodyText" height="1%"><td colspan="2"><asp:Literal runat="server" Text="<%$ Resources:DataTypeLabel %>"/></td></tr>
                            <tr class="bodyText" height="%1" valign="top">
                                <td valign="top" colspan="2" height="1%">
                                    <asp:RadioButton runat="server" id="NetTypeRadioButton" groupName="DataType" text="<%$ Resources:NETDataTypeLabel %>" AutoPostBack="true" OnCheckedChanged="NetTypeChanged" Checked="true"/>
                                </td>
                            </tr>
                            <tr valign="top" class="bodyText" height="1%">
                                <td width="15"></td>
                                <td>
                                    <table height="1%" width="100%" valign="top">
                                        <tr valign="top" class="bodyText"><td><asp:Label runat=server id="DataTypeLabel" AssociatedControlID="TypeList" text="<%$ Resources:DataTypeLabel %>"/></td></tr>
                                        <tr valign="top" class="bodyText">
                                            <td>
                                                <asp:DropDownList runat=server id="TypeList" width="155">
                                                    <asp:ListItem text="Boolean" value="System.Boolean"/>
                                                    <asp:ListItem text="Char" value="System.Char"/>
                                                    <asp:ListItem text="DateTime" value="System.DateTime"/>
                                                    <asp:ListItem text="Decimal" value="System.Decimal"/>
                                                    <asp:ListItem text="Double" value="System.Double"/>
                                                    <asp:ListItem text="Int32" value="System.Int32"/>
                                                    <asp:ListItem text="Int64" value="System.Int64"/>
                                                    <asp:ListItem text="Single" value="System.Single"/>
                                                    <asp:ListItem text="String" value="System.String"/>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr valign="top" class="bodyText"><td><asp:Label runat=server id="DefaultValueLabel" AssociatedControlID="DefaultValueBox" text="<%$ Resources:DefaultValueLabel %>"/></td></tr>
                                        <tr valign="top" class="bodyText"><td><asp:TextBox runat=server id="DefaultValueBox" maxLength="256" width="155"/></td></tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="%1">
                                <td colspan="2"/>
                            </tr>
                            <tr class="bodyText" height="%1" valign="top">
                                <td valign="top" colspan="2" height="1%">
                                    <asp:RadioButton runat="server" id="CustomTypeRadioButton" groupName="DataType" text="<%$ Resources:CustomDataTypeLabel %>" AutoPostBack="true" OnCheckedChanged="CustomTypeChanged"/>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td width="15"></td>
                                <td>
                                    <table height="1%" width="100%" valign="top">
                                        <tr class="bodyText" valign="top"><td><asp:Label runat=server id="TypeNameLabel" AssociatedControlID="TypeNameTextBox" text="<%$ Resources:TypeNameLabel %>" ForeColor="Gray"/></td></tr>
                                        <tr class="bodyText" valign="top"><td><asp:TextBox runat=server id="TypeNameTextBox" maxLength="1024" Enabled="false" width="155"/></td></tr>
                                    </table>  
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr class="userDetailsWithFontSize" valign="top" height="5%">
        <td>
            <table height="100%" width="100%">
                <tr>
                    <td class="bodyText">
                        <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"/>
                        <asp:RequiredFieldValidator runat="server" EnableClientScript="false" ControlToValidate="PropertyNameTextBox"
                                                    ErrorMessage="<%$ Resources:PropertyNameRequiredError %>" Display="none"/>
                        <asp:RequiredFieldValidator runat="server" EnableClientScript="false" ControlToValidate="TypeNameTextBox"
                                                    ErrorMessage="<%$ Resources:TypeNameRequiredError %>" Display="none"
                                                    Enabled="false" id="TypeNameRequiredVal"/>
                        <asp:CustomValidator runat="server" Display="none" ControlToValidate="PropertyNameTextBox"
                                             OnServerValidate="NameValidity_ServerValidate"
                                             ErrorMessage="<%$ Resources:PropertyNameInvalidError %>"/>
                        <asp:CustomValidator runat="server" Display="none" ControlToValidate="DefaultValueBox" id="DefaultValueValidityCustomVal"
                                             OnServerValidate="DefaultValueValidity_ServerValidate"/>
                        <asp:CustomValidator runat="server" Display="none" Enabled="false" id="CustomVal"/>
                    </td>
                    <td style="padding-right:10;" align="right" width="20%" valign="top">
                        <asp:Button runat=server id="Save" Text="<%$ Resources:GlobalResources,SaveButtonLabel %>" width="100"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
