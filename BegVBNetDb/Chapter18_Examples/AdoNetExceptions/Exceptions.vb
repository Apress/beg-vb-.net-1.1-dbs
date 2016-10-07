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
   Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
   Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents Label2 As System.Windows.Forms.Label
   Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
   Friend WithEvents btnADO1 As System.Windows.Forms.Button
   Friend WithEvents btnADO2 As System.Windows.Forms.Button
   Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
   Friend WithEvents btnDB1 As System.Windows.Forms.Button
   Friend WithEvents btnDB2 As System.Windows.Forms.Button
   Friend WithEvents btnDB3 As System.Windows.Forms.Button
   Friend WithEvents Label3 As System.Windows.Forms.Label
   Friend WithEvents Label4 As System.Windows.Forms.Label
   Friend WithEvents Label5 As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.TabControl1 = New System.Windows.Forms.TabControl
      Me.TabPage1 = New System.Windows.Forms.TabPage
      Me.Label2 = New System.Windows.Forms.Label
      Me.Label1 = New System.Windows.Forms.Label
      Me.btnADO2 = New System.Windows.Forms.Button
      Me.btnADO1 = New System.Windows.Forms.Button
      Me.TabPage2 = New System.Windows.Forms.TabPage
      Me.Label5 = New System.Windows.Forms.Label
      Me.Label4 = New System.Windows.Forms.Label
      Me.Label3 = New System.Windows.Forms.Label
      Me.btnDB3 = New System.Windows.Forms.Button
      Me.btnDB2 = New System.Windows.Forms.Button
      Me.btnDB1 = New System.Windows.Forms.Button
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      Me.TabControl1.SuspendLayout()
      Me.TabPage1.SuspendLayout()
      Me.TabPage2.SuspendLayout()
      Me.SuspendLayout()
      '
      'TabControl1
      '
      Me.TabControl1.Controls.Add(Me.TabPage1)
      Me.TabControl1.Controls.Add(Me.TabPage2)
      Me.TabControl1.Location = New System.Drawing.Point(8, 8)
      Me.TabControl1.Name = "TabControl1"
      Me.TabControl1.SelectedIndex = 0
      Me.TabControl1.Size = New System.Drawing.Size(272, 256)
      Me.TabControl1.TabIndex = 0
      '
      'TabPage1
      '
      Me.TabPage1.Controls.Add(Me.Label2)
      Me.TabPage1.Controls.Add(Me.Label1)
      Me.TabPage1.Controls.Add(Me.btnADO2)
      Me.TabPage1.Controls.Add(Me.btnADO1)
      Me.TabPage1.Location = New System.Drawing.Point(4, 22)
      Me.TabPage1.Name = "TabPage1"
      Me.TabPage1.Size = New System.Drawing.Size(264, 230)
      Me.TabPage1.TabIndex = 0
      Me.TabPage1.Text = "ADO.NET"
      '
      'Label2
      '
      Me.Label2.Location = New System.Drawing.Point(48, 128)
      Me.Label2.Name = "Label2"
      Me.Label2.Size = New System.Drawing.Size(168, 32)
      Me.Label2.TabIndex = 3
      Me.Label2.Text = "Accessing a nonexistent column will cause an exception"
      Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(60, 40)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(144, 32)
      Me.Label1.TabIndex = 2
      Me.Label1.Text = "Incorrect ADO.NET code will cause an exception"
      Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnADO2
      '
      Me.btnADO2.Location = New System.Drawing.Point(72, 104)
      Me.btnADO2.Name = "btnADO2"
      Me.btnADO2.Size = New System.Drawing.Size(128, 23)
      Me.btnADO2.TabIndex = 1
      Me.btnADO2.Text = "ADO.NET Exception 2"
      '
      'btnADO1
      '
      Me.btnADO1.Location = New System.Drawing.Point(68, 16)
      Me.btnADO1.Name = "btnADO1"
      Me.btnADO1.Size = New System.Drawing.Size(128, 23)
      Me.btnADO1.TabIndex = 0
      Me.btnADO1.Text = "ADO.NET Exception 1"
      '
      'TabPage2
      '
      Me.TabPage2.Controls.Add(Me.Label5)
      Me.TabPage2.Controls.Add(Me.Label4)
      Me.TabPage2.Controls.Add(Me.Label3)
      Me.TabPage2.Controls.Add(Me.btnDB3)
      Me.TabPage2.Controls.Add(Me.btnDB2)
      Me.TabPage2.Controls.Add(Me.btnDB1)
      Me.TabPage2.Location = New System.Drawing.Point(4, 22)
      Me.TabPage2.Name = "TabPage2"
      Me.TabPage2.Size = New System.Drawing.Size(264, 230)
      Me.TabPage2.TabIndex = 1
      Me.TabPage2.Text = "Database"
      '
      'Label5
      '
      Me.Label5.Location = New System.Drawing.Point(48, 192)
      Me.Label5.Name = "Label5"
      Me.Label5.Size = New System.Drawing.Size(168, 23)
      Me.Label5.TabIndex = 5
      Me.Label5.Text = "Multiple SqlError objects created"
      '
      'Label4
      '
      Me.Label4.Location = New System.Drawing.Point(4, 120)
      Me.Label4.Name = "Label4"
      Me.Label4.Size = New System.Drawing.Size(256, 23)
      Me.Label4.TabIndex = 4
      Me.Label4.Text = "Calls a stored procedure that encounters an error"
      '
      'Label3
      '
      Me.Label3.Location = New System.Drawing.Point(8, 48)
      Me.Label3.Name = "Label3"
      Me.Label3.Size = New System.Drawing.Size(248, 23)
      Me.Label3.TabIndex = 3
      Me.Label3.Text = "Calls a stored procedure that uses RAISERROR"
      '
      'btnDB3
      '
      Me.btnDB3.Location = New System.Drawing.Point(24, 156)
      Me.btnDB3.Name = "btnDB3"
      Me.btnDB3.Size = New System.Drawing.Size(216, 23)
      Me.btnDB3.TabIndex = 2
      Me.btnDB3.Text = "Database Exception 3 (Error Collection)"
      '
      'btnDB2
      '
      Me.btnDB2.Location = New System.Drawing.Point(40, 84)
      Me.btnDB2.Name = "btnDB2"
      Me.btnDB2.Size = New System.Drawing.Size(184, 23)
      Me.btnDB2.TabIndex = 1
      Me.btnDB2.Text = "Database Exception 2 (SP Error)"
      '
      'btnDB1
      '
      Me.btnDB1.Location = New System.Drawing.Point(32, 12)
      Me.btnDB1.Name = "btnDB1"
      Me.btnDB1.Size = New System.Drawing.Size(201, 23)
      Me.btnDB1.TabIndex = 0
      Me.btnDB1.Text = "Database Exception 1 (RAISERROR)"
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(292, 273)
      Me.Controls.Add(Me.TabControl1)
      Me.Name = "Form1"
      Me.Text = "ADO .NET Exceptions"
      Me.TabControl1.ResumeLayout(False)
      Me.TabPage1.ResumeLayout(False)
      Me.TabPage2.ResumeLayout(False)
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnADO1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnADO1.Click

      ' Create SqlCommand Object
      Dim thisCommand As SqlCommand = SqlConnection1.CreateCommand()

      ' Specify that the command is a stored procedure
      thisCommand.CommandType = CommandType.StoredProcedure

      ' Deliberately fail to specify the procedure
      ' thisCommand.CommandText = "Select_AllEmployees"

      Try
         ' Open connection
         SqlConnection1.Open()

         ' Run command and get data as a reader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Close reader
         thisReader.Close()
      Catch ex As System.Data.SqlClient.SqlException
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "Database Exception")
      Catch ex As System.Exception
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "Non-Database Exception")
      Finally
         If SqlConnection1.State = ConnectionState.Open Then
            MessageBox.Show("Finally block closing the connection", "Finally")
            SqlConnection1.Close()
         End If
      End Try
   End Sub

   Private Sub btnADO2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnADO2.Click
      ' Create SqlCommand Object
      Dim thisCommand As SqlCommand = SqlConnection1.CreateCommand()
      thisCommand.CommandType = CommandType.StoredProcedure
      thisCommand.CommandText = "Select_NoEmployees"

      Try
         ' Open connection
         SqlConnection1.Open()

         ' Run command and get data as a reader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Access non-existent column
         Dim str As String = thisReader.GetValue(20).ToString()

         ' Close data reader
         thisReader.Close()

      Catch ex As System.InvalidOperationException
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         str &= ControlChars.NewLine
         str &= "Stack Trace : " & ex.StackTrace
         MessageBox.Show(str, "Specific Exception")

      Catch ex As System.Data.SqlClient.SqlException
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "Database Exception")

      Catch ex As System.Exception
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "Generic Exception")

      Finally
         If SqlConnection1.State = ConnectionState.Open Then
            MessageBox.Show("Finally block closing the connection", "Finally")
            SqlConnection1.Close()
         End If
      End Try

   End Sub

   Private Sub btnDB1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDB1.Click
      ' Create SqlCommand Object
      Dim thisCommand As SqlCommand = SqlConnection1.CreateCommand()
      thisCommand.CommandType = CommandType.StoredProcedure
      thisCommand.CommandText = "DbException_1"

      Try
         ' Open connection
         SqlConnection1.Open()

         ' Run stored procedure
         thisCommand.ExecuteNonQuery()

      Catch ex As System.Data.SqlClient.SqlException
         Dim str As String
         str = "Source : " & ex.Source & ControlChars.NewLine
         str &= "Number : " & ex.Number & ControlChars.NewLine
         str &= "Message : " & ex.Message & ControlChars.NewLine
         str &= "Class : " & ex.Class.ToString() & ControlChars.NewLine
         str &= "Procedure : " & ex.Procedure & ControlChars.NewLine
         str &= "Line number : " & ex.LineNumber.ToString() & ControlChars.NewLine
         str &= "Server : " & ex.Server
         MessageBox.Show(str, "Database Exception")

      Catch ex As System.Exception
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "General Exception")

      Finally
         If SqlConnection1.State = ConnectionState.Open Then
            MessageBox.Show("Finally block closing the connection", "Finally")
            SqlConnection1.Close()
         End If
      End Try
   End Sub

   Private Sub btnDB2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDB2.Click
      ' Create SqlCommand Object
      Dim thisCommand As SqlCommand = SqlConnection1.CreateCommand()
      thisCommand.CommandType = CommandType.StoredProcedure
      thisCommand.CommandText = "DbException_2"

      Try
         ' Open connection
         SqlConnection1.Open()

         ' Run stored procedure
         thisCommand.ExecuteNonQuery()

      Catch ex As System.Data.SqlClient.SqlException
         Dim str As String
         str = "Source : " & ex.Source & ControlChars.NewLine
         str &= "Number : " & ex.Number & ControlChars.NewLine
         str &= "Message : " & ex.Message & ControlChars.NewLine
         str &= "Class : " & ex.Class.ToString() & ControlChars.NewLine
         str &= "Procedure : " & ex.Procedure & ControlChars.NewLine
         str &= "Line number : " & ex.LineNumber.ToString() & ControlChars.NewLine
         str &= "Server : " & ex.Server
         MessageBox.Show(str, "Database Exception")

      Catch ex As System.Exception
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "General Exception")

      Finally
         If SqlConnection1.State = ConnectionState.Open Then
            MessageBox.Show("Finally block closing the connection", "Finally")
            SqlConnection1.Close()
         End If
      End Try
   End Sub

   Private Sub btnDB3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDB3.Click
      ' Mistype connection string
      Dim connString As String = "integrated security=SSPI;data source=(local)\NetSDK;initial catalog=Northwnd"

      ' Create Connection
      Dim thisConnection As New SqlConnection(connString)

      ' Create command
      Dim thisCommand As SqlCommand = thisConnection.CreateCommand()
      thisCommand.CommandType = CommandType.StoredProcedure
      thisCommand.CommandText = "DBException_2"

      Try
         ' Open connection
         thisConnection.Open()

         ' Run stored procedure
         thisCommand.ExecuteNonQuery()

      Catch ex As System.Data.SqlClient.SqlException
         Dim str As String = ""
         For i As Integer = 0 To ex.Errors.Count - 1
            str &= ControlChars.NewLine & "Index #" & i & ControlChars.NewLine
            str &= "Exception : " & ex.Errors(i).ToString() & ControlChars.NewLine
            str &= "Number : " & ex.Errors(i).Number.ToString() & ControlChars.NewLine
         Next
         MessageBox.Show(str, "Database Exception")

      Catch ex As System.Exception
         Dim str As String
         str = "Source : " & ex.Source
         str &= ControlChars.NewLine
         str &= "Exception Message : " & ex.Message
         MessageBox.Show(str, "General Exception")

      Finally
         If thisConnection.State = ConnectionState.Open Then
            MessageBox.Show("Finally block closing the connection", "Finally")
            thisConnection.Close()
         End If
      End Try
   End Sub
End Class
