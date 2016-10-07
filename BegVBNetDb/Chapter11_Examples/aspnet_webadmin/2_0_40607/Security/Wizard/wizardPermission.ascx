<%@ Control Inherits="System.Web.Administration.WebAdminUserControl"%>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Register TagPrefix="user" TagName="confirmation" Src="confirmation.ascx"%>

<script runat="server" language="CS">

private const string SELECTED_RULE = "WebAdminSelectedRule";
private const string RULES = "WebAdminRules";
private const string PARENT_RULE_COUNT = "WebAdminParentRuleCount";
private const string APP_PATH = "WebAdminApplicationPath";
private const string CURRENT_PATH = "WebAdminCurrentPath";


private string CurrentPath {
    get {
        return (string)Session[CURRENT_PATH];
    }
    set {
        Session[CURRENT_PATH] = value;
    }
}

private int ParentRuleCount {
    get {
        object obj = Session[PARENT_RULE_COUNT];
        return obj != null ? (int) obj : -1;
    }
    set {
        Session[PARENT_RULE_COUNT] = value;
    }
}

private ArrayList Rules {
    get {
        return (ArrayList)Session[RULES];
    }
    set {
        Session[RULES] = value;
    }
}

private int SelectedRule {
    get {
        object obj = Session[SELECTED_RULE];
        return obj != null ? (int) obj : -1;
    }
    set {
        Session[SELECTED_RULE] = value;
    }
}

protected void AddRule(object s, EventArgs e) {
    if(!((WebAdminPage)Page).IsRuleValid(placeholderValidator, userRadio, userName, roleRadio, roles)) {
        return;
    }
    SecurityUtility.AddPermissionRule(((WebAdminPage)Page), CurrentPath, userName, roles, userRadio, roleRadio, allUsersRadio, anonymousUsersRadio, grantRadio, denyRadio);
    BindGrid();
}

private void BindGrid() {
    string curPath = CurrentPath;
    string parentPath = WebAdminPage.GetParentPath(curPath);
    
    Configuration config = ((WebAdminPage)Page).GetWebConfiguration(curPath);
    AuthorizationSection auth = (AuthorizationSection) config.GetSection("system.web/authorization");

    Configuration parentConfig = ((WebAdminPage)Page).GetWebConfiguration(parentPath);
    AuthorizationSection parentAuth = (AuthorizationSection) parentConfig.GetSection("system.web/authorization");
    ParentRuleCount = parentAuth.Rules.Count;

    ArrayList arr = new ArrayList();
    foreach (AuthorizationRule entry in auth.Rules) {
        arr.Add(entry);
    }
    Rules = arr;
    dataGrid.DataSource = arr;
    dataGrid.DataBind();
    if (dataGrid.SelectedRow != null) {
        SecurityUtility.UpdateRowColors(this, dataGrid, dataGrid.Rows[dataGrid.SelectedRow.RowIndex], Session); 
    }
}

private void DeleteRule(object s, EventArgs e) {
    LinkButton button = (LinkButton) s;
    GridViewRow item = (GridViewRow) button.Parent.Parent;
    AuthorizationRule rule = (AuthorizationRule)Rules[item.RowIndex];
    StringBuilder builder = new StringBuilder();
    builder.Append(rule.Action);
    foreach (string u in rule.Users) {
        builder.Append(" " + u);
    }
    foreach (string r in rule.Roles) {
       builder.Append(" " + r);
    }
    confirmation.DialogContent.Text = String.Format((string)GetPageResourceObject("AreYouSure"), builder.ToString());
    mv1.ActiveViewIndex = 1;
    Session["ItemIndex"] = item.RowIndex;
    ((WizardPage)Page).DisableWizardButtons();
}

public void OK_Click(object s, EventArgs e) {
    Rules.RemoveAt((int)Session["ItemIndex"]);
    UpdateRules();
    BindGrid();
    mv1.ActiveViewIndex = 0;
    ((WizardPage)Page).EnableWizardButtons();
}

public void Cancel_Click(object s, EventArgs e) {
    mv1.ActiveViewIndex = 0;
    ((WizardPage)Page).EnableWizardButtons();
}

