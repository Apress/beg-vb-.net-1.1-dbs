<%@ page masterPageFile="~/WebAdminWithConfirmation.master" language="cs" inherits="System.Web.Administration.ApplicationConfigurationPage"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

// Helper class for storing pagesToCount info
private class PathToCountInfo {
    internal readonly bool Add;
    internal readonly Regex PathRegEx;
    internal readonly string RegExPattern;

    internal PathToCountInfo(bool add, String path, string appPath) {
        Add = add;
        path = MakeVirtualPathAppAbsolute(appPath, path);
        RegExPattern = GetRegExTextFromPath(appPath, path);
        PathRegEx = new Regex(RegExPattern, 
                                RegexOptions.Singleline | 
                                RegexOptions.IgnoreCase | 
                                RegexOptions.CultureInvariant |
                                RegexOptions.Compiled);
    }

    private string GetRegExTextFromPath(string appPath, string path) {
        Debug.Assert((path != null && path.Length > 0));

        // Only * means a wildcard for all paths 
        if (path == "*") {
            return ".*";
        }

        string regExText = path.Replace(".", "\\.");
        regExText = regExText.Replace("*", "[^/]+");

        // resolve app relative character ~ if present
        regExText = MakeVirtualPathAppAbsolute(appPath, regExText);

        // If not start with a '/', it is a relative match
        // e.g. "foo.aspx" --> ".*/foo.aspx$"
        if (path[0] != '/') {
            return ".*/" + regExText + "$";
        }
        else {
            // Otherwise, it needs to match at the beginning as well.
            return "^" + regExText + "$";
        }
    }

    public static string MakeVirtualPathAppAbsolute(string appPath, string virtualPath) {
        const char appRelativeCharacter = '~';

        // If the path is exactly "~", just return the app root path
        if (virtualPath.Length == 1 && virtualPath[0] == appRelativeCharacter)
            return appPath;

        // If the virtual path starts with "~/" or "~\", replace with the app path
        // relative
        if (virtualPath.Length >=2 && virtualPath[0] == appRelativeCharacter &&
            (virtualPath[1] == '/' || virtualPath[1] == '\\')) {

            if (appPath != null && appPath.Length > 1)
                return appPath + "/" + virtualPath.Substring(2);
            else
                return "/" + virtualPath.Substring(2);
        }

        // Return it unchanged
        return virtualPath;
    }
}

private static readonly Regex _fileFilter = new Regex("\\.aspx$", 
                                                        RegexOptions.Singleline | 
                                                        RegexOptions.IgnoreCase | 
                                                        RegexOptions.CultureInvariant |
                                                        RegexOptions.Compiled);
private ArrayList _regExPathList;
private StringCollection _subDirPathList;
private bool _pagesTreeViewCheckChanged;

private WebAdminWithConfirmationMasterPage Master {
    get {
        return (WebAdminWithConfirmationMasterPage)base.Master;
    }
}

private ArrayList RegExPathList {
    get {
        if (_regExPathList == null) {
            InitPathLists();
            Debug.Assert(_regExPathList != null);
        }
        return _regExPathList;
    }
}

private StringCollection SubDirPathList {
    get {
        if (_subDirPathList == null) {
            InitPathLists();
            Debug.Assert(_subDirPathList != null);
        }
        return _subDirPathList;
    }
}

private void AddPagesToCount(PagesToCountCollection pagesToCount, TreeNode node, int appPathLength, bool isParentChecked) {
    bool isSubDir = (node.ChildNodes.Count != 0);
    bool isNodeChecked = node.Checked;

    if (isSubDir) {
        if (isNodeChecked) {
            AddPagesToCountSettings(pagesToCount, node, appPathLength);
        }

        foreach (TreeNode child in node.ChildNodes) {
            AddPagesToCount(pagesToCount, child, appPathLength, isNodeChecked);
        }
    }
    else {
        if (isParentChecked) {
            if (!isNodeChecked) {
                node.Checked = true;
            }
        }
        else if (isNodeChecked) {
            AddPagesToCountSettings(pagesToCount, node, appPathLength);
        }
    }
}

