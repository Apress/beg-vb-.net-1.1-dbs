<%@ Page masterPageFile="~/WebAdminNoButtonRow.master" debug="true" inherits="System.Web.Administration.WebAdminPage"%>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server" language="cs">
protected override void OnInit(EventArgs e) {
    if (string.Compare(CurrentRequestUrl, Request.CurrentExecutionFilePath) != 0) {
          PushRequestUrl(Request.CurrentExecutionFilePath);
    }
}
</script>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:Error %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
<asp:literal runat="server" text="<%$ Resources: CannotStart %>"/>                
<code><pre>

&lt;!-- Machine.Config --&gt;

&lt;webSiteAdministrationTool
    ...
    requireSSL=&quot;true&quot;
&gt;
</pre></code>
</form>
</body>
</asp:content>
