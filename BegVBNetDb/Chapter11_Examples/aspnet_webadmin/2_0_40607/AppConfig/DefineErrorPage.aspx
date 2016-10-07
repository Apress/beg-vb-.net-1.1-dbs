<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

private static readonly Regex _fileFilter = new Regex("\\.aspx$", 
                                                        RegexOptions.Singleline | 
                                                        RegexOptions.IgnoreCase | 
                                                        RegexOptions.CultureInvariant |
                                                        RegexOptions.Compiled);

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private void ErrorPage_ServerValidate(object s, ServerValidateEventArgs e) {
    e.IsValid = (PagesTreeView.SelectedNode != null);
}

private string GetDirectory(string path) {
    if (path == null) {
        return null; // Review: can this happen?
    }
    return path.Substring(path.LastIndexOf('/') + 1);
}

private void Page_Init() {
    if(!IsPostBack) {
        // Note: treenodes persist when added in Init, before LoadViewState
        TreeNode n = new TreeNode(GetDirectory(ApplicationPath), ApplicationPath);
        n.SelectAction = TreeNodeSelectAction.None;
        PagesTreeView.Nodes.Add(n);
        PopulateDirectoriesAndFiles(n);
    }
}

private void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        if (appPath != null && !appPath.Equals(String.Empty)) {
            DefineErrorPageTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        Configuration config = GetWebConfiguration(appPath);
        CustomErrorsSection customErrorsSection = (CustomErrorsSection) config.GetSection("system.web/customErrors");

        string errorPageUrl = customErrorsSection.DefaultRedirect;
        if (errorPageUrl == null || errorPageUrl.Length == 0) {
            DefaultErrorRadioButton.Checked = true;
            ToggleSettingErrorPageElements(false);
        }
        else {
            ErrorPageRadioButton.Checked = true;

            if (errorPageUrl.StartsWith("~/")) {
                errorPageUrl = errorPageUrl.Substring(2);
            }
            else if (errorPageUrl.StartsWith(appPath + "/")) {
                errorPageUrl = errorPageUrl.Substring(appPath.Length + 1);
            }
            else if (errorPageUrl.StartsWith("/")){
                // Unexpected case, set warning message and return
                SetWarningText(errorPageUrl);
                return;
            }

            if (!PopulateSelectedErrorPage(errorPageUrl, PagesTreeView.Nodes[0])) {
                SetWarningText(customErrorsSection.DefaultRedirect);
            }
        }
    }
}

private void PopulateDirectoriesAndFiles(TreeNode parent) {
    VirtualDirectory vdir = GetVirtualDirectory(parent.Value);
    foreach (VirtualDirectory childVdir in vdir.Directories) {
        TreeNode newNode = new TreeNode(childVdir.Name, parent.Value + "/" + childVdir.Name);
        newNode.SelectAction = TreeNodeSelectAction.None;
        parent.ChildNodes.Add(newNode);
        PopulateDirectoriesAndFiles(newNode);
    }

    foreach (VirtualFile childVfile in vdir.Files) {
        if (_fileFilter.IsMatch(childVfile.Name)) {
            TreeNode newNode = new TreeNode(childVfile.Name, parent.Value + "/" + childVfile.Name, "../images/aspx_file.gif");
            newNode.SelectAction = TreeNodeSelectAction.Select;
            parent.ChildNodes.Add(newNode);
        }
    }
}

private bool PopulateSelectedErrorPage(string path, TreeNode node) {
    // Traverse the tree to locate the page node
    int slashPos = path.IndexOf('/');
    string targetNodeText;
    if (slashPos == -1) {
        targetNodeText = path;
    }
    else {
        targetNodeText = path.Substring(0, slashPos);
    }

    foreach (TreeNode childNode in node.ChildNodes) {
        if (childNode.Text == targetNodeText) {
            if (slashPos == -1) {
                // End case: path is completely matched
                childNode.Selected = true;

                // We walk back the path to expand the tree to show the node is selected
                TreeNode parent = childNode.Parent;
                while (parent != null) {
                    parent.Expanded = true;
                    parent = parent.Parent;
                }

                return true;
            }
            else {
                string nextPath = path.Substring(targetNodeText.Length + 1);
                return PopulateSelectedErrorPage(nextPath, childNode);
            }
        }
    }

    return false;
}

