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
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.DataGrid1 = New System.Windows.Forms.DataGrid
      CType(Me.DataGrid1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'DataGrid1
      '
      Me.DataGrid1.DataMember = ""
      Me.DataGrid1.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.DataGrid1.Location = New System.Drawing.Point(8, 0)
      Me.DataGrid1.Name = "DataGrid1"
      Me.DataGrid1.Size = New System.Drawing.Size(552, 280)
      Me.DataGrid1.TabIndex = 0
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(568, 285)
      Me.Controls.Add(Me.DataGrid1)
      Me.Name = "Form1"
      Me.Text = "Form1"
      CType(Me.DataGrid1, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        DataGrid1_Navigate(sender, Nothing)
    End Sub

    Private Sub DataGrid1_Navigate(ByVal sender As Object, ByVal ne As System.Windows.Forms.NavigateEventArgs) Handles DataGrid1.Navigate
        ' Create Connection object
        Dim thisConnection As New SqlConnection _
           ("server=(local)\netsdk;" & _
            "integrated security=sspi;" & _
            "database=northwind")

        ' Create Command Object
        Dim thisCommand As New SqlCommand _
           ("SELECT * FROM Customers", thisConnection)

        ' Create Data Reader
        Dim thisReader As SqlDataReader

        Try
            ' Open Connection
            thisConnection.Open()

            ' Load data table with data reader
            thisReader = thisCommand.ExecuteReader()
            Dim dt As New DataTable("Customers")
            dt.Load(thisReader)

            ' Bind data table to datagrid
            DataGrid1.DataSource = dt

            ' Close Reader
            thisReader.Close()

        Catch ex As Exception
            MessageBox.Show(ex.Message)
        Finally
            ' Close Connection
            thisConnection.Close()
        End Try
    End Sub
End Class
