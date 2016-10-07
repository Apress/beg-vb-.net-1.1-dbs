<%@ Page masterPageFile="~/WebAdminButtonRow.master" inherits="System.Web.Administration.SecurityPage"%>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server" language="CS">

private const string DATA_SOURCE = "WebAdminDataSource";

public void SetDataSource(object v) {
    Session[DATA_SOURCE] = v;
}

public void BindGrid() {
    dataGrid.DataSource = Session[DATA_SOURCE];
    dataGrid.DataBind();
}

public void IndexChanged(object s, GridViewPageEventArgs e) {
    dataGrid.PageIndex = e.NewPageIndex;
    BindGrid();
}

public void EnabledChanged(object s, EventArgs e) {
    CheckBox checkBox = (CheckBox) s;
    GridViewRow gvr = (GridViewRow)checkBox.Parent.Parent;
    Label label = (Label) gvr.FindControl("userNameLink");
    string userName = label.Text;
    string currentRoleName = CurrentRole;
    string[] users = new string[1], roles = new string[1];
    users[0] = userName;
    roles[0] = currentRoleName;
    if (checkBox.Checked) {
        if (!RoleHelperInstance.IsUserInRole(userName, currentRoleName)) {
            RoleHelperInstance.AddUsersToRoles(users, roles);
        }
    }
    else {
        if (RoleHelperInstance.IsUserInRole(userName, currentRoleName)) {
            RoleHelperInstance.RemoveUsersFromRoles(users, roles);
        }
    }
}

public void Page_Load() {
    if(!IsPostBack) {
        PopulateRepeaterDataSource();
        repeater.DataBind();
        string currentRoleName = CurrentRole;
        roleName.Text = currentRoleName;

        string[] muc = RoleHelperInstance.GetUsersInRole(currentRoleName);
        WebAdminMembershipUserHelperCollection Coll = new WebAdminMembershipUserHelperCollection();
        // no Role method for returning a MembershipUserCollection.
        WebAdminMembershipUserHelper OneUser = null;
        foreach (string username in muc) {
            try {
                OneUser = MembershipHelperInstance.GetUser(username, false /* isOnline */);
            }
            catch (Exception e) {
                // eat it
            }
            if (OneUser != null) {
                Coll.Add(OneUser);
            }
        }
        SetDataSource(Coll);
        BindGrid();
    }

}

private void PopulateRepeaterDataSource() {
    ArrayList arr = new ArrayList();
    String chars = (string)GetPageResourceObject("Alphabet");
    foreach (String s in chars.Split(';')) {
        arr.Add(s);
    }
    arr.Add((string)GetPageResourceObject("All"));
    repeater.DataSource = arr;
}

protected override void OnPreRender(EventArgs e) {
    base.OnPreRender(e);
    if (dataGrid.Rows.Count == 0) {
        containerTable.Visible = false;
    }
    else {
        containerTable.Visible = true;
    }
}

public void RedirectToAddUser(object s, EventArgs e) {
    Response.Redirect("adduser.aspx");
}

public void RetrieveLetter(object s, RepeaterCommandEventArgs e) {
    RetrieveLetter(s, e, dataGrid, (string)GetPageResourceObject("All"));
    SetDataSource(dataGrid.DataSource);
    BindGrid();
}

public void SearchForUsers(object s, EventArgs e) {
    if (textBox1.Text == null || textBox1.Text.Length == 0) {
        return;
    }
    SearchForUsers(s, e, repeater, dataGrid, dropDown1, textBox1);
    SetDataSource(dataGrid.DataSource);
    BindGrid();
    //multiView1.ActiveViewIndex = 0;
}

</script>


<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:ManageRoleMembership %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
<asp:button  runat="server" id="button1" text="<%$ Resources:Back %>" onclick="ReturnToPreviousPage"/>
</asp:content>


