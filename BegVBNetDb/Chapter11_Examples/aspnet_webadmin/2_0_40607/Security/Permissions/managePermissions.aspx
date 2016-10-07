<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" inherits="System.Web.Administration.SecurityPage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server" language="CS">
private const string SELECTED_RULE = "WebAdminSelectedRule";
private const string RULES = "WebAdminRules";
private const string PARENT_RULE_COUNT = "WebAdminParentRuleCount";

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

private void BindGrid() {
    string appPath = CurrentPath;
    string parentPath = GetParentPath(appPath);

    Configuration config = GetWebConfiguration(appPath, true);
    AuthorizationSection auth = (AuthorizationSection) config.GetSection("system.web/authorization");

    Configuration parentConfig = GetWebConfiguration(parentPath, true);
    AuthorizationSection parentAuth = (AuthorizationSection) parentConfig.GetSection("system.web/authorization");
    ParentRuleCount = parentAuth.Rules.Count;

    // UNDONE: Remove manual copy when Whidbey 24285 is resolved.
    // ArrayList arr = new ArrayList(auth.Rules);
    ArrayList arr = new ArrayList();
    foreach (AuthorizationRule entry in auth.Rules) {
        arr.Add(entry);
    }
    Session[RULES] = arr;
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
    RuleDescription.Text = builder.ToString();
    Master.SetDisplayUI(true);
    Session["ItemIndex"] = item.RowIndex;
}

private void Yes_Click(object s, EventArgs e) {    
    Rules.RemoveAt((int)Session["ItemIndex"]);
    UpdateRules();
    dataGrid.SelectedIndex = -1;
    BindGrid();
    Master.SetDisplayUI(false);
}


private void No_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}


