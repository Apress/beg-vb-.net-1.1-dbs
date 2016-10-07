<%@ Control language="cs" ClassName="ProviderListUserControl"%>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server">

// Helper event related classes for raising events to users of the control
public delegate void ProviderEventHandler(object sender, ProviderEventArgs e);
public delegate void TestConnectionDelegate(object sender, EventArgs e);

public class ProviderEventArgs : EventArgs {

    public readonly string ServiceName;
    public readonly string ProviderName;

    public ProviderEventArgs(string serviceName, string providerName) {
        ServiceName = serviceName;
        ProviderName = providerName;
    }
}

private static readonly object EventDeleteProvider = new object();
private static readonly object EventSelectProvider = new object();
private static readonly object EventTestConnection = new object();

private string _serviceName = string.Empty;

public string AddProviderLinkText {
    get {
        return AddProviderHyperLink.Text;
    }
    set {
        AddProviderHyperLink.Text = value;
    }
}

public object DataSource {
    get {
        return ProviderListGridView.DataSource;
    }
    set {
        ProviderListGridView.DataSource = value;
    }
}

public string HeaderText {
    get {
        return HeaderLiteral.Text;
    }
    set {
        HeaderLiteral.Text = value;
    }
}

public int ParentProviderCount {
    get {
        object x = ViewState["ParentProviderCount"];
        return (x == null) ? -1 : (int) x;
    }
    set {
        ViewState["ParentProviderCount"] = value;
    }
}

public int SelectedIndex {
    get {
        return ProviderListGridView.SelectedIndex;
    }
    set {
        ProviderListGridView.SelectedIndex = value;
    }
}

public string ServiceName {
    get {
        return _serviceName;
    }
    set {
        _serviceName = value;
    }
}

public event ProviderEventHandler DeleteProvider {
    add {
        Events.AddHandler(EventDeleteProvider, value);
    }
    remove {
        Events.RemoveHandler(EventDeleteProvider, value);
    }
}

public event ProviderEventHandler SelectProvider {
    add {
        Events.AddHandler(EventSelectProvider, value);
    }
    remove {
        Events.RemoveHandler(EventSelectProvider, value);
    }
}

public event TestConnectionDelegate TestConnection {
    add {
        Events.AddHandler(EventTestConnection, value);
    }
    remove {
        Events.RemoveHandler(EventTestConnection, value);
    }
}

public void DataBind() {
    ProviderListGridView.DataBind();
    AddProviderHyperLink.NavigateUrl = "AddProvider.aspx?service=" + HttpUtility.HtmlEncode(ServiceName);
}

public void DeleteProviderLinkButton_Command(object s, CommandEventArgs e) {
    ProviderEventArgs providerArgs = new ProviderEventArgs(ServiceName, (string) e.CommandArgument);

    ProviderEventHandler handler = (ProviderEventHandler)Events[EventDeleteProvider];
    if (handler != null) {
        handler(s, providerArgs);
    }
}

private string GetConnectionStringName(object ps) {
    return ((System.Configuration.ProviderSettings)ps).Parameters["connectionStringName"];
}

private void ProviderListGridView_DataBound(object s, GridViewRowEventArgs e) {
    GridViewRow row = e.Row;
   // Response.Write(DataBinder.Eval(row.DataItem, "Name"));
    if (row.RowType == DataControlRowType.DataRow &&
        row.RowIndex == ProviderListGridView.SelectedIndex) {
        RadioButton radioButton = (RadioButton) row.FindControl("ProviderRadioButton");
        if (radioButton != null) {
            radioButton.Checked = true;
        }
    }
}

private void ProviderRadioButton_Click(object s, EventArgs e) {
    RadioButton radioButton = (RadioButton) s;
    ProviderEventArgs providerArgs = new ProviderEventArgs(ServiceName, radioButton.Text);

    ProviderEventHandler handler = (ProviderEventHandler)Events[EventSelectProvider];
    if (handler != null) {
        handler(s, providerArgs);
    }
}