private void AddPagesToCountSettings(PagesToCountCollection pagesToCount, TreeNode node, int appPathLength) {
    string path = "~" + node.Value.Substring(appPathLength);
    if (node.ChildNodes.Count != 0) {
        path += "/*";
    }
    pagesToCount.Add(new PagesToCountSettings(path));
}

private void ClearPagesToCountConfig(PagesToCountCollection pagesToCount) {
    pagesToCount.Clear();

    // Finally emit a clear to override any settings from machine.config
    pagesToCount.EmitClear = true;
}

private bool CountPath(String path, ArrayList pathToCountList) {
    Regex regex;
    bool countPath = false;

    // Go through the constructed regular expressions to see if the
    // current path should be counted
    foreach (object item in pathToCountList) {
        PathToCountInfo pathInfo = (PathToCountInfo) item;
        regex = pathInfo.PathRegEx;

        if (regex.IsMatch(path)) {
            countPath = pathInfo.Add;
        }
    }
    return countPath;
}

private string GetVirtualDirectoryName(string path) {
    Debug.Assert(path != null && path.Length > 0 && path[0] == '/');
    return path.Substring(path.IndexOf('/') + 1);
}

private void InitPathLists() {
    Configuration config = GetWebConfiguration(ApplicationPath);
    SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
    PageCountersElement pageCounters = siteCountersSection.PageCounters;
    InitRegExList(pageCounters.PagesToCount, out _regExPathList, out _subDirPathList);

    // REVIEW: We might want to smartly cache the lists across requests
    // in the case that config hasn't been changed.
}

// Build matching path info retrieved from config into regular expressions
// stored in an array list
private void InitRegExList(PagesToCountCollection paths,
                           out ArrayList regExPathList,
                           out StringCollection subDirPathList) {
    Debug.Assert(paths != null, "'paths' should be a valid NameValueCollection!!");

    regExPathList = new ArrayList(paths.Count);
    subDirPathList = new StringCollection();
    string appPath = ApplicationPath;
    for (int i = 0; i < paths.Count; i++) {
        PagesToCountSettings pageSetting = paths[i];

        String path = pageSetting.Path;
        PagesToCountAction action = pageSetting.Action;

        Debug.Assert(path != null && path.Length > 0, "key in paths should be non-empty string!!");

        bool add = (action == PagesToCountAction.Include);
        regExPathList.Add(new PathToCountInfo(add, path, appPath));

        // If ending with /* or /*.aspx, add this to sub dir path list which
        // will be used to identified directories to be checked
        string subDirPath = path.ToLower(CultureInfo.InvariantCulture);
        if (subDirPath.EndsWith("/*") || subDirPath.EndsWith("/*.aspx")) {
            subDirPath = subDirPath.Substring(0, subDirPath.LastIndexOf("/"));
            subDirPath = PathToCountInfo.MakeVirtualPathAppAbsolute(appPath, subDirPath);
            subDirPathList.Add(subDirPath);
        }
    }
}

private void Page_Load() {
    if (!IsPostBack) {
        string appPath = ApplicationPath;
        if (appPath != null && !appPath.Equals(String.Empty)) {
            MainTitle.Text = String.Format((string)GetPageResourceObject("TitleForSite"), appPath);
        }

        TreeNode root = new TreeNode(GetVirtualDirectoryName(appPath), appPath);
        root.SelectAction = TreeNodeSelectAction.None;
        PagesTreeView.Nodes.Add(root);

        // Special case: there are no removes and a wild card means to count all
        // pages under the app
        bool checkAll = false;
        foreach (object o in RegExPathList) {
            PathToCountInfo pathInfo = (PathToCountInfo) o;
            if (!pathInfo.Add) {
                checkAll = false;
                break;
            }
            else if (pathInfo.RegExPattern == ".*"){
                checkAll = true;
            }
        }
        PopulateDirectoriesAndFiles(root, RegExPathList, checkAll);
    }
}

