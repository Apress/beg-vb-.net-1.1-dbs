<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProfilePage"%>
<%@ Register TagPrefix="property" TagName="settings" Src="propertySettings.ascx"%>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private const string _profileGroupKey = "EditProfileGroup";
private const string _profileNameKey = "EditProfileName";

private string _group;
private string _name;

private string Group {
    get {
        if (_group == null) {
            _group = HttpUtility.HtmlDecode(Request["group"]);
            if (_group != null) {
                // VSWhidbey 207149: Save group name in session in case the page
                // will be loaded through back button where it is not in query parameter.
                Session[_profileGroupKey] = _group;
            }
        }
        return _group;
    }
}

private string Name {
    get {
        if (_name == null) {
            _name = HttpUtility.HtmlDecode(Request["name"]);
            if (_name == null) {
                _name = (string) Session[_profileNameKey];
            }
            else {
                // VSWhidbey 207149: Save name in session in case the page
                // will be loaded through back button where it is not in query parameter.
                Session[_profileNameKey] = _name;
            }
        }
        return _name;
    }
}

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
        ProfileGroupSettingsCollection parentProfileGroups = profile.PropertySettings.GroupSettings;

        config = GetWebConfiguration(appPath);
        profile = (ProfileSection) config.GetSection("system.web/profile");
        ProfileGroupSettingsCollection profileGroups = profile.PropertySettings.GroupSettings;

        Settings.PopulatePropertyGroupList(parentProfileGroups, profileGroups);

        // Populate the property settings to be edited
        string name = Name;
        string group = Group;
        RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;
        ProfilePropertySettings propertySettings;

        if (group != null && group.Length > 0) {
            ProfileGroupSettings groupSettings = profileElement.GroupSettings[group];
            propertySettings = groupSettings.PropertySettings[name];
        }
        else {
            propertySettings = profileElement[name];
        }

        // PopulateData on UI            
        Settings.PropertyName = name;
        Settings.GroupName = group;

        string type = propertySettings.Type;
        if (type != null && type.Length > 0) {
            Settings.DataType = type;
        }
        Settings.DefaultValue = propertySettings.DefaultValue;
        Settings.AllowAnonymous = propertySettings.AllowAnonymous;

        AnonymousIdentificationSection anonymousIdentification = (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");
        Settings.AnonymousEnabled = anonymousIdentification.Enabled;

        // Save the original name and group so we know which one we should
        // change if the user change the property name.
        OriginalName.Value = name;
        OriginalGroup.Value = group;
    }
}

void Save(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    bool validToUpdate = true;
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;

    string name = Settings.PropertyName;
    string group = Settings.GroupName;

    if (Settings.IsCustomDataType &&
        !ProfileHelper.IsCustomDataTypeValid(Settings.DataType)) {
        Settings.CustomValidator.IsValid = false;
        Settings.CustomValidator.ErrorMessage = String.Format((string)GetPageResourceObject("CannotLoadCustomDataTypeError"), Settings.DataType);
        validToUpdate = false;
    }

    if (validToUpdate) {
        // Check if the property already exists as a property or group when name or group has been changed
        if (((OriginalName.Value != name) || (OriginalGroup.Value != group)) &&
            (ProfileUtil.HasProperty(profileElement, name, group) ||
             ((group == null || group.Length == 0) && ProfileUtil.HasGroup(profileElement, name)))) {
            Settings.CustomValidator.IsValid = false;
            Settings.CustomValidator.ErrorMessage = (string)GetPageResourceObject("PropertyNameHasBeenDefinedError");
            validToUpdate = false;
        }
        else {
            bool allowAnonymous = Settings.AllowAnonymous;
            string defaultValue = Settings.DefaultValue;
            string type = Settings.DataType;
        
            // If group name has been changed
            if (OriginalGroup.Value != group) {
                ProfileUtil.DeleteProperty(profileElement, OriginalName.Value, OriginalGroup.Value);
                ProfileUtil.CreateProperty(profileElement, name, group, type, defaultValue, allowAnonymous);
            }
            else {
                ProfileUtil.UpdateProperty(profileElement, OriginalName.Value, name, group, type, defaultValue, allowAnonymous);
            }
        }
    }

    if (validToUpdate) {
        UpdateConfig(config);
        ReturnToPreviousPage(s, e);
    }
}

</script>

<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <asp:HiddenField runat="server" id="OriginalName"/>
    <asp:HiddenField runat="server" id="OriginalGroup"/>

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
