<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ProfilePage" %>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private void DeleteButton_Click(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    DateTime deleteDate;
    try {
        deleteDate = DateTime.Parse(DeleteDateTextBox.Text, CultureInfo.CurrentCulture);
    }
    catch (Exception exception) {
        DateCheckCustomVal.IsValid = false;
        DateCheckCustomVal.ErrorMessage = exception.Message;
        return;
    }

    int numOfInactiveProfiles = ProfileHelper.GetNumberOfInactiveProfiles(ProfileAuthenticationOption.Anonymous, deleteDate);

    // Go to confirmation UI
    AgeToDelete.Text = String.Format((string)GetPageResourceObject("DateForDeletingRecordsText"), DeleteDateTextBox.Text);
    RecordsToDelete.Text = String.Format((string)GetPageResourceObject("NumOfDeletingRecordsText"),
                                         numOfInactiveProfiles.ToString(CultureInfo.CurrentCulture));
    Master.SetDisplayUI(true);
}

private void DeleteDateCalendar_SelectionChanged(object s, EventArgs e) {
    System.Web.UI.WebControls.Calendar calendar = (System.Web.UI.WebControls.Calendar) s;
    DeleteDateTextBox.Text = calendar.SelectedDate.ToShortDateString();
}

// Confirmation's related handlers
void DeleteOK_Click(object s, EventArgs e) {
    DateTime deleteDate = DateTime.Parse(DeleteDateTextBox.Text, CultureInfo.CurrentCulture);
    ProfileHelper.DeleteInactiveProfiles(ProfileAuthenticationOption.Anonymous, deleteDate);
    ReturnToPreviousPage(s, e);
}

void DeleteCancel_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}
</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="80%" cellspacing="0" cellpadding="0">
        <tr class="bodyTextNoPadding">
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/>
            </td>
        <tr>
            <td>
                <table height="100%" width="80%">
                    <tr>
                        <td>
                            <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                                   bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr class="callOutStyle">
                                    <td style="padding-left:10;padding-right:10;" colspan="3">
                                        <asp:Literal runat="server" Text="<%$ Resources:RemoveValuesHeader %>"/>
                                    </td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td style="padding-left:10;padding-right:10;" colspan="3">
                                        <asp:Label runat="server" AssociatedControlID="DeleteDateTextBox" Text="<%$ Resources:DeleteValuesLabel %>"/><br/>
                                        <asp:TextBox runat="server" id="DeleteDateTextBox" width="100"/>
                                        <asp:Calendar runat="server" id="DeleteDateCalendar" font-name="verdana" font-size="xsmall"
                                                      OnSelectionChanged="DeleteDateCalendar_SelectionChanged"/>
                                        <br/>
                                        <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"/>
                                        <asp:RequiredFieldValidator runat="server" EnableClientScript="false"
                                                                    ControlToValidate="DeleteDateTextBox"
                                                                    ErrorMessage="<%$ Resources:DateRequiredError %>" Display="none"/>
                                        <asp:CustomValidator runat="server" EnableClientScript="false"
                                                                    id="DateCheckCustomVal" Display="none"/>
                                    </td>
                                </tr>
                                <tr class="userDetailsWithFontSize" valign="top" height="5%">
                                    <td style="padding-left:10;padding-right:10;" align="right" width="1%">
                                        <asp:Button runat="server" Text="<%$ Resources:GlobalResources,DeleteButtonLabel %>" OnClick="DeleteButton_Click"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td/>
                    </tr>
                    <tr><td colspan="2"/></tr>
                </table>
            </td>
            <td width="100"/>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:GlobalResources,BackButtonLabel %>" id="BackButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
    <asp:Literal runat="server" Text="<%$ Resources:RemoveRecordsHeader %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td valign="top">
                <asp:Image runat="server" ImageUrl="~/Images/alert_lrg.gif"/>
            </td>
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:DeleteRecordsConfirmationText %>"/><br/>
                <br/>
                <asp:Literal runat="server" id="AgeToDelete"/><br/>
                <br/>
                <asp:Literal runat="server" id="RecordsToDelete"/>
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
