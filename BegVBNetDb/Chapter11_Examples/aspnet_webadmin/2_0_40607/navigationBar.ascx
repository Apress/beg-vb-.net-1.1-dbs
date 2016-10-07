<%@ Control Inherits="System.Web.Administration.NavigationBar" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register TagPrefix="admin" Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server" language="CS">

int _selectedIndex = 0;

private string GetFullUrlFromConfigSetting(string configUrl) {
    if (IsRelativeUrl(configUrl)) {
        return Request.ApplicationPath + "/" + configUrl;
    }
    return configUrl;
}

private string GetCenterClass(int index) {
    if (index == _selectedIndex)
        return "selTabCenter";
    else 
        return "deSTabCenter";
}

private string GetLeftClass(int index) {
    if (index == _selectedIndex)
        return "selTabLeft";
    else 
        return "deSTabLeft";
}

private string GetLeftImage(int index) {
    if (index == _selectedIndex)
        return GetNormalizedUrl("images/selectedTab_leftCorner.gif");
    else 
        return GetNormalizedUrl("images/unSelectedTab_leftCorner.gif");
}

private string GetRightClass(int index) {
    if (index == _selectedIndex)
        return "selTabRight";
    else 
        return "deSTabRight";
}

private string GetRightImage(int index) {
    if (index == _selectedIndex)
        return GetNormalizedUrl("images/selectedTab_rightCorner.gif");
    else 
        return GetNormalizedUrl("images/unSelectedTab_rightCorner.gif");
}

private string GetNormalizedUrl(string page) {
    return Request.ApplicationPath + "/" + page;
}

private bool IsRooted(string path) {
    return(path == null || path.Length == 0 || path[0] == '/' || path[0] == '\\');
}

private bool IsRelativeUrl(string url) {
    // If it has a protocol, it's not relative
    if (url.IndexOf(":") != -1)
    {
        return false;
    }
    return !IsRooted(url);
}


void Page_Load() {
    if(!Page.IsPostBack) {
        WebSiteAdministrationToolSection config =
                (WebSiteAdministrationToolSection)Context.GetConfig("system.web/webSiteAdministrationTool");
        imageRepeater.DataSource = config.CategorySettings;
        DataBind();
    }
}

public override void SetSelectedIndex(int index) {
    _selectedIndex = index;
}

private string MouseOver(int index) {
    if (index == _selectedIndex) {
        return String.Empty;
    }
    return "this.className='hoverTabCenter';" + 
        "document.getElementById('left" + index + "').className='hoverTabLeft';" +
        "document.getElementById('right" + index + "').className='hoverTabRight';";
}

private string MouseOut(int index) {
    if (index == _selectedIndex) {
        return String.Empty;
    }
    return "this.className='deSTabCenter';" + 
        "document.getElementById('left" + index + "').className='deSTabLeft';" +
        "document.getElementById('right" + index + "').className='deSTabRight';";
}
</script>
<script language="javascript">
<!--
function __keyPress(event, href) {
    var keyCode;
    if (typeof(event.keyCode) != "undefined") {
        keyCode = event.keyCode;
    }
    else {
        keyCode = event.which;
    }

    if (keyCode == 13) {
        window.location = href;
    }
}
//-->
</script>

            <!-- Top Branding/Navigation Table Region -->
            <table width="100%" height="64" cellspacing="0" cellpadding="0" class="homePageHeader" border="0">
                <tr>
                    <td valign="bottom" nowrap="nowrap"  height="31"><img src="<%#GetNormalizedUrl("images/branding_Full2.gif")%>" width="116" height="30" alt="" border="0">
                        <span class="webToolBrand">
                        <asp:literal runat="server" text="<%$ Resources: WebSiteAdminTool %>"/>
                        </span>
                    </td>
                    <td align="right" valign="top" nowrap height="31" >
                        <asp:HyperLink runat="server" cssclass="helpHyperLink" NavigateUrl="~/WebAdminHelp.aspx"
                                       tabindex="5" text="<%$ Resources: HowDoIUse %>"
                        />&nbsp; <img src="<%#GetNormalizedUrl("images/HelpIcon_solid.gif")%>" width="24" height="24" alt="" border="0" style="position:relative; top: 7">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" valign="bottom" nowrap height="33">
                        <%-- Table for the Tab Navigation Model --%>
                        <table id="TabTable" width="100%" cellspacing="0" cellpadding="0" border="0" onselectstart="event.returnValue=false;">
                            <tr>
                                <td  width="4" height="20"  nowrap class="spacerTab">&nbsp;</td>
                                <asp:repeater runat="server" id="imageRepeater">
                                <itemtemplate>

                                <td id='<%# "left" + Container.ItemIndex %>' width="4" height="20" valign="top" nowrap class="<%#GetLeftClass(Container.ItemIndex)%>">
                                <img id='<%# "leftImage" + Container.ItemIndex %>' src="<%#GetLeftImage(Container.ItemIndex)%>" width="4" height="3" alt="" border="0"></td>

                                <td width="81em" height="20" align="center" valign="top" nowrap class="<%#GetCenterClass(Container.ItemIndex)%>" tabindex="0"
                                onclick='window.location = "<%#GetNormalizedUrl((string)DataBinder.Eval(Container.DataItem, "NavigateUrl"))%>"'
                                onmouseover="<%#MouseOver(Container.ItemIndex)%>"  onmouseout="<%#MouseOut(Container.ItemIndex)%>" 
                                 onkeypress="<%# "__keyPress(event, '" + GetNormalizedUrl((string)DataBinder.Eval(Container.DataItem, "NavigateUrl")) + "');" %>">                                 
                                        <%# DataBinder.Eval(Container.DataItem, "Title") %>
                                </td>
                                <td id='<%# "right" + Container.ItemIndex %>' width="4" height="20"  align="right" valign="top" nowrap class="<%#GetRightClass(Container.ItemIndex)%>">

                                <img src="<%#GetRightImage(Container.ItemIndex)%>" width="4" height="3" alt="" border="0"></td>
                                <td  width="4" height="20"  nowrap class="spacerTab">
                                &nbsp;
                                </td>
                                </itemtemplate>
                                </asp:repeater>
                                <td  width="" height="20"  nowrap class="spacerTab">&nbsp;</td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>




