<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" inherits="System.Web.Administration.SecurityPage"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server" language="CS">

private const string DATA_SOURCE = "WebAdminDataSource";
private const string DATA_SOURCE_ROLES = "WebAdminDataSourceRoles";

public void SetDataSourceRoles(object v) {
    Session[DATA_SOURCE_ROLES] =  v;
}

public void SetDataSource(object v) {
    Session[DATA_SOURCE] = (WebAdminMembershipUserHelperCollection) v;
}

public void BindGrid() {
    DataGrid.DataSource = Session[DATA_SOURCE];
    DataGrid.DataBind();
    if (DataGrid.Rows.Count == 0) {
        noUsers.Visible = true;
    }
}

public void IndexChanged(object s, GridViewPageEventArgs e) {
    DataGrid.PageIndex = e.NewPageIndex;
    BindGrid();
}

public void Page_Load() {
    noUsers.Visible = false;
    if(!IsPostBack) {
        PopulateRepeaterDataSource();
        AlphabetRepeater.DataBind();

        WebAdminMembershipUserHelperCollection users;
        string[] roles;
        MembershipAndRoleHelperInstance.GetUsersAndRoles(out users, out roles);
        SetDataSourceRoles(roles);
        SetDataSource(users);
        BindGrid();
    }
}

public void ButtonClick(object s, EventArgs e) {
    LinkButton button = (LinkButton)s;
    string userName = button.CommandArgument;
    SetCurrentUser(userName);
}

public void EnabledChanged(object s, EventArgs e) {
    CheckBox checkBox = (CheckBox) s;
    GridViewRow item = (GridViewRow)checkBox.Parent.Parent;
    Label label = (Label) item.FindControl("UserNameLink");
    string userID = label.Text;
    WebAdminMembershipUserHelper user = MembershipHelperInstance.GetUser(userID, false /* isOnline */);
    user.IsApproved = checkBox.Checked;
    MembershipHelperInstance.UpdateUser(user);
}

public void LinkButtonClick(object s, CommandEventArgs e) {
    if (e.CommandName.Equals("EditUser")) {
        CurrentUser = ((string)e.CommandArgument); 
        Response.Redirect("editUser.aspx");
    }
    if (e.CommandName.Equals("DeleteUser")) {
        UserID.Text = (string)e.CommandArgument;
        AreYouSure.Text = String.Format((string)GetPageResourceObject("AreYouSure"), UserID.Text);
        Master.SetDisplayUI(true);
    }
}

private void No_Click(object s, EventArgs e) {
    Master.SetDisplayUI(false);
}

private void PopulateRepeaterDataSource() {
    PopulateRepeaterDataSource (AlphabetRepeater);
}

public void RedirectToAddUser(object s, EventArgs e) {
    CurrentUser = null;
    Response.Redirect("adduser.aspx");
}

public void RetrieveLetter(object s, RepeaterCommandEventArgs e) {
    WebAdminMembershipUserHelperCollection users = null;
    RetrieveLetter(s, e, DataGrid, (string)GetAppResourceObject("GlobalResources", "All"), users);
    SetDataSource(DataGrid.DataSource);
    BindGrid();
    RolePlaceHolder.Visible = DataGrid.Rows.Count != 0;
}

protected void RoleMembershipChanged(object s, EventArgs e) {
    try {
        CheckBox box = (CheckBox) s;
        // Array manipulation because cannot use Roles static method (need different appPath).
        string u = CurrentUser;
        string[] users = new string[1];
        users[0] = u;
        string role = box.Text;
        string[] roles = new string[1];
        roles[0] = role;
        if (box.Checked) {
            RoleHelperInstance.AddUsersToRoles(users, roles);
        }
        else {
            RoleHelperInstance.RemoveUsersFromRoles(users, roles);
        }
    }
    catch (Exception ex) {
        // Ignore, e.g., user is already in role.
    }
}

public void SearchForUsers(object s, EventArgs e) {
    SearchForUsers(s, e, AlphabetRepeater, DataGrid, SearchByDropDown, TextBox1);
    SetDataSource(DataGrid.DataSource);
    BindGrid();
    RolePlaceHolder.Visible = DataGrid.Rows.Count != 0;
}

