Imports System.Data.SqlClient

Public Class Form1
   Inherits System.Windows.Forms.Form

   ' Declare a binding manager field
   Private bMgr As BindingManagerBase


#Region " Windows Form Designer generated code "

   Public Sub New()
      MyBase.New()

      'This call is required by the Windows Form Designer.
      InitializeComponent()

      'Add any initialization after the InitializeComponent() call

   End Sub

   'Form overrides dispose to clean up the component list.
   Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
      If disposing Then
         If Not (components Is Nothing) Then
            components.Dispose()
         End If
      End If
      MyBase.Dispose(disposing)
   End Sub

   'Required by the Windows Form Designer
   Private components As System.ComponentModel.IContainer

   'NOTE: The following procedure is required by the Windows Form Designer
   'It can be modified using the Windows Form Designer.  
   'Do not modify it using the code editor.
   Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
   Friend WithEvents TextBox2 As System.Windows.Forms.TextBox
   Friend WithEvents buttonBack As System.Windows.Forms.Button
   Friend WithEvents buttonNext As System.Windows.Forms.Button
   Friend WithEvents DataSet1 As System.Data.DataSet
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.TextBox1 = New System.Windows.Forms.TextBox
      Me.TextBox2 = New System.Windows.Forms.TextBox
      Me.buttonBack = New System.Windows.Forms.Button
      Me.buttonNext = New System.Windows.Forms.Button
      Me.DataSet1 = New System.Data.DataSet
      CType(Me.DataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'TextBox1
      '
      Me.TextBox1.Location = New System.Drawing.Point(8, 8)
      Me.TextBox1.Name = "TextBox1"
      Me.TextBox1.Size = New System.Drawing.Size(176, 20)
      Me.TextBox1.TabIndex = 0
      Me.TextBox1.Text = "TextBox1"
      '
      'TextBox2
      '
      Me.TextBox2.Location = New System.Drawing.Point(8, 40)
      Me.TextBox2.Name = "TextBox2"
      Me.TextBox2.Size = New System.Drawing.Size(176, 20)
      Me.TextBox2.TabIndex = 1
      Me.TextBox2.Text = "TextBox2"
      '
      'buttonBack
      '
      Me.buttonBack.Location = New System.Drawing.Point(8, 72)
      Me.buttonBack.Name = "buttonBack"
      Me.buttonBack.TabIndex = 2
      Me.buttonBack.Text = "<< Back"
      '
      'buttonNext
      '
      Me.buttonNext.Location = New System.Drawing.Point(112, 72)
      Me.buttonNext.Name = "buttonNext"
      Me.buttonNext.TabIndex = 3
      Me.buttonNext.Text = "Next >>"
      '
      'DataSet1
      '
      Me.DataSet1.DataSetName = "NewDataSet"
      Me.DataSet1.Locale = New System.Globalization.CultureInfo("en-GB")
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(200, 101)
      Me.Controls.Add(Me.buttonNext)
      Me.Controls.Add(Me.buttonBack)
      Me.Controls.Add(Me.TextBox2)
      Me.Controls.Add(Me.TextBox1)
      Me.Name = "Form1"
      Me.Text = "Form1"
      CType(Me.DataSet1, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 
      Dim sql As String = _
         "SELECT * FROM Employees"

      ' Create Data Adapter
      Dim da As New SqlDataAdapter(sql, thisConnection)

      ' Fill Dataset
      da.Fill(DataSet1, "Employees")

      ' Bind to firstname column of the employees table
      TextBox1.DataBindings.Add("text", DataSet1, "employees.firstname")

      ' Bind to lastname column of the employees table
      TextBox2.DataBindings.Add("text", DataSet1, "employees.lastname")

      ' Create the Binding Manager
      bMgr = Me.BindingContext(DataSet1, "Employees")
   End Sub

   Private Sub buttonNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles buttonNext.Click
      ' Point to the next row and refresh the text box
      bMgr.Position += 1
   End Sub

   Private Sub buttonBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles buttonBack.Click
      ' Point to the previous row and refresh the text box
      bMgr.Position -= 1
   End Sub
End Class
