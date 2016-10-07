<%@ Control language="cs"%>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>

<script runat="server">

private string _groupName = string.Empty;

public object DataSource {
    get {
        return PropertyListGridView.DataSource;
    }
    set {
        PropertyListGridView.DataSource = value;
    }
}

public virtual String EmptyDataText {
    get {
        return PropertyListGridView.EmptyDataText;
    }
    set {
        PropertyListGridView.EmptyDataText = value;
    }
}

public string GroupName {
    get {
        return _groupName;
    }
    set {
        _groupName = value;
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

public int PageIndex {
    get {
        return PropertyListGridView.PageIndex;
    }
    set {
        PropertyListGridView.PageIndex = value;
    }
}

public GridViewRowCollection Rows {
    get {
        return PropertyListGridView.Rows;
    }
}

public event GridViewPageEventHandler PageIndexChanging {
    add {
        PropertyListGridView.PageIndexChanging += value;
    }
    remove {
        PropertyListGridView.PageIndexChanging -= value;
    }
}

public void DataBind() {
    PropertyListGridView.DataBind();
}

public void SetPropertyCountLabel(int count, string numOfProperitesLabel) {
    // Display the label of # of properties
    string numOfPropertiesText = numOfProperitesLabel + count.ToString(CultureInfo.InvariantCulture);
    if (count <= PropertyListGridView.PageSize) {
        NumOfPropertiesLabel.Visible = true;
        NumOfPropertiesLabel.Text = numOfPropertiesText;
    }
    else {
        // Merge the text in the pager row
        NumOfPropertiesLabel.Visible = false;

        TableCell labelCell = new TableCell();
        labelCell.HorizontalAlign = HorizontalAlign.Left;
        labelCell.VerticalAlign = VerticalAlign.Top;
        labelCell.ColumnSpan = 2;
        labelCell.Text = numOfPropertiesText;

        GridViewRow pagerRow = PropertyListGridView.BottomPagerRow;
        TableCell pagerCell = pagerRow.Cells[0];
        pagerCell.ColumnSpan -= 2;
        pagerRow.Cells.AddAt(0, labelCell);
    }
}

private string GetNavigateURL(string name, string group) {
    string urlString = "EditProperty.aspx?name=";
    Encoding encoding = Response.ContentEncoding;
    urlString += WebAdminPage.UrlEncodeNonAscii(name, encoding);
    urlString += "&group=";
    urlString += WebAdminPage.UrlEncodeNonAscii(group, encoding);
    return urlString;
}

</script>

<table height="100%" width="100%" cellspacing="0" cellpadding="0"
       rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
    <tr height="1%">
        <td class="callOutStyle" align="left" valign="top" style="padding-left:5;padding-top:5;padding-bottom:5;">
            <asp:Literal runat="server" id="HeaderLiteral"/>
        </td>
    </tr>
    <tr align="left" valign="top">
        <td>
            <asp:GridView runat="server" id="PropertyListGridView"
                          width="100%" cellspacing="0" cellpadding="5" border="0"
                          AutoGenerateColumns="false" ShowHeader="false"
                          AllowPaging="true" PageSize="7">
                <rowstyle cssclass="gridRowStyle" />
                <alternatingrowstyle cssclass="gridRowStyle" />
                <pagersettings mode="Numeric" Position="Bottom" />
                <pagerstyle cssClass="gridPagerStyle" HorizontalAlign="Right" />
                <EmptyDataRowStyle HorizontalAlign="Center" cssClass="bodyText" forecolor="gray"/>

                <columns>
                    <asp:TemplateField ItemStyle-Width="30%">
                        <ItemTemplate>
                            <asp:CheckBox runat="server" id="SelectedCheckBox" Enabled='<%#DataBinder.Eval(Container.DataItem, "Enabled")%>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Property" ItemStyle-Width="40%"/>

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HyperLink runat="server" ForeColor="blue" Text="<%$ Resources:GlobalResources,EditButtonLabel %>"
                                           NavigateUrl='<%# GetNavigateURL(DataBinder.Eval(Container.DataItem, "Property").ToString(), GroupName) %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </columns>
            </asp:Gridview>
        </td>
    </tr>
    <tr class="gridPagerStyle" style="padding-left:5;padding-top:5;padding-bottom:5;" height="1%">
        <td>
            <asp:Label runat="server" id="NumOfPropertiesLabel"/>
        </td>
    </tr>
</table>
