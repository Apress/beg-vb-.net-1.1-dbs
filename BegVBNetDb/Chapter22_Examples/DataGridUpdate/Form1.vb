Imports System.Data.SqlClient

Public Class Form1
   Inherits System.Windows.Forms.Form

   Private cb As SqlCommandBuilder
   Private da As SqlDataAdapter

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
   Friend WithEvents DataGrid1 As System.Windows.Forms.DataGrid
   Friend WithEvents buttonUpdate As System.Windows.Forms.Button
   Friend WithEvents DataSet1 As System.Data.DataSet
   Friend WithEvents SqlCommand1 As System.Data.SqlClient.SqlCommand
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.DataGrid1 = New System.Windows.Forms.DataGrid
      Me.buttonUpdate = New System.Windows.Forms.Button
      Me.DataSet1 = New System.Data.DataSet
      Me.SqlCommand1 = New System.Data.SqlClient.SqlCommand
      CType(Me.DataGrid1, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.DataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'DataGrid1
      '
      Me.DataGrid1.DataMember = ""
      Me.DataGrid1.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.DataGrid1.Location = New System.Drawing.Point(8, 8)
      Me.DataGrid1.Name = "DataGrid1"
      Me.DataGrid1.Size = New System.Drawing.Size(400, 192)
      Me.DataGrid1.TabIndex = 0
      '
      'buttonUpdate
      '
      Me.buttonUpdate.Location = New System.Drawing.Point(171, 208)
      Me.buttonUpdate.Name = "buttonUpdate"
      Me.buttonUpdate.TabIndex = 1
      Me.buttonUpdate.Text = "Update"
      '
      'DataSet1
      '
      Me.DataSet1.DataSetName = "NewDataSet"
      Me.DataSet1.Locale = New System.Globalization.CultureInfo("en-GB")
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(416, 245)
      Me.Controls.Add(Me.buttonUpdate)
      Me.Controls.Add(Me.DataGrid1)
      Me.Name = "Form1"
      Me.Text = "Form1"
      CType(Me.DataGrid1, System.ComponentModel.ISupportInitialize).EndInit()
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
         "SELECT * FROM Employees "

      ' Create a Command
      SqlCommand1 = New SqlCommand(sql, thisConnection)

      ' Create SqlDataAdapter
      da = New SqlDataAdapter
      da.SelectCommand = SqlCommand1

      ' Create SqlCommandBuilder object
      cb = New SqlCommandBuilder(da)

      ' Fill Dataset
      da.Fill(DataSet1, "Employees")

      ' Bind the data to the grid at runtime
      DataGrid1.SetDataBinding(DataSet1, "Employees")
   End Sub

   Private Sub buttonUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles buttonUpdate.Click
      da.UpdateBatchSize = 10
      da.Update(DataSet1, "Employees")
   End Sub
End Class
