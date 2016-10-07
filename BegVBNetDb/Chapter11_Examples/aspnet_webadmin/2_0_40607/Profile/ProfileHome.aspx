<%@ Page masterPageFile="~/WebAdminWithConfirmationNoButtonRow.master" inherits="System.Web.Administration.ProfilePage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmationNoButtonRow.master" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server" language="cs">

private void EnableAnonymousClick(object s, EventArgs e) {
    bool goToConfirmationPage = false;
    Configuration config = GetWebConfiguration(ApplicationPath);
    AnonymousIdentificationSection anonymousIdentification =
            (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");
    bool anonymousEnabled = anonymousIdentification.Enabled;

    // When we want to disable anonymous, we need to warn users if there are
    // any profile properties that have anonymous supported by going
    // to the confirmation page.
    if (anonymousEnabled) {
        ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
        RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;

        foreach (ProfilePropertySettings property in profileElement) {
            if (property.AllowAnonymous) {
                goToConfirmationPage = true;
                break;
            }
        }

        if (!goToConfirmationPage) {
            foreach (ProfileGroupSettings group in profileElement.GroupSettings) {
                foreach (ProfilePropertySettings property in group.PropertySettings) {
                    if (property.AllowAnonymous) {
                        goToConfirmationPage = true;
                        break;
                    }
                }

                if (goToConfirmationPage) {
                    break;
                }
            }
        }
    }

    if (!goToConfirmationPage) {
        anonymousIdentification.Enabled = !anonymousEnabled;
        UpdateConfig(config);
        UpdateEnableAnonymousUI();
    }
    else {
        Master.SetDisplayUI(true);
    }
}


public void EnableLink_OnClick(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = GetProfileSection(config);
    profile.Enabled = !profile.Enabled;
    SetUI(profile);
    UpdateConfig(config);
}

private ProfileSection GetProfileSection(Configuration config) {
    return (ProfileSection) config.GetSection("system.web/profile");
}

public void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        if (appPath != null && !appPath.Equals(String.Empty)) {
            application.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        Configuration config = GetWebConfiguration(appPath);
        ProfileSection profile = GetProfileSection(config);
        SetUI(profile);
        UpdateEnableAnonymousUI();
    }
}

private void SetLinkUI(WebControl control, bool enable) {
    if (enable) {
        control.ForeColor = Color.Empty;
        control.Attributes["onclick"] = null;
    }
    else {
        control.ForeColor = Color.Gray;
        control.Attributes["onclick"] = "return false;";
    }
}

private void SetUI(ProfileSection profile) {
    if (profile.Enabled) {
        EnableLink.Text = (string)GetPageResourceObject("DisableProfileLinkText");

        SetLinkUI(CreateProperty, true);
        SetLinkUI(ManageProperties, true);
        SetLinkUI(ManageGroups, true);
        SetLinkUI(RemoveData, true);

        ProfileInfoTable.Visible = false;
    }
    else {
        EnableLink.Text = (string)GetPageResourceObject("EnableProfileLinkText");

        SetLinkUI(CreateProperty, false);
        SetLinkUI(ManageProperties, false);
        SetLinkUI(ManageGroups, false);
        SetLinkUI(RemoveData, false);

        ProfileInfoTable.Visible = true;
    }
}

