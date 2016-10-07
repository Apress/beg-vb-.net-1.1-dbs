Imports System.Data.SqlClient

Public Class Form1
   Inherits System.Windows.Forms.Form

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
   Friend WithEvents DataSet1 As System.Data.DataSet
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.DataGrid1 = New System.Windows.Forms.DataGrid
      Me.DataSet1 = New System.Data.DataSet
      CType(Me.DataGrid1, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.DataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'DataGrid1
      '
      Me.DataGrid1.DataMember = ""
      Me.DataGrid1.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.DataGrid1.Location = New System.Drawing.Point(0, 0)
      Me.DataGrid1.Name = "DataGrid1"
      Me.DataGrid1.Size = New System.Drawing.Size(416, 224)
      Me.DataGrid1.TabIndex = 0
      '
      'DataSet1
      '
      Me.DataSet1.DataSetName = "NewDataSet"
      Me.DataSet1.Locale = New System.Globalization.CultureInfo("en-GB")
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(408, 221)
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

      ' Sql Queries 
      Dim sql1 As String = _
         "SELECT * FROM Employees "

      Dim sql2 As String = _
         "SELECT * FROM Orders"

      Dim sql As String = sql1 & sql2

      ' Create Data Adapter
      Dim da As New SqlDataAdapter(sql, thisConnection)

      ' Map Default table names to Employees and Orders
      da.TableMappings.Add("Table", "Employees")
      da.TableMappings.Add("Table1", "Orders")

      ' Fill Dataset
      da.Fill(DataSet1)

      ' Create a relation between the two tables
      Dim dr As New DataRelation( _
         "EmployeeOrders", _
         DataSet1.Tables(0).Columns("EmployeeId"), _
         DataSet1.Tables(1).Columns("EmployeeId"))
      DataSet1.Relations.Add(dr)

      ' Bind the data to the grid at runtime
      DataGrid1.SetDataBinding(DataSet1, "Employees")
   End Sub
End Class