private void SetCurrentUser(string s) {
    CurrentUser = s;
    try
    {
        if (IsRoleManagerEnabled()) {

            CheckBoxRepeater.DataSource = Session[DATA_SOURCE_ROLES];
            CheckBoxRepeater.DataBind();
            if (CheckBoxRepeater.Items.Count > 0) {
                AddToRole.Text = String.Format((string)GetPageResourceObject("AddToRoles2"), s);
            }
            else {
                AddToRole.Text = (string)GetPageResourceObject("NoRolesDefined");
            }
        }
        else {
            ArrayList arr = new ArrayList();
            CheckBoxRepeater.DataSource = arr;
            CheckBoxRepeater.DataBind();
            AddToRole.Text = (string)GetPageResourceObject("RolesNotEnabled");
        }
    } catch{}

    multiView1.ActiveViewIndex = 1;
}

private void Yes_Click(object s, EventArgs e) {
    MembershipHelperInstance.DeleteUser(UserID.Text, true);
    WebAdminMembershipUserHelperCollection users;
    string[] roles;
    MembershipAndRoleHelperInstance.GetUsersAndRoles(out users, out roles);
    if (users.Count == 0) {
        noUsers.Visible = true;
    }
    SetDataSource(users);
    SetDataSourceRoles(roles);
    BindGrid();

    PopulateRepeaterDataSource();
    AlphabetRepeater.DataBind();

    Master.SetDisplayUI(false);
}
</script>


<asp:content runat="server" contentplaceholderid="titleBar">
Manage Users
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
<asp:button runat="server" id="Button1" text="<%$ Resources:Back %>" onclick="ReturnToPreviousPage"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
<asp:literal runat="server" text="<%$ Resources:Instructions %>" />
<br/><br/>
<%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
<input type="text" style="visibility:hidden"/>
<table cellspacing="0" cellpadding="5" class="lrbBorders" width="750">
    <tr>
        <td class="callOutStyle"><asp:literal runat="server" text="<%$ Resources:SearchForUsers %>"/></td>
    </tr>
    <tr >
        <td class="bodyTextLowTopPadding">
            <asp:Label runat="server" AssociatedControlID="SearchByDropDown" Text="<%$ Resources:SearchBy %>"/>
            <asp:dropDownList runat="server" id="SearchByDropDown">
            <asp:listItem runat="server" id="Item1" text="<%$ Resources:UserID %>" />
            <asp:listitem runat="server" id="Item2" text="<%$ Resources:Email %>" />
            </asp:dropdownlist>
            &nbsp;&nbsp;<asp:Label runat="server" AssociatedControlID="TextBox1" Text="<%$ Resources:For %>"/>
            <asp:textbox runat="server" id="TextBox1"/>
            <asp:button runat="server" text="<%$ Resources:SearchFor %>" onclick="SearchForUsers"/>
            <br/>
            <asp:repeater runat="server" id="AlphabetRepeater" onitemcommand="RetrieveLetter">
            <itemtemplate>
            <asp:linkbutton runat="server" id="LinkButton1" commandname="Display" commandargument="<%#Container.DataItem%>" text="<%#Container.DataItem%>"/>
            &nbsp;
            </itemtemplate>
            </asp:repeater>
        </td>
</table>
<br/>

