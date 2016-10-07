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
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents Label2 As System.Windows.Forms.Label
   Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
   Friend WithEvents SqlStatement As System.Windows.Forms.TextBox
   Friend WithEvents ResultBox As System.Windows.Forms.TextBox
   Friend WithEvents ExecuteButton As System.Windows.Forms.Button
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.SqlStatement = New System.Windows.Forms.TextBox
      Me.ExecuteButton = New System.Windows.Forms.Button
      Me.ResultBox = New System.Windows.Forms.TextBox
      Me.Label1 = New System.Windows.Forms.Label
      Me.Label2 = New System.Windows.Forms.Label
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      Me.SuspendLayout()
      '
      'SqlStatement
      '
      Me.SqlStatement.Location = New System.Drawing.Point(16, 32)
      Me.SqlStatement.Multiline = True
      Me.SqlStatement.Name = "SqlStatement"
      Me.SqlStatement.Size = New System.Drawing.Size(464, 96)
      Me.SqlStatement.TabIndex = 0
      Me.SqlStatement.Text = ""
      '
      'ExecuteButton
      '
      Me.ExecuteButton.Location = New System.Drawing.Point(211, 136)
      Me.ExecuteButton.Name = "ExecuteButton"
      Me.ExecuteButton.TabIndex = 1
      Me.ExecuteButton.Text = "Go"
      '
      'ResultBox
      '
      Me.ResultBox.Location = New System.Drawing.Point(16, 200)
      Me.ResultBox.Multiline = True
      Me.ResultBox.Name = "ResultBox"
      Me.ResultBox.Size = New System.Drawing.Size(464, 104)
      Me.ResultBox.TabIndex = 2
      Me.ResultBox.Text = ""
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(104, 8)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(288, 23)
      Me.Label1.TabIndex = 3
      Me.Label1.Text = "Type a SQL Statement below and press Go to execute it"
      '
      'Label2
      '
      Me.Label2.Location = New System.Drawing.Point(136, 176)
      Me.Label2.Name = "Label2"
      Me.Label2.Size = New System.Drawing.Size(224, 23)
      Me.Label2.TabIndex = 4
      Me.Label2.Text = "The results of your command are as follows"
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(496, 317)
      Me.Controls.Add(Me.Label2)
      Me.Controls.Add(Me.Label1)
      Me.Controls.Add(Me.ResultBox)
      Me.Controls.Add(Me.ExecuteButton)
      Me.Controls.Add(Me.SqlStatement)
      Me.Name = "Form1"
      Me.Text = "Form1"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub ExecuteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExecuteButton.Click
      ' Get SQL Query from textbox
      Dim sql As String = SqlStatement.Text

      ' Create Command object
      Dim NewCommand As New SqlCommand(sql, SqlConnection1)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command
         NewCommand.ExecuteNonQuery()

         ' Display Result Message
         ResultBox.Text = "SQL executed successfuly"

      Catch ex As Exception
         ' Display error message
         ResultBox.Text = ex.ToString()

      Finally
         SqlConnection1.Close()

      End Try
   End Sub
End Class