private void UpdateEnableAnonymousUI() {
    Configuration config = GetWebConfiguration(ApplicationPath);
    AnonymousIdentificationSection anonymousIdentification = (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");

    if (anonymousIdentification.Enabled) {
        enableAnonymous.Text = (string)GetPageResourceObject("DisableAnonymouseLinkText");
    }
    else {
        enableAnonymous.Text = (string)GetPageResourceObject("EnableAnonymouseLinkText");
    }
}

// Confirmation's related handlers
void DeleteOK_Click(object s, EventArgs e) {
    Configuration config = GetWebConfiguration(ApplicationPath);
    ProfileSection profile = (ProfileSection) config.GetSection("system.web/profile");
    RootProfilePropertySettingsCollection profileElement = profile.PropertySettings;

    foreach (ProfilePropertySettings property in profileElement) {
        if (property.AllowAnonymous) {
            property.AllowAnonymous = false;
        }
    }

    foreach (ProfileGroupSettings group in profileElement.GroupSettings) {
        foreach (ProfilePropertySettings property in group.PropertySettings) {
            if (property.AllowAnonymous) {
                property.AllowAnonymous = false;
            }
        }
    }

    AnonymousIdentificationSection anonymousIdentification =
        (AnonymousIdentificationSection) config.GetSection("system.web/anonymousIdentification");
    anonymousIdentification.Enabled = false;

    UpdateConfig(config);
    UpdateEnableAnonymousUI();
    Master.SetDisplayUI(false);
}

void DeleteCancel_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

</script>


<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:literal runat="server" id="application" text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="100%" valign="top">
        <tr height="10%">
            <td class="bodyTextNoPadding" colspan="5" valign="top">
                <asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr>
            <td width="32%" valign="top">
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle" height="1%">
                        <td style="padding-left:10;padding-right:10;"><asp:literal runat="server" text="<%$ Resources:EnableProfileHeader %>"/></td>
                    </tr>
                    <tr class="bodyText" valign="top">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:linkButton runat="server" id="EnableLink" onclick="EnableLink_OnClick" /><br/>
                            <br/>
                            <table runat="server" id="ProfileInfoTable" width="100%" valign="top">
                                <tr class="bodyText" valign="top">
                                    <td>
                                        <asp:Image runat="server" id="Alert" ImageUrl="~/images/alert_sml.gif"/>
                                    </td>
                                    <td>
                                        <asp:Label runat=server id="Warning" Text="<%$ Resources:ProfileDisabledWarning %>"/>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <asp:linkButton runat="server" id="enableAnonymous" onclick="EnableAnonymousClick" />
                                    
                        </td>
                    </tr>
                </table>
            </td>
            <td width ="1%"/>
            <td width="34%" valign="top">
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-left:10;padding-right:10;"><asp:literal runat="server" text="<%$ Resources:ManageProfileHeader %>"/></td>
                    </tr>
                    <tr class="bodyText"  height="100%" valign="top">
                        <td style="padding-left:10;padding-right:10;">
                            <b><asp:literal runat="server" text="<%$ Resources:ManageProfileLabel %>"/></b><br>
                            <asp:HyperLink runat="server" id="CreateProperty" text="<%$ Resources:CreatePropertyLinkText %>" NavigateUrl="CreateProperty.aspx"/><br/>
                            <asp:HyperLink runat="server" id="ManageProperties" text="<%$ Resources:ManagePropertiesLinkText %>" NavigateUrl="ManageProperties.aspx"/><br/>
                            <br/>

                            <b><asp:literal runat="server" text="<%$ Resources:ManagePropertyGroupsLabel %>"/></b><br>
                            <asp:HyperLink runat="server" id="ManageGroups" text="<%$ Resources:ManageGroupsLinkText %>" NavigateUrl="ManageGroups.aspx"/><br/>
                        </td>
                    </tr>
                </table>
            </td>
            <td width ="1%"/>
            <td width="32%" valign="top">
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-left:10;padding-right:10;"><asp:literal runat="server" text="<%$ Resources:CleanUpDataHeader %>"/></td>
                    </tr>
                    <tr class="bodyText" height="100%" valign="top">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:HyperLink runat="server" id="RemoveData" text="<%$ Resources:RemoveDataLinkText %>" NavigateUrl="RemoveData.aspx"/><br/>
                            <asp:literal runat="server" text="<%$ Resources:RemoveDataDesc %>"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:content>


<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:literal runat="server" text="<%$ Resources:DisableAnonymousProfileTitle %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td valign="top">
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:literal runat="server" text="<%$ Resources:AnonymousUserPropertiesExistConfirmationText %>"/><br/>
                <br/>
                <asp:literal runat="server" text="<%$ Resources:ClickOKConfirmationText %>"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="DeleteOK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="110"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="DeleteCancel_Click" Text="<%$ Resources:GlobalResources,CancelButtonLabel %>" width="110"/>
</asp:content>
