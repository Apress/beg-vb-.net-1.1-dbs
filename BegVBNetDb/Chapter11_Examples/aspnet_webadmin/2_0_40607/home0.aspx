<%@ Page masterPageFile="~/WebAdminNoButtonRow.master" debug="true" inherits="System.Web.Administration.WebAdminPage"%>
<%@ MasterType virtualPath="~/WebAdminNoButtonRow.master" %>

<script runat="server" language="cs">
protected override void OnInit(EventArgs e) {
    if (string.Compare(CurrentRequestUrl, Request.CurrentExecutionFilePath) != 0) {
          PushRequestUrl(Request.CurrentExecutionFilePath);
    }
    // Set the application path to a special character so that, if the user attempts to navigate away from this page,
    // we know to reload the access denied exception.
    Session["WebAdminApplicationPath"] = "#";
}
</script>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:ProblemWithApp %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
<asp:literal runat="server" text="<%$ Resources:ProblemWithAppMessage %>"/>
</asp:content>