private string GetRoles(object val) {
    StringBuilder builder = new StringBuilder();
    AuthorizationRule rule = (AuthorizationRule)val;
    if (rule.Roles.Count == 0) {
        return String.Empty;
    }
    builder.Append("<img src=\"../../Images/image2.gif\" alt=\"\"/> ");
    for(int i = 0; i < rule.Roles.Count; i++) {
        if (i > 0) {
            builder.Append(", ");
        }
        string role = rule.Roles[i];
        if (role == "*") {
            role = (string)GetPageResourceObject("BracketAll");
        }
        builder.Append(role);

    }
    return builder.ToString(); // UNDONE: Shorten if too long.
}


private string GetUsers(object val) {
    StringBuilder builder = new StringBuilder();
    AuthorizationRule rule = (AuthorizationRule)val;
    if (rule.Users.Count == 0) {
        return String.Empty;
    }
    builder.Append("<img src=\"../../Images/image1.gif\" alt=\"\"/> ");
    for(int i = 0; i < rule.Users.Count; i++) {
        if (i > 0) {
            builder.Append(", ");
        }
        string user = rule.Users[i];
        if (user == "?") {
            user = (string)GetPageResourceObject("BracketAnonymous");
        }
        else if (user == "*") {
            user = (string)GetPageResourceObject("BracketAll");
        }
        builder.Append(user);
    }
    return builder.ToString(); // UNDONE: Shorten if too long.
}

private string GetUsersAndRoles(object val) {
    return GetUsers(val) + GetRoles(val);
}


private string GetVirtualPath(string path) {
    if (path == null) {
        return null; // REVIEW: Should not happen.
    }
    return path.Substring("IIS://localhost/W3SVC/1/ROOT".Length);
}

private string GetDirectory(string path) {
    if (path == null) {
        return null; // Review: can this happen?
    }
    return path.Substring(path.LastIndexOf('/') + 1);
}

protected override void OnInit(EventArgs e) {
    if(!IsPostBack) {
        
        // Review: Why do treenodes persist when added in Init, before loadViewState?
        // UNDONE: Use management api classes, rather than directory services.
        string appPath = (string)Session[APP_PATH];
        TreeNode n = new TreeNode(GetDirectory(appPath), appPath);
        tv.Nodes.Add(n);
        n.Selected = true;
        PopulateChildren(n);
        CurrentPath = appPath;
    }

    if (!((WebAdminPage)Page).IsRoleManagerEnabled()) {
        ListItem item = new ListItem("[roles disabled]");
        roles.Items.Add(item);
        roles.Enabled = false;
        roleRadio.Enabled = false;
        roleRadio.Checked = false;
        userRadio.Checked = true;
        return;
    }

    roles.DataSource = ((WebAdminPage)Page).RoleHelperInstance.GetAllRoles();
    roles.DataBind();
    BindGrid();
    if (roles.Items.Count == 0) {
        ListItem item = new ListItem((string)GetPageResourceObject("NoRoles"));
        roles.Items.Add(item);
        roles.Enabled = false;
        roleRadio.Enabled = false;
        roleRadio.Checked = false;
        userRadio.Checked = true;
    }
    base.OnInit(e);
}

public void Page_Init() {
    confirmation.DialogTitle.Text = (string)GetPageResourceObject("DeleteRule"); 
    confirmation.LeftButton.Click += new EventHandler(OK_Click);
    confirmation.RightButton.Click += new EventHandler(Cancel_Click);
    Hashtable coll = ((WebAdminPage)Page).UserCollection;
    if (coll != null && coll.Count > 0) {
        bool first = true;
        StringBuilder builder = new StringBuilder();
        foreach(string s in coll.Keys) {
            if (!first) {
                builder.Append(",");
            }
            else {
                first = false;
            }
            builder.Append(s);
        }
        userName.Text = builder.ToString();        
        ((WebAdminPage)Page).ClearUserCollection();
    }
    
}

protected void PopulateChildren(TreeNode parent) {
    ((WebAdminPage)Page).PopulateChildren(parent);
}

private void SearchForUsers(object s, EventArgs e) {
     ((WizardPage)Page).SaveActiveView();
     Server.Transfer("../users/findusers.aspx");
}