<table cellspacing="0" cellpadding="0" border="0" id="hook" width="750">
    <tbody>
    <tr align="left" valign="top">
        <td width="62%" height="100%" class="lbBorders">
            <asp:gridview runat="server" id="DataGrid" width="100%" cellspacing="0" cellpadding="5" border="0" autogeneratecolumns="False" allowpaging="true" pagesize="7" onpageindexchanging="IndexChanged" UseAccessibleHeader="true">
            <rowstyle cssclass="gridRowStyle" />
            <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
            <pagerstyle cssClass="gridPagerStyle"/>
            <pagersettings mode="Numeric"/>
            <headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>
            <selectedrowstyle cssclass="gridSelectedRowStyle"/>
            <columns>
           
                        
            <asp:templatefield headertext="<%$ Resources:Active %>">
            <headerstyle horizontalalign="center"/>
            <itemstyle horizontalalign="center"/>
            <itemtemplate>
            <asp:checkBox runat="server" id="CheckBox1" oncheckedchanged="EnabledChanged" autopostback="true" checked='<%#DataBinder.Eval(Container.DataItem, "IsApproved")%>'/>
            </itemtemplate>
            </asp:templatefield>

            <asp:templatefield runat="server" headertext="<%$ Resources:UserID %>">
            <itemtemplate>
            <asp:label runat="server" id="UserNameLink" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "UserName")%>'/>
            </itemtemplate>
            </asp:templatefield>

            <asp:templatefield runat="server">
            <itemtemplate>
            <asp:linkButton runat="server" id="LinkButton1" text="<%$ Resources:EditUser %>" commandname="EditUser" commandargument='<%#DataBinder.Eval(Container.DataItem, "UserName")%>' forecolor="black" oncommand="LinkButtonClick"/>
            </itemtemplate>
            </asp:templatefield>

            <asp:templatefield runat="server">
            <itemtemplate>
            <asp:linkButton runat="server" id="linkButton2" text="<%$ Resources:DeleteUser%>" commandname="DeleteUser" commandargument='<%#DataBinder.Eval(Container.DataItem, "UserName")%>' forecolor="black" oncommand="LinkButtonClick"/>
            </itemtemplate>
            </asp:templatefield>

            <asp:templatefield runat="server">
            <itemtemplate>
            <asp:linkbutton runat="server" commandname="EditRoles" forecolor='black' onclick="ButtonClick" text="<%$ Resources:EditRoles %>" commandargument='<%# DataBinder.Eval(Container.DataItem, "UserName") %>'/>
            </itemtemplate>
            </asp:templatefield>

            </columns>
            </asp:gridview>

            
            <asp:label runat="server" id="noUsers" class="bodyTextNoPadding" enableViewState="false" visible="false" text="<%$ Resources:NoUsersCreated %>"/>
            
        </td>
        <td width="32%" height="100%">
            <asp:placeholder runat="server" id="RolePlaceHolder">
                <table borderwidth="1px" cellpadding="5" cellspacing="0" height="100%" width="100%">
                    <tr class="callOutStyle">
                        <td valign="center"><asp:literal runat="server" text="<%$ Resources:Roles %>"/></td>
                    </tr>
                    <tr class="userDetailsWithFontSize" valign="top">
                        <td class="lrbBorders" height="100%" >
                            <asp:multiView runat="server" id="multiView1" activeviewindex="0">
                            <asp:view runat="server" id="view1">
                            </asp:view>
                            <asp:view runat="server" id="view2">
                            <asp:label runat="server" id="AddToRole" text="<%$ Resources:AddToRoles %>"/><br/>
                            <asp:repeater runat="server" id="CheckBoxRepeater">
                            <itemtemplate>
                            <asp:checkBox runat="server" id="CheckBox1" autopostback="true" oncheckedchanged="RoleMembershipChanged" text='<%# Container.DataItem.ToString()%>' checked="<%# RoleHelperInstance.IsUserInRole(CurrentUser, Container.DataItem.ToString())%>"/>
                            <br/>
                            </itemtemplate>
                            </asp:repeater>
                            </asp:view>
                            </asp:multiView>
                        </td>
                    </tr>
                </table>
            </asp:placeholder>
        </td>
    </tr>
    </tbody>
</table>
<asp:linkButton runat="server" id="LinkButton3" text="<%$ Resources:CreateNewUser %>" onclick="RedirectToAddUser"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
<asp:literal runat="server" text="<%$ Resources:ManageUsers %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">

    <img src="../../Images/alert_lrg.gif"/>
<%-- Literal is used here as a convenience, including storing a text property in view state. --%>
<asp:literal runat="server" id="UserID" visible="false"/>
<asp:literal runat="server" id="AreYouSure" text="<%$ Resources:AreYouSure %>" />
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" OnClick="Yes_Click" Text="<%$ Resources:Yes %>" width="100"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" OnClick="No_Click" Text="<%$ Resources:No %>" width="100"/>
</asp:content>


