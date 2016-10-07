<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private void ControlCountersEnabledCheckBox_OnCheckedChanged(object s, EventArgs e) {
    ToggleSiteCountersUI(ControlCountersEnabledCheckBox.Checked, PageCountersEnabledCheckBox.Checked);
}

private void FillUIWithConfigInfo(SiteCountersSection siteCountersSection) {
    ControlCountersEnabledCheckBox.Checked = siteCountersSection.Enabled;
    RowsPerDayTextBox.Text = siteCountersSection.RowsPerDay.ToString(CultureInfo.InvariantCulture);

    PageCountersElement pageCountersElement = siteCountersSection.PageCounters;
    PageCountersEnabledCheckBox.Checked = pageCountersElement.Enabled;
    TrackAppNameCheckBox.Checked = pageCountersElement.TrackApplicationName;
    TrackPageUrlCheckBox.Checked = pageCountersElement.TrackPageUrl;
    CounterNameTextBox.Text = pageCountersElement.CounterName;
    CounterGroupTextBox.Text = pageCountersElement.CounterGroup;
}

private void Page_Load() {
    string appPath = ApplicationPath;
    if (!IsPostBack) {
        if (appPath != null && !appPath.Equals(String.Empty)) {
            ConfigureCounterTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        Configuration config = GetWebConfiguration(appPath);
        SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
        PageCountersElement pageCountersElement = siteCountersSection.PageCounters;

        ToggleSiteCountersUI(siteCountersSection.Enabled, pageCountersElement.Enabled);
        FillUIWithConfigInfo(siteCountersSection);
    }
}

private void PageCountersEnabledCheckBox_OnCheckedChanged(object s, EventArgs e) {
    TogglePageCountersUI(PageCountersEnabledCheckBox.Checked);
}

private void RowsPerDayList_SelectedIndexChanged(object s, EventArgs e) {
    RowsPerDayTextBox.Text = RowsPerDayList.SelectedItem.Value;
}

private void SaveButton_Click(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    Configuration config = GetWebConfiguration(ApplicationPath);
    SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
    SetConfigWithUIInfo(siteCountersSection);
    UpdateConfig(config);

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

private void SetConfigWithUIInfo(SiteCountersSection siteCountersSection) {
    siteCountersSection.Enabled = ControlCountersEnabledCheckBox.Checked;
    siteCountersSection.RowsPerDay = Convert.ToInt32(RowsPerDayTextBox.Text, CultureInfo.InvariantCulture);

    PageCountersElement pageCountersElement = siteCountersSection.PageCounters;
    pageCountersElement.Enabled = PageCountersEnabledCheckBox.Checked;
    pageCountersElement.TrackApplicationName = TrackAppNameCheckBox.Checked;
    pageCountersElement.TrackPageUrl = TrackPageUrlCheckBox.Checked;
    pageCountersElement.CounterName = CounterNameTextBox.Text;
    pageCountersElement.CounterGroup = CounterGroupTextBox.Text;
}

private void ToggleSiteCountersUI(bool siteCountersEnabled, bool pageCountersEnabled) {
    PageCountersEnabledCheckBox.Enabled = siteCountersEnabled;
    RowsPerDayTextBox.Enabled = siteCountersEnabled;
    RowsPerDayList.Enabled = siteCountersEnabled;
    TogglePageCountersUI(siteCountersEnabled && pageCountersEnabled);
}

private void TogglePageCountersUI(bool enabled) {
    TrackAppNameCheckBox.Enabled = enabled;
    TrackPageUrlCheckBox.Enabled = enabled;
    CounterNameTextBox.Enabled = enabled;
    CounterGroupTextBox.Enabled = enabled;
}

// Confirmation's related handlers
void ConfirmOK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Label runat="server" id="ConfigureCounterTitle" text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="90%" cellspacing="0" cellpadding="0">
        <tr class="bodyTextNoPadding">
            <td>
                <asp:Literal runat="server" text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp; 
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:Literal runat="server" text="<%$ Resources:CountersTitle %>"/>
                        </td>
                    </tr>
                    <tr class="bodyText">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:CheckBox runat="server" id="ControlCountersEnabledCheckBox" AutoPostBack="true"
                                          OnCheckedChanged="ControlCountersEnabledCheckBox_OnCheckedChanged"
                                          Text="<%$ Resources:ControlCountersEnabledCheckBoxText %>"/><br/>
                            <asp:CheckBox runat="server" id="PageCountersEnabledCheckBox" AutoPostBack="true"
                                          OnCheckedChanged="PageCountersEnabledCheckBox_OnCheckedChanged"
                                          Text="<%$ Resources:PageCountersEnabledCheckBox %>"/><br/>
                        </td>
                    </tr>
                    <tr valign="top"><td><hr/></td></tr>
                    <tr class="bodyText">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:Label runat="server" AssociatedControlID="RowsPerDayTextBox" Text="<%$ Resources:RowsPerDayLabel %>"/><br/>
                            <asp:TextBox runat="server" id="RowsPerDayTextBox" width="155"/><br/>
                            <asp:ListBox runat=server id="RowsPerDayList" Rows="5" AutoPostBack="true" OnSelectedIndexChanged="RowsPerDayList_SelectedIndexChanged">
                                <asp:ListItem text="<%$ Resources:OneRowPerDayListItemText %>" value="1"/>
                                <asp:ListItem text="<%$ Resources:OneRowPerHourListItemText %>" value="24"/>
                                <asp:ListItem text="<%$ Resources:FourRowsPerHourListItemText %>" value="96"/>
                                <asp:ListItem text="<%$ Resources:OneRowEveryTenMinutesListItemText %>" value="144"/>
                                <asp:ListItem text="<%$ Resources:OneRowEveryFiveMinutesListItemText %>" value="288"/>
                                <asp:ListItem text="<%$ Resources:OneRowPerMinuteListItemText %>" value="1440"/>
                            </asp:ListBox>
                        </td>
                    </tr>
                    <tr><td><hr/></td></tr>
                    <tr class="bodyText">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:Literal runat="server" text="<%$ Resources:PageCountersInstructions %>"/><br/>
                            <asp:CheckBox runat="server" id="TrackAppNameCheckBox" Text="<%$ Resources:TrackAppNameCheckBoxText %>"/><br/>
                            <asp:CheckBox runat="server" id="TrackPageUrlCheckBox" Text="<%$ Resources:TrackPageUrlCheckBoxText %>"/><br/>

                            <%-- An invisible textbox at the end of the line is to submit the page on enter, raising server side onclick --%>
                            <asp:Label runat="server" AssociatedControlID="CounterNameTextBox" Text="<%$ Resources:CounterNameLabel %>"/>&nbsp;<asp:TextBox runat="server" id="CounterNameTextBox" width="155"/>&nbsp;<input type="text" style="visibility:hidden;width:0px;" /><br/>
                            <asp:Label runat="server" AssociatedControlID="CounterGroupTextBox" Text="<%$ Resources:CounterGroupLabel %>"/>&nbsp;<asp:TextBox runat="server" id="CounterGroupTextBox" width="155"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="bodyText">
                            <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"/>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="RowsPerDayTextBox"
                                                    ErrorMessage="<%$ Resources:RowsPerDayRequiredError %>" Display="none"/>
                            <asp:RangeValidator runat="server" ControlToValidate="RowsPerDayTextBox"
                                                Type="Integer" MinimumValue="1" MaximumValue="1440"
                                                ErrorMessage="<%$ Resources:RowsPerDayRangeError %>" Display="none"/>
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
    <asp:Literal runat="server" text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td>
                <asp:Literal runat="server" text="<%$ Resources:ConfirmationText %>"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="PagesToCount.aspx" Text="<%$ Resources:PagesToCountLinkText %>"/><br/>
    <asp:HyperLink runat="server" NavigateUrl="AppConfigHome.aspx" Text="<%$ Resources:AppConfigCommon,AppConfigHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="ConfirmOK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="75"/>
</asp:content>
