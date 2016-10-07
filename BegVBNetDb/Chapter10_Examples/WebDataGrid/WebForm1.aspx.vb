Imports System.Data.SqlClient

Public Class WebForm1
   Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

   'This call is required by the Web Form Designer.
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\netsdk"";persist security info=False;initial catalog=Northwind"

   End Sub
   Protected WithEvents DataGrid1 As System.Web.UI.WebControls.DataGrid
   Protected WithEvents ErrorLabel As System.Web.UI.WebControls.Label
   Protected WithEvents Panel1 As System.Web.UI.WebControls.Panel
   Protected WithEvents Label1 As System.Web.UI.WebControls.Label
   Protected WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection

   'NOTE: The following placeholder declaration is required by the Web Form Designer.
   'Do not delete or move it.
   Private designerPlaceholderDeclaration As System.Object

   Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
      'CODEGEN: This method call is required by the Web Form Designer
      'Do not modify it using the code editor.
      InitializeComponent()
   End Sub

#End Region

   Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      If Not Page.IsPostBack Then
         BindDataGrid(True)
      End If
   End Sub

   Private Sub BindDataGrid()
      BindDataGrid(False, "")
   End Sub

   Private Sub BindDataGrid(ByVal refresh As Boolean)
      BindDataGrid(refresh, "")
   End Sub

   Private Sub BindDataGrid(ByVal sortExpression As String)
      BindDataGrid(False, sortExpression)
   End Sub

   Private Sub BindDataGrid(ByVal refresh As Boolean, ByVal sortExpression As String)
      Dim ds As New DataSet
      If refresh Or Session("Employees") Is Nothing Then
         ' Sql Query 
         Dim sql As String = _
            "SELECT EmployeeId, FirstName, LastName, " & _
            "Title, Extension, HireDate " & _
            "FROM Employees"

         Try
            ' Open Connection
            SqlConnection1.Open()

            ' Create Data Adapter
            Dim da As New SqlDataAdapter(sql, SqlConnection1)

            ' Fill DataSet
            da.Fill(ds, "Employees")

            ' Save DataSet in Session State
            Session("Employees") = ds

         Catch ex As Exception
            ' Display error
            ErrorLabel.Text = "Error: " & ex.ToString()
         Finally
            SqlConnection1.Close()
         End Try
      Else
         ds = CType(Session("Employees"), DataSet)
      End If

      ' Create sorted view of data
      Dim dv As DataView = ds.Tables("Employees").DefaultView

      If sortExpression <> "" Then
         dv.Sort = sortExpression
      End If
      DataGrid1.DataSource = dv
      DataGrid1.DataKeyField = "EmployeeId"
      DataGrid1.DataBind()
   End Sub

   Private Sub DataGrid1_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles DataGrid1.PageIndexChanged
      DataGrid1.CurrentPageIndex = e.NewPageIndex
      DataGrid1.SelectedIndex = -1
      DataGrid1.EditItemIndex = -1
      Panel1.Visible = False
      BindDataGrid()
   End Sub

   Private Sub DataGrid1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles DataGrid1.SelectedIndexChanged
      ' Get Index of Selected Item
      Dim key As String = DataGrid1.DataKeys(DataGrid1.SelectedIndex).ToString()

      ' Sql Query For Notes Field
      Dim NotesSql As String = _
         "SELECT Notes FROM Employees " & _
         "WHERE EmployeeId = @EmployeeId"

      ' Create Command and add parameter
      Dim NotesCommand As New SqlCommand(NotesSql, SqlConnection1)
      NotesCommand.Parameters.Add("@EmployeeId", key)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Run query and get data reader
         Dim NotesReader As SqlDataReader = NotesCommand.ExecuteReader()

         ' If there's data, make it visible
         If NotesReader.Read() Then
            Label1.Text = NotesReader("Notes").ToString()
            Panel1.Visible = True
         End If

         ' Close datareader
         NotesReader.Close()

      Catch ex As Exception
         ' Display error
         ErrorLabel.Text = "Error: " & ex.ToString()

      Finally
         ' Close connection
         SqlConnection1.Close()

      End Try
   End Sub

   Private Sub DataGrid1_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles DataGrid1.EditCommand
      DataGrid1.EditItemIndex = e.Item.ItemIndex
      BindDataGrid()
   End Sub

   Private Sub DataGrid1_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles DataGrid1.CancelCommand
      DataGrid1.EditItemIndex = -1
      BindDataGrid()
   End Sub

   Private Sub DataGrid1_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles DataGrid1.UpdateCommand
      ' Get Index of Selected Item
      Dim key As String = DataGrid1.DataKeys(DataGrid1.EditItemIndex).ToString()

      ' Sql Query For Notes Field
      Dim UpdateSql As String = _
         "UPDATE Employees SET " & _
            "firstname = @firstname, " & _
            "lastname = @lastname, " & _
            "title = @title, " & _
            "extension = @extension, " & _
            "hiredate = @hiredate " & _
         "WHERE EmployeeId = @employeeid"

      ' Create Command and add parameter
      Dim UpdateCommand As New SqlCommand(UpdateSql, SqlConnection1)
      UpdateCommand.Parameters.Add("@employeeid", key)
      UpdateCommand.Parameters.Add("@firstname", CType(e.Item.Cells(1).Controls(0), TextBox).Text)
      UpdateCommand.Parameters.Add("@lastname", CType(e.Item.Cells(2).Controls(0), TextBox).Text)
      UpdateCommand.Parameters.Add("@title", CType(e.Item.Cells(3).Controls(0), TextBox).Text)
      UpdateCommand.Parameters.Add("@extension", CType(e.Item.Cells(4).Controls(0), TextBox).Text)
      UpdateCommand.Parameters.Add("@hiredate", CType(e.Item.Cells(5).FindControl("Calendar1"), Calendar).SelectedDate)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Run the Update Command
         UpdateCommand.ExecuteNonQuery()
      Catch ex As Exception
         ' Display error
         ErrorLabel.Text = "Error: " & ex.ToString()

      Finally
         ' Close connection
         SqlConnection1.Close()

      End Try

      DataGrid1.EditItemIndex = -1
      BindDataGrid(True)
   End Sub

   Private Sub DataGrid1_DeleteCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles DataGrid1.DeleteCommand
      DataGrid1.SelectedIndex = -1
      Panel1.Visible = False
      DataGrid1.EditItemIndex = -1

      ' Get Index of Selected Item
      Dim key As String = DataGrid1.DataKeys(e.Item.ItemIndex).ToString()

      ' Sql Query For Notes Field
      Dim DeleteSql As String = _
         "DELETE FROM Employees " & _
         "WHERE employeeid = @employeeid"

      ' Create command and add parameter
      Dim DeleteCommand As New SqlCommand(DeleteSql, SqlConnection1)
      DeleteCommand.Parameters.Add("@employeeid", key)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Run delete command
         DeleteCommand.ExecuteNonQuery()

      Catch ex As Exception
         ' Display error
         ErrorLabel.Text = "Error: " & ex.ToString()

      Finally
         ' Close connection
         SqlConnection1.Close()

      End Try

      BindDataGrid(True)
   End Sub

   Private Sub DataGrid1_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles DataGrid1.SortCommand
      DataGrid1.SelectedIndex = -1
      Panel1.Visible = False
      DataGrid1.EditItemIndex = -1
      BindDataGrid(e.SortExpression)
   End Sub
End Class