private void PagesTreeView_CheckChanged(object s, TreeNodeEventArgs e) {
    _pagesTreeViewCheckChanged = true;
}

private bool PopulateDirectoriesAndFiles(TreeNode parent,
                                         ArrayList pathToCountList,
                                         bool checkAll) {
    bool hasChildToShow = false;

    // Check to see if the current node should be checked
    if (checkAll || SubDirPathList.Contains(parent.Value)) {
        parent.Checked = true;
    }

    VirtualDirectory vdir = GetVirtualDirectory(parent.Value);
    foreach (VirtualDirectory childVdir in vdir.Directories) {
        TreeNode newNode = new TreeNode(childVdir.Name, parent.Value + "/" + childVdir.Name);
        newNode.SelectAction = TreeNodeSelectAction.None;

        if (PopulateDirectoriesAndFiles(newNode, pathToCountList, checkAll)) {
            // Only add a sub dir if it has some matched files to display
            parent.ChildNodes.Add(newNode);
            hasChildToShow = true;
        }
    }

    foreach (VirtualFile childVfile in vdir.Files) {
        if (_fileFilter.IsMatch(childVfile.Name)) {
            // Mark that we have at least one file to show
            hasChildToShow = true;

            TreeNode newNode = new TreeNode(childVfile.Name, parent.Value + "/" + childVfile.Name, "../images/aspx_file.gif");
            newNode.SelectAction = TreeNodeSelectAction.None;
            parent.ChildNodes.Add(newNode);

            if (checkAll || CountPath(childVfile.VirtualPath, pathToCountList)) {
                newNode.Checked = true;
            }
        }
    }

    return hasChildToShow;
}

private void SaveButton_Click(object s, EventArgs e) {
    if (_pagesTreeViewCheckChanged) {
        string appPath = ApplicationPath;
        Configuration config = GetWebConfiguration(appPath);
        SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
        PageCountersElement pageCounters = siteCountersSection.PageCounters;
        PagesToCountCollection pagesToCount = pageCounters.PagesToCount;

        TreeNode root = PagesTreeView.Nodes[0];
        ClearPagesToCountConfig(pagesToCount);
        AddPagesToCount(pagesToCount, root, appPath.Length, false);
        UpdateConfig(config);
    }

    // Go to confirmation UI
    Master.SetDisplayUI(true);
}

// Confirmation's related handlers
void ConfirmOK_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:label runat="server" id="MainTitle" text="<%$ Resources:Title %>"/>
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
                <table cellspacing="0" height="100%" width="100%" cellpadding="0" rules="none"
                       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-top:4;padding-left:10;padding-right:10;padding-bottom:4;">
                            <asp:Literal runat="server" text="<%$ Resources:Title %>"/>
                        </td>
                    </tr>
                    <tr class="bodyText" style="padding-top:0;">
                        <td style="padding-left:0;padding-right:0;">
                            <asp:panel runat="server" scrollbars="both" height="200" cssclass="bodyTextNoPadding">
                                <asp:treeView runat="server" id="PagesTreeView"
                                              rootnodeimageurl="../images/folder.gif"
                                              parentnodeimageurl="../images/folder.gif"
                                              leafnodeimageurl="../images/folder.gif"
                                              ShowCheckBoxes="All"
                                              OnCheckChanged="PagesTreeView_CheckChanged">
                                    <nodestyle cssClass="bodyTextLowPadding"/>
                                    <selectedNodeStyle cssClass="bodyTextLowPaddingSelected"/>
                                </asp:treeView>
                            </asp:panel>
                        </td>
                    </tr>
                    <tr class="userDetailsWithFontSize" valign="top">
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
    <asp:HyperLink runat="server" NavigateUrl="AppConfigHome.aspx" Text="<%$ Resources:AppConfigCommon,AppConfigHomeLinkText %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="ConfirmOK_Click" Text="<%$ Resources:GlobalResources,OKButtonLabel %>" width="75"/>
</asp:content>