private string GetDirectory(string path) {
    if (path == null) {
        return null; // Review: can this happen?
    }
    return path.Substring(path.LastIndexOf('/') + 1);
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


private string GetAction(object val) {
    AuthorizationRule rule = (AuthorizationRule)val;
    string ruleAction = "";
    if (rule.Action == AuthorizationRuleAction.Allow) {
        ruleAction = (string)GetPageResourceObject("Allow");
    } else if (rule.Action == AuthorizationRuleAction.Deny) {
        ruleAction = (string)GetPageResourceObject("Deny");
    }
    return ruleAction;
}


private string GetUsersAndRoles(object val) {
    return GetUsers(val) + GetRoles(val);
}

private void ItemDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
{
   if (e.Row.RowIndex >= Rules.Count - ParentRuleCount) {
       return;
   }
   DataControlRowType itemType = e.Row.RowType;
   if ((itemType == DataControlRowType.Pager) || 
       (itemType == DataControlRowType.Header) || 
       (itemType == DataControlRowType.Footer)) 
   {
      return;
   }
   foreach(Control c in e.Row.Cells[0].Controls) {
       LinkButton button = c as LinkButton;
       if (button == null) {
           continue;
       }
       e.Row.Attributes["onclick"] = 
          Page.GetPostBackClientHyperlink(button, "");
   }
}

private void MoveRuleDown(object s, EventArgs e) {
    ArrayList rules = Rules;
    int selectedRule = SelectedRule;
    // // Response.Write(selectedRule);

    if(selectedRule >= rules.Count - ParentRuleCount) {
        return;
    }

    AuthorizationRule rule = (AuthorizationRule)rules[selectedRule];
    rules.RemoveAt(selectedRule);
    rules.Insert(selectedRule + 1, rule);
    UpdateRules();
    BindGrid();
    dataGrid.SelectedIndex = selectedRule + 1;
    SecurityUtility.UpdateRowColors(this, dataGrid, dataGrid.Rows[selectedRule + 1], Session);
    SelectedRule = selectedRule + 1;
    UpdateUpDownButtons();
}

private void MoveRuleUp(object s, EventArgs e) {
    ArrayList rules = Rules;
    int selectedRule = SelectedRule;

    if(selectedRule == 0) {
        return;
    }

    AuthorizationRule rule = (AuthorizationRule)rules[selectedRule];
    rules.RemoveAt(selectedRule);
    rules.Insert(selectedRule - 1, rule);
    UpdateRules();
    BindGrid();
    dataGrid.SelectedIndex = selectedRule - 1;
    SecurityUtility.UpdateRowColors(this, dataGrid, dataGrid.Rows[selectedRule - 1], Session);
    SelectedRule = selectedRule - 1;
    UpdateUpDownButtons();
}

private void Page_Init() {
    if(!IsPostBack) {
        // Note: treenodes persist when added in Init, before loadViewState
        TreeNode n = new TreeNode(GetDirectory(ApplicationPath), ApplicationPath);
        tv.Nodes.Add(n);
        n.Selected = true;
        PopulateChildren(n);
        CurrentPath = ApplicationPath;
    }
}

private void Page_Load() {
    if (!IsPostBack) {
        BindGrid();
    }
}

protected void RedirectToCreatePermission(object s, EventArgs e) {
    CurrentPath = null;
    Response.Redirect("createPermission.aspx");
}

public void SelectClick(object s, EventArgs e) {
    LinkButton button = (LinkButton)s;
    GridViewRow row = (GridViewRow)button.Parent.Parent;
    SecurityUtility.UpdateRowColors(this, dataGrid, row, Session);
    SelectedRule = row.RowIndex;
    UpdateUpDownButtons();

    // string userName = button.Text;
    // SetCurrentUser(userName);
}

protected void TreeNodeExpanded(Object sender, TreeNodeEventArgs e) {
    foreach(TreeNode child in e.Node.ChildNodes) {
        PopulateChildren(child);
    }
}

protected void TreeNodeSelected(object sender, EventArgs e) {
    CurrentPath = ((TreeView)sender).SelectedNode.Value;
    dataGrid.SelectedIndex = -1;
    BindGrid();
}

private void UpdateRules() {
    Configuration config = GetWebConfiguration(CurrentPath, true);
    AuthorizationSection auth = (AuthorizationSection) config.GetSection("system.web/authorization");
    auth.Rules.Clear();
    ArrayList rules = Rules;
    foreach (AuthorizationRule rule in rules) {
        // // Response.Write("rule <br/>");
        auth.Rules.Add(rule);
    }

    // auth.IsModified = true;
    UpdateConfig(config);
}

private void UpdateUpDownButtons() {
    int index = SelectedRule;
    moveDown.Enabled = (index < Rules.Count - ParentRuleCount - 1);
    moveUp.Enabled = (index > 0); 

}
</script>


<asp:content runat="server" contentplaceholderid="buttons">
<asp:button runat="server" id="button1" text="<%$ Resources:Done %>" onclick="ReturnToPreviousPage"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:ManageAccessRules %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="content" >
<asp:literal runat="server" text="<%$ Resources:Instructions %>" />
<table width="100%">
    <tr>
        <td width="80%">
            <table cellspacing="0" width="100%" cellpadding="4" rules="none" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                <tr class="callOutStyle">
                    <td colspan="3"><asp:literal runat="server" text="<%$ Resources:ManageAccessRules %>"/></td>
                </tr>
                <tr>
                    <td valign="top">
                        <table cellspacing="0" cellpadding="4" rules="rows" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;width:100%;border-collapse:collapse;">
                            <tr>
                                <td valign="top">
                                    <asp:panel runat="server" id="panel1" scrollbars="both" height="150px" cssclass="bodyTextNoPadding">
                                        <asp:treeView runat="server" id="tv" onSelectedNodeChanged="TreeNodeSelected" onTreeNodeExpanded="TreeNodeExpanded" rootnodeimageurl="../../images/folder.gif" parentnodeimageurl="../../images/folder.gif" leafnodeimageurl="../../images/folder.gif" nodeStyle-cssClass="bodyTextLowPadding">
                                            <nodestyle cssClass="bodyTextLowPadding"/>
                                            <selectedNodeStyle cssClass="bodyTextLowPaddingSelected"/>
                                        </asp:treeView>
                                    </asp:panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <asp:gridview runat="server" id="dataGrid" bordercolor="#CCDDEF" allowsorting="true" gridlines="Horizontal"
                            borderstyle="None" cellpadding="4" autogeneratecolumns="False" onrowdatabound="ItemDataBound" width="100%" UseAccessibleHeader="true">

                            <rowstyle cssclass="gridRowStyle" />
                            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                            <summarytitlestyle borderstyle="None" borderwidth="1px" bordercolor="#3366CC" backcolor="White"/>
                            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>
                            <detailtitlestyle borderstyle="None" borderwidth="1px" bordercolor="#3366CC" backcolor="White"/>
                            <selectedrowstyle cssclass="gridSelectedRowStyle"/>
                            <pagerstyle horizontalalign="Left" forecolor="#000000" backcolor="#EEEEEE"/>
                            <pagersettings mode="Numeric"/>

                            <columns>
                                <asp:templatefield headertext="<%$ Resources:Select%>" visible="false">
                                    <itemtemplate>
                                        <asp:linkbutton runat="server" commandname="Select" forecolor='black' onclick="SelectClick" text=""/>
                                    </itemtemplate>
                                </asp:templatefield>

                                <asp:templatefield headertext="<%$ Resources:Permission %>">
                                    <itemtemplate>
                                        <asp:label runat="server" id="select" enabled="<%# ((GridViewRow) Container).RowIndex < Rules.Count - ParentRuleCount %>" text="<%#GetAction((AuthorizationRule)Container.DataItem)%>"/>
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
                        </asp:gridview>

                        <asp:linkButton runat="server" id="linkButton1" cssClass="bodyTextNoPadding" text="<%$ Resources:AddNewAccessRule %>" onClick="RedirectToCreatePermission"/>
                    </td>
                    <td valign="top">
                        <asp:button runat="server" id="moveUp" text="<%$ Resources:MoveUp %>" enabled="false" onClick="MoveRuleUp" width="110px"/>
                        <br/>
                        <asp:button runat="server" id="moveDown" text="<%$ Resources:MoveDown %>" enabled="false" onClick="MoveRuleDown" width="110px"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
<asp:literal runat="server" text="<%$ Resources:RuleManagement %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">

    <img src="../../Images/alert_lrg.gif"/>
    <asp:literal runat="server" text="<%$ Resources:AreYouSure %>" /> "<asp:Label runat=server id="RuleDescription" />"?
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="Yes_Click" Text="<%$ Resources:Yes %>" width="100"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="No_Click" Text="<%$ Resources:No %>" width="100"/>
</asp:content>

