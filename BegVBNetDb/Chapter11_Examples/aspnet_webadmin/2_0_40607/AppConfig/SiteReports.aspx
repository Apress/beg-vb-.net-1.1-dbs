<%@ Page MasterPageFile="~/webAdminButtonRow.master" Inherits="System.Web.Administration.ApplicationConfigurationPage"  %>
<%@ import Namespace="System.Data" %>

<script language="C#" runat="server">

    public void Page_Load() {
        if (!IsPostBack) {
            SiteCounterHelper.Flush();
            DataSet ds = SiteCounterHelper.GetRows(null);
            Hashtable table = new Hashtable();
            DataTable dt = ds.Tables["Table"];
            if (dt == null) {
                Response.Write(ds.Tables[0].TableName);
                return;
            }
            foreach (DataRow row in dt.Rows) {
                table[row["CounterGroup"]] = true;
            }
            
            CounterGroup.DataSource = table.Keys;
            CounterGroup.DataBind();

            if (CounterGroup.Items.Count > 0) {
                SiteCounterHelper.Flush();
                GridView1.DataSource = SiteCounterHelper.GetRows(CounterGroup.SelectedValue);
                DataBind();
            }
            else {
                mv1.ActiveViewIndex = 1;
            }
        }
    }

    void SelectedIndex_Click(Object Sender, EventArgs e) {
        SiteCounterHelper.Flush();                
        GridView1.DataSource = SiteCounterHelper.GetRows(CounterGroup.SelectedValue);
        GridView1.DataBind();
        
    }

</script>

<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:Literal runat="server" Text="<%$ Resources:Title %>"/>
</asp:content>
<asp:content runat="server" contentplaceholderid="content">

<asp:multiview runat="server" id="mv1" activeviewindex="0">
<asp:view runat="server">
<asp:Literal runat="server" Text="<%$ Resources:Instructions %>"/><br/><br/>

<asp:DropDownList id="CounterGroup" runat="server" autopostback="true" onselectedindexchanged="SelectedIndex_Click"/> 
<br/><br/>    
<table cellspacing="0" cellpadding="0" border="0" id="hook" width="750">
    <tbody>
    <tr align="left" valign="top">
        <td width="62%" height="100%" class="lrbBorders">

    
            <asp:gridview autogeneratecolumns="false" runat=server id=GridView1 width="100%" cellspacing="0" cellpadding="5" border="0" UseAccessibleHeader="true" >
                <rowstyle cssclass="gridRowStyle" />
                <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                <pagerstyle cssClass="gridPagerStyle"/>
                <pagersettings mode="Numeric"/><headerstyle cssclass="callOutStyle" font-bold="true" HorizontalAlign="Left"/>
                <Columns>
                    <asp:BoundField DataField="EndTime" HeaderText="<%$ Resources:DateHeader %>" DataFormatString="{0:d}"/>
                    <asp:BoundField DataField="PageUrl" HeaderText="<%$ Resources:PageUrlHeader %>"/>
                    <asp:BoundField DataField="CounterName" HeaderText="<%$ Resources:CounterNameHeader %>"/>
                    <asp:BoundField DataField="CounterEvent" HeaderText="<%$ Resources:CounterEventHeader %>"/>
                    <asp:BoundField DataField="NavigateUrl" HeaderText="<%$ Resources:AdUrlHeader %>"/>
                    <asp:BoundField DataField="Total" HeaderText="<%$ Resources:TotalHeader %>"/>
                </Columns>
            </asp:gridview> 
    
         </td>
    </tr>
    </tbody>
</table>
</asp:view>
<asp:view runat="server">
    <asp:Literal runat="server" Text="<%$ Resources:NoCounterDataText %>"/>
</asp:view>
</asp:multiview>
<br/><br/><br/><br/>
</asp:content>

<asp:content runat=server contentplaceholderid="buttons">
<asp:button runat=server text="<%$ Resources:GlobalResources,BackButtonLabel %>" onclick="ReturnToPreviousPage"/>
</asp:content>
