Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Xml


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
   Friend WithEvents btnReadXml As System.Windows.Forms.Button
   Friend WithEvents btnWriteXml As System.Windows.Forms.Button
   Friend WithEvents btnConfigXML As System.Windows.Forms.Button
   Friend WithEvents XmlGrid As System.Windows.Forms.DataGrid
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.btnReadXml = New System.Windows.Forms.Button
      Me.btnWriteXml = New System.Windows.Forms.Button
      Me.btnConfigXML = New System.Windows.Forms.Button
      Me.XmlGrid = New System.Windows.Forms.DataGrid
      CType(Me.XmlGrid, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnReadXml
      '
      Me.btnReadXml.Location = New System.Drawing.Point(16, 99)
      Me.btnReadXml.Name = "btnReadXml"
      Me.btnReadXml.TabIndex = 0
      Me.btnReadXml.Text = "Read XML"
      '
      'btnWriteXml
      '
      Me.btnWriteXml.Location = New System.Drawing.Point(16, 163)
      Me.btnWriteXml.Name = "btnWriteXml"
      Me.btnWriteXml.TabIndex = 1
      Me.btnWriteXml.Text = "Write XML"
      '
      'btnConfigXML
      '
      Me.btnConfigXML.Location = New System.Drawing.Point(16, 227)
      Me.btnConfigXML.Name = "btnConfigXML"
      Me.btnConfigXML.Size = New System.Drawing.Size(75, 37)
      Me.btnConfigXML.TabIndex = 2
      Me.btnConfigXML.Text = "Configure XML"
      '
      'XmlGrid
      '
      Me.XmlGrid.DataMember = ""
      Me.XmlGrid.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.XmlGrid.Location = New System.Drawing.Point(112, 8)
      Me.XmlGrid.Name = "XmlGrid"
      Me.XmlGrid.Size = New System.Drawing.Size(304, 336)
      Me.XmlGrid.TabIndex = 3
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(424, 349)
      Me.Controls.Add(Me.XmlGrid)
      Me.Controls.Add(Me.btnConfigXML)
      Me.Controls.Add(Me.btnWriteXml)
      Me.Controls.Add(Me.btnReadXml)
      Me.Name = "Form1"
      Me.Text = "XML Demo"
      CType(Me.XmlGrid, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnReadXml_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReadXml.Click
      Dim ds As New DataSet
      ds.ReadXml("..\XMLFile1.xml", XmlReadMode.InferSchema)
      XmlGrid.SetDataBinding(ds, "book")
   End Sub

   Private Sub btnWriteXml_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnWriteXml.Click
      Dim ds As DataSet = CType(XmlGrid.DataSource, DataSet)
      ds.WriteXml("..\XMLFileOut.xml", XmlWriteMode.IgnoreSchema)
   End Sub

   Private Sub btnConfigXML_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConfigXML.Click

      ' Get connection string from config file
      Dim connString As String = ConfigurationSettings.AppSettings("cnnorthwind")

      ' Create connection
      Dim thisConnection As New SqlConnection(connString)

      ' Query string
      Dim sql As String = _
         "SELECT EmployeeId, LastName " & _
         "FROM Employees " & _
         "FOR XML AUTO"

      ' Create Connection
      Dim thisCommand As New SqlCommand(sql, thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()

         ' Get XML Reader
         Dim reader As XmlReader = thisCommand.ExecuteXmlReader()

         ' Create DataSet
         Dim ds As New DataSet

         ' Reader XMLReader into DataSet
         ds.ReadXml(reader, XmlReadMode.InferSchema)

         ' Bind dataset to datagrid
         XmlGrid.DataSource = ds

      Catch ex As SqlException
         MessageBox.Show(ex.Message)
      Finally
         thisConnection.Close()
      End Try
   End Sub
End Class
