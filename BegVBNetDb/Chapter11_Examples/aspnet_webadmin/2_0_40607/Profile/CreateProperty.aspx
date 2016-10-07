<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProfilePage"%>
<%@ Register TagPrefix="property" TagName="settings" Src="propertySettings.ascx"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

void EnableAnonymous(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    AnonymousIdentificationSection anonymousIdentification = (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");
    anonymousIdentification.Enabled = true;
    Settings.AnonymousEnabled = true;
    UpdateConfig(config);
}

void Page_Init() {
    // Hook up event with the save button in user control
    Settings.SaveButton.Click += new EventHandler(this.Save);
}

void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        string parentPath = GetParentPath(appPath);

        Configuration config = GetWebConfiguration(parentPath);
        ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
        ProfileGroupSettingsCollection parentGroupSettings = profile.PropertySettings.GroupSettings;

        config = GetWebConfiguration(appPath);
        profile = (ProfileSection) config.GetSection("system.web/profile");
        ProfileGroupSettingsCollection groupSettings = profile.PropertySettings.GroupSettings;

        Settings.PopulatePropertyGroupList(parentGroupSettings, groupSettings);

        AnonymousIdentificationSection anonymousIdentification = (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");
        Settings.AnonymousEnabled = anonymousIdentification.Enabled;

        string group = HttpUtility.HtmlDecode(Request["group"]);
        if (group != null && group.Length > 0) {
            Settings.GroupName = group;
        }
    }
}

void Save(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    bool validToUpdate = true;
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection propertySettings = profile.PropertySettings;

    string name = Settings.PropertyName;
    string group = Settings.GroupName;

    if (Settings.IsCustomDataType &&
        !ProfileHelper.IsCustomDataTypeValid(Settings.DataType)) {
        Settings.CustomValidator.IsValid = false;
        Settings.CustomValidator.ErrorMessage = String.Format((string)GetPageResourceObject("CannotLoadCustomDataTypeError"), Settings.DataType);
        validToUpdate = false;
    }

    if (validToUpdate) {
        // Check if the property already exists as a property or group
        if (ProfileUtil.HasProperty(propertySettings, name, group) ||
            ((group == null || group.Length == 0) && ProfileUtil.HasGroup(propertySettings, name))) {
            Settings.CustomValidator.IsValid = false;
            Settings.CustomValidator.ErrorMessage = (string)GetPageResourceObject("PropertyNameHasBeenDefinedError");
            validToUpdate = false;
        }
        else {
            string type = Settings.DataType;
            string defaultValue = Settings.DefaultValue;
            bool allowAnonymous = Settings.AllowAnonymous;
            ProfileUtil.CreateProperty(propertySettings, name, group, type, defaultValue, allowAnonymous);
        }
   }

    if (validToUpdate) {
        UpdateConfig(config);

        // Go to confirmation UI
        ConfirmPropertyCreated.Text = String.Format((string)GetPageResourceObject("ConfirmPropertyCreatedText"), Settings.PropertyName);
        Master.SetDisplayUI(true);
    }
}

// Confirmation's related handlers
void AddAnother_Click(object s, EventArgs e) {
    Settings.ResetUI();
    Master.SetDisplayUI(false);
}

void OK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="100%" valign="top">
        <tr height="5%">
            <td class="bodyTextNoPadding" valign="top">
                <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr><td/></tr>
        <tr valign="top">
            <td>
                <property:settings runat="server" id="Settings" OnEnableAnonymous="EnableAnonymous"/>
            </td>
        </tr>
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
    <asp:Literal runat="server" id="ConfirmPropertyCreated"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="profilehome.aspx" Text="<%$ Resources:ProfileHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="AddAnother_Click" Text="<%$ Resources:GlobalResources,AddAnotherButtonLabel %>" width="140"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="OK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="110"/>
</asp:content>
