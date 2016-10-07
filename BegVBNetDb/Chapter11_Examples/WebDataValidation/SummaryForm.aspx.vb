Imports System.Data.SqlClient

Public Class SummaryForm
   Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

   'This call is required by the Web Form Designer.
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"

   End Sub
   Protected WithEvents FirstNameTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents FirstNameRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents HireDateTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents HireDateValidator As System.Web.UI.WebControls.RangeValidator
   Protected WithEvents HireDateRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents PhotoUrlTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents PhotoUrlRegularExpressionValidator As System.Web.UI.WebControls.RegularExpressionValidator
   Protected WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
   Protected WithEvents LastNameTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents LastNameRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents BirthDateRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents BirthDateValidator As System.Web.UI.WebControls.RangeValidator
   Protected WithEvents BirthDateTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents ReportsToDropDownList As System.Web.UI.WebControls.DropDownList
   Protected WithEvents SubmitButton As System.Web.UI.WebControls.Button
   Protected WithEvents EmployeeValidationSummary As System.Web.UI.WebControls.ValidationSummary
   Protected WithEvents DataErrorMessage As System.Web.UI.WebControls.Label
   Protected WithEvents ClearButton As System.Web.UI.WebControls.Button

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
         ' Fill Drop Down Box
         BindReportToDropDown()

         ' Set min and max values for hire date box
         Dim NextWeek As DateTime = DateTime.Today.Add(TimeSpan.FromDays(7))
         Dim LastWeek As DateTime = DateTime.Today.Subtract(TimeSpan.FromDays(7))
         HireDateValidator.MaximumValue = NextWeek
         HireDateValidator.MinimumValue = LastWeek

         ' Set min and max values for birth date box
         BirthDateValidator.MaximumValue = DateTime.Today

         Dim HundredYears As DateTime = DateTime.Today.Subtract(TimeSpan.FromDays(365 * 100))
         BirthDateValidator.MinimumValue = HundredYears

      End If
   End Sub

   Private Sub BindReportToDropDown()
      ' Query string
      Dim sql As String = _
         "SELECT EmployeeID, " & _
         "FirstName + ' ' + LastName As Name " & _
         "FROM Employees"

      'Create Command and Reader
      Dim ReportsToCommand As New SqlCommand(sql, SqlConnection1)
      Dim ReportsToReader As SqlDataReader

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Get data in DataReader
         ReportsToReader = ReportsToCommand.ExecuteReader()

         ' Attach and bind data to drop down list
         ReportsToDropDownList.DataSource = ReportsToReader
         ReportsToDropDownList.DataTextField = "Name"
         ReportsToDropDownList.DataValueField = "EmployeeId"
         ReportsToDropDownList.DataBind()
         ReportsToReader.Close()
      Catch ex As Exception
         DataErrorMessage.Text = ex.ToString()
      Finally

         SqlConnection1.Close()
      End Try
   End Sub

   Private Sub ClearFields()
      FirstNameTextBox.Text = ""
      LastNameTextBox.Text = ""
      HireDateTextBox.Text = ""
      BirthDateTextBox.Text = ""
      PhotoUrlTextBox.Text = ""
      ReportsToDropDownList.SelectedIndex = 0
   End Sub

   Private Sub SubmitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
      If Page.IsValid Then

         ' Query string
         Dim sql As String = _
            "INSERT INTO Employees( " & _
            "FirstName, LastName, HireDate, BirthDate, ReportsTo, PhotoPath) " & _
            "VALUES(@FirstName, @LastName, @HireDate, @BirthDate, @ReportsTo, @PhotoURL)"

         'Create Command
         Dim SubmitCommand As New SqlCommand(sql, SqlConnection1)

         ' Set up parameters
         SubmitCommand.Parameters.Add("@FirstName", FirstNameTextBox.Text)
         SubmitCommand.Parameters.Add("@LastName", LastNameTextBox.Text)
         SubmitCommand.Parameters.Add("@HireDate", HireDateTextBox.Text)
         SubmitCommand.Parameters.Add("@BirthDate", BirthDateTextBox.Text)
         SubmitCommand.Parameters.Add("@ReportsTo", ReportsToDropDownList.SelectedItem.Value)
         SubmitCommand.Parameters.Add("@PhotoURL", PhotoUrlTextBox.Text)

         Try
            ' Open Connection
            SqlConnection1.Open()

            ' Run Insert query
            SubmitCommand.ExecuteNonQuery()

         Catch ex As Exception
            DataErrorMessage.Text = ex.ToString()
         Finally
            SqlConnection1.Close()

            ClearFields()
         End Try
      End If
   End Sub

   Private Sub PhotoUrlCustomValidator_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs)
      args.IsValid = False
      If args.Value <> "" Then
         Dim length As Integer = args.Value.Length
         Dim endsWith As String = args.Value.Substring(length - 3)
         If endsWith = "jpg" Then
            args.IsValid = True
         End If
      End If
   End Sub

   Private Sub ClearButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearButton.Click
      ClearFields()
   End Sub
End Class
