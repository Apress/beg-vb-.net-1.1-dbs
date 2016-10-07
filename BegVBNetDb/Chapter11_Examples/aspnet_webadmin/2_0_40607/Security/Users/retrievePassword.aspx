<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" debug="true" inherits="System.Web.Administration.SecurityPage"%>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register TagPrefix="admin" Namespace="System.Web.Administration" Assembly="System.Web"%>
<script runat="server">

public void Page_Init() {
	//System.Web.Administration.WebAdminPasswordRecovery pwRec = null;
	pwRec.UserName = CurrentUser;

}
</script>

<asp:content runat="server" contentplaceholderid="buttons">
<asp:button text="Back" id="doneButton" onclick="ReturnToPreviousPage" runat="server"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="titleBar">
Edit User
</asp:content>

<asp:content runat="server" contentplaceholderid="content">

<div style="width:750">
<asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
<br/><br/>
    </div>
<br/>

<table cellspacing="0" cellpadding="5" class="lrbBorders">
    <tr>
        <td class="callOutStyle">Recover Password</td>
    </tr>
    <tr >
        <td>
            <admin:WebAdminPasswordRecovery 
            runat="server" 
            id="pwRec" 
            cssclass="bodyText"
            maildefinition-from="administrator" textlayout=textOnTop/>
        </td>
    </tr>
</table>
</asp:content>