private void SaveButton_Click(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    Configuration config = GetWebConfiguration(ApplicationPath);
    CustomErrorsSection customErrorsSection = (CustomErrorsSection) config.GetSection("system.web/customErrors");

    // Replace the app name with ~
    customErrorsSection.DefaultRedirect = "~" + PagesTreeView.SelectedNode.Value.Substring(ApplicationPath.Length);

    // Clear the warning that might have been set
    WarningTable.Visible = false;

    UpdateConfig(config);

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

private void SetWarningText(string errorPageUrl) {
    WarningTable.Visible = true;
    WarningErrorPageUrlLabel.Text = errorPageUrl;
}

private void ToggleSettingErrorPageElements(bool enabled) {
    PagesPanel.Enabled = enabled;
    PagesTreeView.Enabled = enabled;
    SaveButton.Enabled = enabled;
}

private void WebControl_ValueChanged(object s, EventArgs e) {
    Configuration config;
    config = GetWebConfiguration(ApplicationPath);
    CustomErrorsSection customErrorsSection = (CustomErrorsSection) config.GetSection("system.web/customErrors");

    if (DefaultErrorRadioButton.Checked) {
        customErrorsSection.DefaultRedirect = string.Empty;

        // De-select the previous setting and collapse all nodes
        TreeNode selectedNode = PagesTreeView.SelectedNode;
        if (selectedNode != null) {
            selectedNode.Selected = false;
        }

        PagesTreeView.CollapseAll();
        WarningTable.Visible = false;
        ToggleSettingErrorPageElements(false);
    }
    else {
        ToggleSettingErrorPageElements(true);
    }
    UpdateConfig(config);
}

// Confirmation's related handlers
void ConfirmOK_Click(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Label runat="server" id="DefineErrorPageTitle" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <table height="100%" width="90%" cellspacing="0" cellpadding="0">
        <tr class="bodyTextNoPadding">
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="all"
                       border="0" style="border-style:None;border-collapse:collapse;">
                    <tr class="bodyText" valign="top">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:RadioButton runat="server" id="DefaultErrorRadioButton" groupName="ErrorSelection" AutoPostBack="true" OnCheckedChanged="WebControl_ValueChanged"/>
                        </td>
                        <td style="padding-right:10;">
                            <asp:Label runat="server" AssociatedControlID="DefaultErrorRadioButton" Text="<%$ Resources:DefaultErrorLabel %>" Font-Bold="true"/>
                        </td>
                    </tr>
                    <tr class="bodyText" valign="top">
                        <td style="padding-left:10;padding-right:10;">
                            <asp:RadioButton runat="server" id="ErrorPageRadioButton" groupName="ErrorSelection" AutoPostBack="true" OnCheckedChanged="WebControl_ValueChanged"/>
                        </td>
                        <td style="padding-right:10;">
                            <asp:Label runat="server" AssociatedControlID="ErrorPageRadioButton" Text="<%$ Resources:ErrorPageLabel %>" Font-Bold="true"/>
                        </td>
                    </tr>
                    <tr class="bodyText" valign="top">
                        <td/>
                        <td style="padding-right:10;">
                            <asp:Literal runat="server" Text="<%$ Resources:ErrorPageInstructions %>"/>
                        </td>
                    </tr>
                    <tr class="bodyText" valign="top">
                        <td/>
                        <td style="padding-right:10;">
                            <table runat="server" id="WarningTable" width="100%" valign="top" Visible="false">
                                <tr class="bodyText" valign="top">
                                    <td>
                                        <asp:Image runat="server" id="Alert" ImageUrl="~/images/alert_lrg.gif"/>
                                    </td>
                                    <td/>
                                    <td>
                                        <asp:Label runat=server id="WarningLabel" ForeColor="maroon" Text="<%$ Resources:ErrorPageWarningLabel %>"/>
                                        <asp:Label runat=server id="WarningErrorPageUrlLabel" ForeColor="maroon" Font-Bold="true"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>                    
                    <tr>
                        <td/>
                        <td>
                            <table cellspacing="0" height="100%" width="100%" cellpadding="0" rules="none"
                                   bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                                <tr class="callOutStyle">
                                    <td style="padding-top:4;padding-left:10;padding-right:10;padding-bottom:4;" colspan="2">
                                        <asp:Literal runat="server" Text="<%$ Resources:SelectCustomErrorPageTitle %>"/>
                                    </td>
                                </tr>
                                <tr class="bodyText" style="padding-top:0;">
                                    <td style="padding-left:0;padding-right:0;" colspan="2">
                                        <asp:panel id="PagesPanel" runat="server" scrollbars="both" height="200" cssclass="bodyTextNoPadding">
                                            <asp:treeView runat="server" id="PagesTreeView"
                                                          rootnodeimageurl="../images/folder.gif"
                                                          parentnodeimageurl="../images/folder.gif"
                                                          leafnodeimageurl="../images/folder.gif">
                                                <nodestyle cssClass="bodyTextLowPadding"/>
                                                <selectedNodeStyle cssClass="bodyTextLowPaddingSelected"/>
                                            </asp:treeView>
                                        </asp:panel>
                                    </td>
                                </tr>
                                <tr class="userDetailsWithFontSize" valign="top">
                                    <td>
                                        <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>" ValidationGroup="SetErrorPage"/>
                                        <asp:CustomValidator runat="server" EnableClientScript="false" Display="none"
                                                ValidationGroup="SetErrorPage" OnServerValidate="ErrorPage_ServerValidate"
                                                ErrorMessage="<%$ Resources:ErrorPageNotSetError %>"/>
                                    </td>
                                    <td style="padding-left:10;padding-right:10;" align="right">
                                        <asp:Button id="SaveButton" runat="server" Text="<%$ Resources:GlobalResources,SaveButtonLabel %>" OnClick="SaveButton_Click"
                                                    ValidationGroup="SetErrorPage" width="100"/>
                                    </td>
                                </tr>
                            </table>
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
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <table cellspacing="4" cellpadding="4">
        <tr class="bodyText">
            <td>
                <asp:Literal runat="server" Text="<%$ Resources:ConfirmationText %>"/>
            </td>
        </tr>
    </table>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftLink">
    <asp:HyperLink runat="server" NavigateUrl="AppConfigHome.aspx" Text="<%$ Resources:AppConfigCommon,AppConfigHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="ConfirmOK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="75"/>
</asp:content>