private void TestConnection_Click(object s, EventArgs e) {
    TestConnectionDelegate handler = (TestConnectionDelegate)Events[EventTestConnection];
    if (handler != null) {
        handler(s, e);
    }
}

private string GetNavigateURL(string name, string service) {
    string urlString = "AddProvider.aspx?edit=1&name=";
    Encoding encoding = Response.ContentEncoding;
    urlString += WebAdminPage.UrlEncodeNonAscii(name, encoding);
    urlString += "&service=";
    urlString += WebAdminPage.UrlEncodeNonAscii(service, encoding);
    return urlString;
}


</script>

<table height="100%" width="100%" cellspacing="0" cellpadding="4"
       rules="all" bordercolor="#CCDDEF" border="1"
       style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
    <tr height="1%">
        <td class="callOutStyle" align="left" valign="top">
            <asp:Literal runat="server" id="HeaderLiteral"/>
        </td>
    </tr>
    <tr align="left" valign="top">
        <td>
            <asp:GridView runat="server" id="ProviderListGridView"
                          width="100%" cellspacing="0" cellpadding="0" border="0"
                          AutoGenerateColumns="false" ShowHeader="false"
                          OnRowDatabound="ProviderListGridView_DataBound"
                          EmptyDataText="<%$ Resources:NoProvidersCreated %>">
                <rowstyle cssclass="gridRowStyle" />
                <alternatingrowstyle cssclass="gridAlternatingRowStyle" />
                <EmptyDataRowStyle cssClass="bodyText" forecolor="gray"/>

                <columns>
                    <asp:TemplateField ItemStyle-Width="20%">
                        <ItemTemplate>
                            <asp:RadioButton runat="server" id="ProviderRadioButton"
                                             AutoPostBack="true" OnCheckedChanged="ProviderRadioButton_Click"
                                             Text='<%# DataBinder.Eval(Container.DataItem, "Name") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="7%">
                        <ItemTemplate>
                            <asp:HyperLink runat="server" ForeColor="blue" Text="<%$ Resources:Edit %>"
                                           NavigateUrl='<%# GetNavigateURL(DataBinder.Eval(Container.DataItem, "Name").ToString(),ServiceName) %>'
                                           Visible="<%# ParentProviderCount <= ((GridViewRow)Container).RowIndex %>"/>
                            <asp:Label runat="server" ForeColor="gray" Text="<%$ Resources:Edit %>"
                                           Enabled="false"
                                           Visible="<%# ParentProviderCount > ((GridViewRow)Container).RowIndex %>"/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="7%">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" id="DeleteProviderLinkButton"
                                            Text="<%$ Resources:Delete %>" ForeColor="blue" OnCommand="DeleteProviderLinkButton_Command"
                                            CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Name") %>'
                                            Visible="<%# ParentProviderCount <= ((GridViewRow)Container).RowIndex %>"/>
                            <asp:Label runat="server"
                                            Text="<%$ Resources:Delete %>" ForeColor="gray" Enabled="false"
                                            Visible="<%# ParentProviderCount > ((GridViewRow)Container).RowIndex %>"/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="7%">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" id="TestProviderLinkButton"
                                            Text="<%$ Resources:Test %>" ForeColor="blue" OnClick="TestConnection_Click"
                                            CommandArgument='<%# GetConnectionStringName(Container.DataItem) %>'
                                            CommandName='<%# DataBinder.Eval(Container.DataItem, "Type") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="59%">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# ((NameValueCollection) DataBinder.Eval(Container.DataItem, "Parameters"))["description"] %>' />
                        </ItemTemplate>                        
                    </asp:TemplateField>
                </columns>
            </asp:Gridview>
        </td>
    </tr>
    <tr class="bodyText" valign="top" align="left" height="1%">
        <td>
            <asp:HyperLink runat="server" ForeColor="blue" id="AddProviderHyperLink"/>
        </td>
    </tr>
</table>
