Public Class WebForm1
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

   End Sub
   Protected WithEvents FirstNameTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents FirstNameRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents SubmitButton As System.Web.UI.WebControls.Button
   Protected WithEvents CancelButton As System.Web.UI.WebControls.Button
   Protected WithEvents HireDateTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents HireDateValidator As System.Web.UI.WebControls.RangeValidator
   Protected WithEvents HireDateRequiredFieldValidator As System.Web.UI.WebControls.RequiredFieldValidator
   Protected WithEvents PasswordTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents ConfirmPasswordTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents PasswordCompareValidator As System.Web.UI.WebControls.CompareValidator
   Protected WithEvents PhotoUrlTextBox As System.Web.UI.WebControls.TextBox
   Protected WithEvents PhotoUrlRegularExpressionValidator As System.Web.UI.WebControls.RegularExpressionValidator
   Protected WithEvents PhotoUrlCustomValidator As System.Web.UI.WebControls.CustomValidator

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
         Dim NextWeek As DateTime = DateTime.Today.Add(TimeSpan.FromDays(7))
         Dim LastWeek As DateTime = DateTime.Today.Subtract(TimeSpan.FromDays(7))
         HireDateValidator.MaximumValue = NextWeek
         HireDateValidator.MinimumValue = LastWeek
      End If
    End Sub

   Private Sub SubmitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SubmitButton.Click
      If Page.IsValid Then
         ' Process input here
      End If
   End Sub

   Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
      FirstNameTextBox.Text = ""
      HireDateTextBox.Text = ""
   End Sub

   Private Sub PhotoUrlCustomValidator_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles PhotoUrlCustomValidator.ServerValidate
      args.IsValid = False
      If args.Value <> "" Then
         Dim length As Integer = args.Value.Length
         Dim endsWith As String = args.Value.Substring(length - 3)
         If endsWith = "jpg" Then
            args.IsValid = True
         End If
      End If
   End Sub
End Class
