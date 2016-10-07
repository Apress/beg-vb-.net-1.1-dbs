<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ Register TagPrefix="appConfig" TagName="appSetting" Src="appSetting.ascx"%>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        if (appPath != null && !appPath.Equals(String.Empty)) {
            AppSettingTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }
    }
}

private void Save(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    bool validToUpdate = true;
    Configuration config = GetWebConfiguration(ApplicationPath);
    AppSettingsSection appSettingsSection = (AppSettingsSection) config.GetSection("appSettings");

    string name = AppSetting.Name;
    string value = AppSetting.Value;

    // Check if the name has already existed
    if (appSettingsSection.Settings[name] != null) {
        AppSetting.CustomValidator.IsValid = false;
        AppSetting.CustomValidator.ErrorMessage = (string)GetPageResourceObject("SettingAlreadyDefinedError");
        validToUpdate = false;
    }
    else {
        appSettingsSection.Settings[name] = value;
    }

    if (validToUpdate) {
        UpdateConfig(config);

        // Go to confirmation UI
        AppSettingConfirmation.Text = String.Format((string)GetPageResourceObject("ConfirmationText"), AppSetting.Name);
        Master.SetDisplayUI(true);
    }
}

// Confirmation's related handlers
private void AddAnother_Click(object s, EventArgs e) {
    AppSetting.ResetUI();
    Master.SetDisplayUI(false);
}

private void OK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" id="AppSettingTitle" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="70%" valign="top">
        <tr height="5%">
            <td class="bodyTextNoPadding" valign="top">
                <asp:literal runat="server" Text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr><td/></tr>
        <tr valign="top">
            <td>
                <appConfig:appSetting runat="server" id="AppSetting" OnSave="Save"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:GlobalResources,BackButtonLabel %>" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <asp:Literal runat="server" id="AppSettingConfirmation"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="AppConfigHome.aspx" Text="<%$ Resources:AppConfigCommon,AppConfigHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="AddAnother_Click" Text="<%$ Resources:AddAnotherButtonLabel %>" width="140"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="OK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="110"/>
</asp:content>