protected void TreeNodeExpanded(Object sender, TreeNodeEventArgs e) {
    foreach(TreeNode child in e.Node.ChildNodes) {
        PopulateChildren(child);
    }
}

protected void TreeNodeSelected(object sender, EventArgs e) {
    CurrentPath = ((TreeView)sender).SelectedNode.Value;
    BindGrid();
}

private void UpdateRules() {
    ArrayList rules = Rules;
    Configuration config = ((WebAdminPage)Page).GetWebConfiguration(CurrentPath);
    AuthorizationSection auth = (AuthorizationSection) config.GetSection("system.web/authorization");
    auth.Rules.Clear();
    foreach (AuthorizationRule rule in rules) {
        auth.Rules.Add(rule);
    }

    ((WebAdminPage)Page).UpdateConfig(config);
}

</script>
<asp:multiview runat="server" id="mv1" activeViewIndex="0">
    <asp:view runat="server">
        <table width=550 class="bodyTextNoPadding" cellpadding="0" cellspacing="0" border="0"><tr><td>
           <asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
         </td></tr></table>
        <br/>
            <table cellspacing="0" width="550" cellpadding="5" class="lrbBorders">
                <tr class="callOutStyle">
                    <td colspan="2"><asp:literal runat="server" text="<%$ Resources:AddNewAccessRule %>"/></td>
                </tr>
                <tr>
                    <td class="bodyTextNoPadding" width="36%" valign="top"><b><asp:literal runat="server" text="<%$ Resources:SelectDirForRule %>"/></b>
                        <table height="90%" cellspacing="0" cellpadding="4" rules="rows" bordercolor="#CCDDEF" border="0" style="border-color:#CCDDEF;border-style:None;width:100%;border-collapse:collapse;">
                            <tr>
                                <td>
                                    <asp:panel runat="server" id="panel1" scrollbars="both" height="150px" cssclass="bodyTextNoPadding">
                                    <asp:treeview runat="server" id="tv" onTreeNodeExpanded="TreeNodeExpanded" onSelectedNodeChanged="TreeNodeSelected" rootNodeImageUrl="../../images/folder.gif" parentnodeimageurl="../../images/folder.gif" leafnodeimageurl="../../images/folder.gif">
                                    <nodestyle cssclass="bodyTextLowPadding"/>
                                    <selectednodestyle cssclass="bodyTextLowPaddingSelected"/>
                                    </asp:treeview>
        
                                    </asp:panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td height="100%" valign="top">
                        <table height="90%"  border="0" cellpadding="6" cellspacing="0" class="bodyTextNoPadding" height="100%" width="100%" align="middle">
                            <tr>
                                <td width="50%" valign="top" ><b><asp:literal runat="server" text="<%$ Resources:RuleAppliesTo %>"/></b></td>
                                <td valign="top"><b><asp:literal runat="server" text="<%$ Resources:Permission %>"/>:</b></td>
                            </tr>
                            <tr>
                                <td width="62%" valign="top" bgcolor="#EEEEEE">
                                    <asp:radiobutton runat="server" id="roleRadio" checked="true" enableviewstate="false" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="roleRadio"><asp:literal runat="server" text="<%$ Resources:Role %>"/></asp:label>
                                    <asp:dropdownlist runat="server" id="roles" enableviewstate="false" style="position:relative; top:2"/>
                                    </td>
                                <td valign="top" >
                                    <asp:radiobutton runat="server" id="grantRadio" groupname="grantDeny" />
                                           <asp:label runat="server" associatedcontrolid="grantRadio"><asp:literal runat="server" text="<%$ Resources:Allow %>"/></asp:label></td>
                            </tr>
                            <tr>
                                <td width="62%" valign="top" bgcolor="#EEEEEE">
                                    <asp:radiobutton runat="server" id="userRadio" enableviewstate="false" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="userRadio"><asp:literal runat="server" text="<%$ Resources:User %>"/></asp:label>
                                    <asp:textbox runat="server" id="userName" style="position:relative; left:10" size="12"/>
                                    </td>
                                <td valign="top">
                                    <%--<input type="radio" checked="checked" name="R1" onclick="javascript:nyiAlert()">--%>
                                    <asp:radioButton runat="server" id="denyRadio" checked="true" groupName="grantDeny"/>
                                    <asp:label runat="server" associatedcontrolid="denyRadio"><asp:literal runat="server" text="<%$ Resources:Deny %>"/></asp:label></td>
                            </tr>
                            <tr>
                                <td width="62%" valign="top" bgcolor="#EEEEEE">
                                    <asp:radiobutton runat="server" id="allUsersRadio" groupname="rolesUsers" />
                                    <asp:label runat="server" associatedcontrolid="allUsersRadio"><asp:literal runat="server" text="<%$ Resources:AllUsers %>"/></asp:label></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="62%" valign="top" bgcolor="#EEEEEE">
                                    <asp:radiobutton runat="server" id="anonymousUsersRadio" groupname="rolesUsers" />                                     
                                    <asp:label runat="server" associatedcontrolid="anonymousUsersRadio"><asp:literal runat="server" text="<%$ Resources:AnonymousUsers %>"/></asp:label></td>
                                <td valign="bottom"><asp:button runat=server id="add" onClick="AddRule" text="<%$ Resources:AddThisRule %>"/></td>
                            </tr>
                            <tr><td><asp:linkbutton runat="server" onclick="SearchForUsers" text="<%$ Resources:SearchForUsers %>"/></td></tr>
                        </table>
                    </td>
                </tr>
                
            </table>
            <asp:customvalidator runat="server" id="placeholderValidator" enableclientscript="false" errormessage="<%$ Resources:InvalidInput %>" display="dynamic"/>
        <br/>
        <span class="bodyTextNoPadding"><asp:literal runat="server" text="<%$ Resources:DimmedRules %>"/>
        </span>                
        <br/><br/>
        
                    <asp:gridview runat="server" id="dataGrid" class="lrbBorders" width="550" allowsorting="true" gridlines="Horizontal" borderstyle="None" cellpadding="5" autogeneratecolumns="False" UseAccessibleHeader="true">
                    
                    <rowstyle cssclass="gridRowStyle" />
                    <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                    <summarytitlestyle borderstyle="None" borderwidth="1px" bordercolor="#3366CC" backcolor="White"/>
                    <headerstyle cssclass="callOutStyle" font-bold=true HorizontalAlign="Left"/>
                    <detailtitlestyle borderstyle="None" borderwidth="1px" bordercolor="#3366CC" backcolor="White"/>
                    <selectedrowstyle cssclass="gridSelectedRowStyle"/>
        
                    <columns>

                    <asp:templatefield headertext="<%$ Resources:Permission %>">
                    <itemtemplate>
                    <asp:label runat="server" forecolor="<%# ((GridViewRow) Container).RowIndex < Rules.Count - ParentRuleCount ? Color.Black : Color.Gray %>" text="<%#((AuthorizationRule)Container.DataItem).Action%>"/>
                    </itemtemplate>
                    </asp:templatefield>
        
                    <asp:templatefield headertext="<%$ Resources:UsersAndRoles %>">
                    <itemtemplate>
                    <asp:label runat="server" enabled="<%# ((GridViewRow) Container).RowIndex < Rules.Count - ParentRuleCount %>" forecolor="black" text="<%#GetUsersAndRoles((AuthorizationRule)Container.DataItem)%>"/>
                    </itemtemplate>
                    </asp:templatefield>

                    <asp:templatefield headertext="<%$ Resources:Delete %>">
                    <itemtemplate>
                    <asp:linkbutton runat="server" id="delete" enabled="<%# ((GridViewRow) Container).RowIndex < Rules.Count - ParentRuleCount %>" forecolor='black' onClick="DeleteRule" text="<%$ Resources:Delete %>"/>
                    </itemtemplate>
                    </asp:templatefield>
        
                    </columns>
                    <pagerstyle horizontalalign="Left" forecolor="#000000" backcolor="#EEEEEE"/>
                    <pagersettings mode="Numeric"/>
                    </asp:gridview>
                    <asp:panel id=instructions/>
                    </asp:panel>
        <br/>
    </asp:view>
    <asp:view runat="server">
       <user:confirmation runat="server" id="confirmation"/>
    </asp:view>
</asp:multiview>
