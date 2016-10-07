<%@ Control Inherits="System.Web.Administration.WebAdminUserControl" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register TagPrefix="user" TagName="confirmation" Src="confirmation.ascx"%>

<script runat="server" language="CS">
private RoleProvider _roleProvider;

private string ApplicationPath {
    get {
        return (string)Session["WebAdminApplicationPath"];
    }
}

public void AddRole(object s, EventArgs e) {
    // REVIEW: Perf -too many switches in impersonation?
    bool roleExists = ((WebAdminPage)Page).RoleHelperInstance.RoleExists(textBox1.Text);

    if (!textBox1.Text.Equals(string.Empty) && !roleExists){
        try {
            ((WebAdminPage)Page).RoleHelperInstance.CreateRole(textBox1.Text);
        }
        catch {
        }

        BindGrid();
    }
}

private void BindGrid() {
    string [] roles = ((WebAdminPage)Page).RoleHelperInstance.GetAllRoles();
    if (roles.Length > 0) {
        dataGrid.DataSource = roles;
        dataGrid.DataBind();
        dataGrid.Visible = true;
    }
    else {
        dataGrid.Visible = false;
    }
}

private void Cancel_Click(object s, EventArgs e) {
    mv0.ActiveViewIndex = 0;
    ((WizardPage)Page).EnableWizardButtons();
}

private void DeleteRole(object s, CommandEventArgs e) {
    mv0.ActiveViewIndex = 1;
    confirmation.DialogContent.Text = "<img src='../../Images/alert_lrg.gif'/>" + String.Format((string)GetPageResourceObject("AreYouSure"), e.CommandArgument); // "<img src='../../Images/alert_lrg.gif'/>Are you sure you want to delete the role <b>" + e.CommandArgument + "</b>?"; 
    Session["RoleName"] = e.CommandArgument;   
    ((WizardPage)Page).DisableWizardButtons();
}

private void OK_Click(object s, EventArgs e) {
    string roleName = (string)Session["RoleName"];
    if (((WebAdminPage)Page).RoleHelperInstance.RoleExists(roleName) ) {
        ((WebAdminPage)Page).RoleHelperInstance.DeleteRole(roleName, false);
    }

    BindGrid();
    mv0.ActiveViewIndex = 0;
    ((WizardPage)Page).EnableWizardButtons();
}

public void IndexChanged(object s, GridViewPageEventArgs e) {
    dataGrid.PageIndex = e.NewPageIndex;
    BindGrid();
}

private void EnableRolesChanged(object s, EventArgs e) {
    CheckBox cb = (CheckBox)s;
    Configuration config = ((WebAdminPage)Page).GetWebConfiguration(ApplicationPath);
    RoleManagerSection roleSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    roleSection.Enabled = cb.Checked;
    ((WebAdminPage)Page).UpdateConfig(config);
}

public override bool OnNext () {
    if (!enableRoleCB.Checked) {
        return true;
    }
    int index = mv1.ActiveViewIndex;
    if (index == 1) {
        return true;
    }
    mv1.ActiveViewIndex = 1;
    return false;
}

public override bool OnPrevious() {
    if (mv1.ActiveViewIndex > 0) {
        mv1.ActiveViewIndex = mv1.ActiveViewIndex - 1;
        return false;
    }
    mv1.ActiveViewIndex = 0;
    return true;

}

public void Page_Init() {
    confirmation.DialogTitle.Text = (string)GetPageResourceObject("DeleteRole");
    confirmation.LeftButton.Click += new EventHandler(OK_Click);
    confirmation.RightButton.Click += new EventHandler(Cancel_Click);
}

public void Page_Load() {
    bool enabled = ((WebAdminPage)Page).IsRoleManagerEnabled();
    if (!Page.IsPostBack) {
        enableRoleCB.Checked = enabled;
    }

    if (!enabled) {
        return;
    }

    // CONSIDER: Should not bind on each Load.
    int count = ((WebAdminPage)Page).RoleHelperInstance.GetAllRoles().Length;
    if (count > 0) {
        BindGrid();
    }
    else {
        dataGrid.Visible = false;
    }
}
</script>
<asp:multiview runat="server" id="mv0" activeviewindex="0">
<asp:view runat="server">
<asp:multiview runat="server" id="mv1" activeviewindex="0">
<asp:view runat="server">
<div class="bodyTextNoPadding" style="width:500">
    <asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
    <asp:checkbox runat="server" id="enableRoleCB" autopostback="true" oncheckedchanged="EnableRolesChanged"/>
    <asp:label runat="server" associatedcontrolid="enableRoleCB" text="<%$ Resources:EnableRolesCheck %>"/>
</div>
</asp:view>
<asp:view runat="server">
<span class="bodyTextNoPadding"><asp:literal runat="server" text="<%$ Resources:RolesEnabled %>"/></span><br/>
        <table cellspacing="0" width="400" cellpadding="5" rules="all" class="lrbBorders" border="0">
    <tr class="callOutStyle">
        <td><asp:literal runat="server" text="<%$ Resources:CreateNewRole %>"/></td>
    </tr>
    <tr >
        <td class="bodyTextNoPadding"><asp:literal runat="server" text="<%$ Resources:NewRoleName %>"/><br/>
            <asp:textbox runat="server" id="textBox1" maxlength="256" style="width:200" />
            &nbsp;
            <asp:button runat="server" id="button1" text="<%$ Resources:AddRole %>"  onclick="AddRole"/>
            <br/>
        </td>
    </tr>
</table>
<%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
<input type="text" style="visibility:hidden"/>
<br/>
<table cellspacing="0" cellpadding="0" class="lrbBorders" border="0">
    <tr>
        <td>
            <asp:gridview runat="server" id="dataGrid" width="400" border="0" allowsorting="true" cellpadding="5" gridlines="Horizontal" borderstyle="None" autogeneratecolumns="False" allowpaging="true" pagesize="7" onpageindexchanging="IndexChanged" UseAccessibleHeader="true">
            <rowstyle cssclass="gridRowStyle" />
            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>
            <selectedrowstyle cssclass="gridSelectedRowStyle"/>
            <columns>
            <asp:templatefield runat="server" headertext="<%$ Resources:ExistingRoles %>">
            <itemtemplate>
            <%# Container.DataItem %>
            </itemtemplate>
            </asp:templatefield>
            <asp:templatefield runat="server">
            <itemstyle horizontalalign="left"/>
            <itemtemplate>
            <asp:linkbutton runat="server" id="linkButton1" text="<%$ Resources:Delete %>" commandname="DeleteRole" commandargument='<%#Container.DataItem%>' oncommand='DeleteRole'/>
            </itemtemplate>
            </asp:templatefield>
            </columns>
            <pagerstyle horizontalalign="Left" forecolor="#000000" backcolor="#EEEEEE"/>
            <pagersettings mode="Numeric"/>
            </asp:gridview>
        </td>
    </tr>
</table>
</asp:view>

</asp:multiview>
</asp:view>
<asp:view runat="server">
    <user:confirmation runat="server" id="confirmation"/>
</asp:view>
</asp:multiview>