<asp:content runat="server" contentplaceholderid="content">
<%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
<input type="text" style="visibility:hidden"/>
<table width="100%">
    <tbody>
    <tr>
        <td>
            <span class="bodyTextNoPadding">
            <asp:literal runat="server" text="<%$ Resources:Instructions %>" />
            <br/>
            <br/>
            <asp:literal runat="server" text="<%$ Resources:Role %>" />
            <asp:label id="roleName" runat="server" font-bold="true">
            </asp:label>
            </span>
        </td>
    </tr>
    <tr>
        <td>
            <table>
                <tbody>
                <tr valign="top">
                    <td>
                        <table cellspacing="0" cellpadding="5" class="lrbBorders" width="750"/>

                        <tbody>
                <tr>
                    <td class="callOutStyle">Search for Users</td>
                </tr>
                <tr >
                    <td class="bodyTextNoPadding">Search By:
                        <asp:dropdownlist id="dropDown1" runat="server">
                        <asp:listitem runat="server" id="listItem1" text="<%$ Resources:UserID %>"/>
                        <asp:listitem runat="server" id="listItem2" text="<%$ Resources:Email %>"/>
                        </asp:dropdownlist>
                        &nbsp;<asp:literal runat="server" text="<%$ Resources:For %>"/>
                        <asp:textbox runat="server" id="textBox1" width="11em"/>
                        &nbsp;
                        <asp:button runat="server" id="button2" onclick="SearchForUsers" text="<%$ Resources:FindUser %>"/>
                        <br />
                        <asp:repeater runat="server" id="repeater" onitemcommand="RetrieveLetter">
                        <itemtemplate>
                        <asp:linkbutton runat="server" id="linkButton1" text="<%#Container.DataItem%>" forecolor="black" commandname="Display" commandargument="<%#Container.DataItem%>" />
                        &nbsp;
                        </itemtemplate>
                        </asp:repeater>
                    </td>
                </tr>
    </tbody>
            </table>
            <br />
            <table id="containerTable" runat="server" border="0" cellspacing="0" cellpadding="0"  class="itemDetailsContainer" width="750" >
                <tbody>
                <tr align="left" valign="top">
                    <td width="62%" height="100%" class="lrbBorders">
                        <asp:gridview runat="server" id="dataGrid" allowpaging="true" border="0" cellspacing="0" cellpadding="5" autogeneratecolumns="False" onitemdatabound="ItemDataBound" onpageindexchanging="IndexChanged" pagesize="7" width="100%" UseAccessibleHeader="true">
                        <rowstyle cssclass="gridRowStyle" />
                        <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                        <headerstyle cssclass="callOutStyle" font-bold="true" height="10" HorizontalAlign="Left"/>
                        <detailtitlestyle borderstyle="None" borderwidth="1px" bordercolor="#3366cc" backcolor="White"/>
                        <selectedrowstyle cssclass="gridSelectedRowStyle"/>
                        <pagerstyle cssclass="gridPagerStyle"/>
                        <pagersettings mode="Numeric"/>
                        <columns>

                        <asp:templatefield runat="server" headertext="<%$ Resources:UserID %>">
                        <itemtemplate>
                        <asp:label runat="server" id="userNameLink" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "UserName")%>'/>
                        </itemtemplate>
                        </asp:templatefield>

                        <asp:templatefield runat="server" headertext="<%$ Resources:UserInRole %>">
                        <headerstyle horizontalalign="center" />
                        <itemstyle horizontalalign="center" />
                        <itemtemplate>
                        <asp:checkbox runat="server" oncheckedchanged="EnabledChanged" autopostback="true" checked='<%#RoleHelperInstance.IsUserInRole(DataBinder.Eval(Container.DataItem, "UserName").ToString(), (string)CurrentRole)%>' />
                        </itemtemplate>
                        </asp:templatefield>

                        </columns>
                        </asp:gridview>
                    </td>
                </tr>
                </tbody>
            </table>

        </td>
    </tr>
    </tbody>
</table>
</td>
</tr>
</tbody>
</table>
</asp:content>

