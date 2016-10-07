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
   Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents Label2 As System.Windows.Forms.Label
   Friend WithEvents cmdClose As System.Windows.Forms.Button
   Friend WithEvents cmQueryView As System.Windows.Forms.Button
   Friend WithEvents cmdCreateView As System.Windows.Forms.Button
   Friend WithEvents lvwViewRS As System.Windows.Forms.ListView
   Friend WithEvents txtSQL As System.Windows.Forms.TextBox
   Friend WithEvents txtCreateView As System.Windows.Forms.TextBox
   Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
   Friend WithEvents Label3 As System.Windows.Forms.Label
   Friend WithEvents lvwRS As System.Windows.Forms.ListView
   Friend WithEvents cmdNoInput As System.Windows.Forms.Button
   Friend WithEvents cmdInput As System.Windows.Forms.Button
   Friend WithEvents cmdReturn As System.Windows.Forms.Button
   Friend WithEvents txtEmployeeId1 As System.Windows.Forms.TextBox
   Friend WithEvents Label4 As System.Windows.Forms.Label
   Friend WithEvents Label5 As System.Windows.Forms.Label
   Friend WithEvents Label6 As System.Windows.Forms.Label
   Friend WithEvents cmdOutput As System.Windows.Forms.Button
   Friend WithEvents txtReturn As System.Windows.Forms.TextBox
   Friend WithEvents txtEmployeeId2 As System.Windows.Forms.TextBox
   Friend WithEvents txtEDate As System.Windows.Forms.TextBox
   Friend WithEvents txtLDate As System.Windows.Forms.TextBox
   Friend WithEvents cmdClear As System.Windows.Forms.Button
   Friend WithEvents Label7 As System.Windows.Forms.Label
   Friend WithEvents Label8 As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.TabControl1 = New System.Windows.Forms.TabControl
      Me.TabPage1 = New System.Windows.Forms.TabPage
      Me.txtCreateView = New System.Windows.Forms.TextBox
      Me.txtSQL = New System.Windows.Forms.TextBox
      Me.lvwViewRS = New System.Windows.Forms.ListView
      Me.cmdCreateView = New System.Windows.Forms.Button
      Me.cmQueryView = New System.Windows.Forms.Button
      Me.Label2 = New System.Windows.Forms.Label
      Me.Label1 = New System.Windows.Forms.Label
      Me.TabPage2 = New System.Windows.Forms.TabPage
      Me.cmdClose = New System.Windows.Forms.Button
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      Me.Label3 = New System.Windows.Forms.Label
      Me.lvwRS = New System.Windows.Forms.ListView
      Me.cmdNoInput = New System.Windows.Forms.Button
      Me.cmdInput = New System.Windows.Forms.Button
      Me.cmdReturn = New System.Windows.Forms.Button
      Me.cmdOutput = New System.Windows.Forms.Button
      Me.txtEmployeeId1 = New System.Windows.Forms.TextBox
      Me.txtReturn = New System.Windows.Forms.TextBox
      Me.txtEmployeeId2 = New System.Windows.Forms.TextBox
      Me.txtEDate = New System.Windows.Forms.TextBox
      Me.txtLDate = New System.Windows.Forms.TextBox
      Me.cmdClear = New System.Windows.Forms.Button
      Me.Label4 = New System.Windows.Forms.Label
      Me.Label5 = New System.Windows.Forms.Label
      Me.Label6 = New System.Windows.Forms.Label
      Me.Label7 = New System.Windows.Forms.Label
      Me.Label8 = New System.Windows.Forms.Label
      Me.TabControl1.SuspendLayout()
      Me.TabPage1.SuspendLayout()
      Me.TabPage2.SuspendLayout()
      Me.SuspendLayout()
      '
      'TabControl1
      '
      Me.TabControl1.Controls.Add(Me.TabPage1)
      Me.TabControl1.Controls.Add(Me.TabPage2)
      Me.TabControl1.Location = New System.Drawing.Point(0, 0)
      Me.TabControl1.Name = "TabControl1"
      Me.TabControl1.SelectedIndex = 0
      Me.TabControl1.Size = New System.Drawing.Size(488, 368)
      Me.TabControl1.TabIndex = 0
      '
      'TabPage1
      '
      Me.TabPage1.Controls.Add(Me.txtCreateView)
      Me.TabPage1.Controls.Add(Me.txtSQL)
      Me.TabPage1.Controls.Add(Me.lvwViewRS)
      Me.TabPage1.Controls.Add(Me.cmdCreateView)
      Me.TabPage1.Controls.Add(Me.cmQueryView)
      Me.TabPage1.Controls.Add(Me.Label2)
      Me.TabPage1.Controls.Add(Me.Label1)
      Me.TabPage1.Location = New System.Drawing.Point(4, 22)
      Me.TabPage1.Name = "TabPage1"
      Me.TabPage1.Size = New System.Drawing.Size(480, 342)
      Me.TabPage1.TabIndex = 0
      Me.TabPage1.Text = "Views"
      '
      'txtCreateView
      '
      Me.txtCreateView.Location = New System.Drawing.Point(16, 24)
      Me.txtCreateView.Multiline = True
      Me.txtCreateView.Name = "txtCreateView"
      Me.txtCreateView.Size = New System.Drawing.Size(448, 72)
      Me.txtCreateView.TabIndex = 6
      Me.txtCreateView.Text = ""
      '
      'txtSQL
      '
      Me.txtSQL.Location = New System.Drawing.Point(16, 160)
      Me.txtSQL.Multiline = True
      Me.txtSQL.Name = "txtSQL"
      Me.txtSQL.Size = New System.Drawing.Size(168, 128)
      Me.txtSQL.TabIndex = 5
      Me.txtSQL.Text = ""
      '
      'lvwViewRS
      '
      Me.lvwViewRS.GridLines = True
      Me.lvwViewRS.Location = New System.Drawing.Point(200, 144)
      Me.lvwViewRS.Name = "lvwViewRS"
      Me.lvwViewRS.Size = New System.Drawing.Size(264, 144)
      Me.lvwViewRS.TabIndex = 4
      Me.lvwViewRS.View = System.Windows.Forms.View.Details
      '
      'cmdCreateView
      '
      Me.cmdCreateView.Location = New System.Drawing.Point(203, 104)
      Me.cmdCreateView.Name = "cmdCreateView"
      Me.cmdCreateView.TabIndex = 3
      Me.cmdCreateView.Text = "Create View"
      '
      'cmQueryView
      '
      Me.cmQueryView.Location = New System.Drawing.Point(64, 296)
      Me.cmQueryView.Name = "cmQueryView"
      Me.cmQueryView.TabIndex = 2
      Me.cmQueryView.Text = "Run Query"
      '
      'Label2
      '
      Me.Label2.Location = New System.Drawing.Point(24, 144)
      Me.Label2.Name = "Label2"
      Me.Label2.Size = New System.Drawing.Size(152, 23)
      Me.Label2.TabIndex = 1
      Me.Label2.Text = "SQL Query Against A View"
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(168, 8)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(144, 23)
      Me.Label1.TabIndex = 0
      Me.Label1.Text = "CREATE VIEW Statement"
      '
      'TabPage2
      '
      Me.TabPage2.Controls.Add(Me.Label8)
      Me.TabPage2.Controls.Add(Me.Label7)
      Me.TabPage2.Controls.Add(Me.Label6)
      Me.TabPage2.Controls.Add(Me.Label5)
      Me.TabPage2.Controls.Add(Me.Label4)
      Me.TabPage2.Controls.Add(Me.cmdClear)
      Me.TabPage2.Controls.Add(Me.txtLDate)
      Me.TabPage2.Controls.Add(Me.txtEDate)
      Me.TabPage2.Controls.Add(Me.txtEmployeeId2)
      Me.TabPage2.Controls.Add(Me.txtReturn)
      Me.TabPage2.Controls.Add(Me.txtEmployeeId1)
      Me.TabPage2.Controls.Add(Me.cmdOutput)
      Me.TabPage2.Controls.Add(Me.cmdReturn)
      Me.TabPage2.Controls.Add(Me.cmdInput)
      Me.TabPage2.Controls.Add(Me.cmdNoInput)
      Me.TabPage2.Controls.Add(Me.lvwRS)
      Me.TabPage2.Controls.Add(Me.Label3)
      Me.TabPage2.Location = New System.Drawing.Point(4, 22)
      Me.TabPage2.Name = "TabPage2"
      Me.TabPage2.Size = New System.Drawing.Size(480, 342)
      Me.TabPage2.TabIndex = 1
      Me.TabPage2.Text = "Stored Procedures"
      '
      'cmdClose
      '
      Me.cmdClose.Location = New System.Drawing.Point(207, 376)
      Me.cmdClose.Name = "cmdClose"
      Me.cmdClose.TabIndex = 1
      Me.cmdClose.Text = "Close"
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Label3
      '
      Me.Label3.Location = New System.Drawing.Point(224, 8)
      Me.Label3.Name = "Label3"
      Me.Label3.Size = New System.Drawing.Size(48, 16)
      Me.Label3.TabIndex = 0
      Me.Label3.Text = "Result"
      '
      'lvwRS
      '
      Me.lvwRS.GridLines = True
      Me.lvwRS.Location = New System.Drawing.Point(224, 32)
      Me.lvwRS.Name = "lvwRS"
      Me.lvwRS.Size = New System.Drawing.Size(240, 208)
      Me.lvwRS.TabIndex = 1
      Me.lvwRS.View = System.Windows.Forms.View.Details
      '
      'cmdNoInput
      '
      Me.cmdNoInput.Location = New System.Drawing.Point(8, 88)
      Me.cmdNoInput.Name = "cmdNoInput"
      Me.cmdNoInput.Size = New System.Drawing.Size(112, 40)
      Me.cmdNoInput.TabIndex = 2
      Me.cmdNoInput.Text = "No Input"
      '
      'cmdInput
      '
      Me.cmdInput.Location = New System.Drawing.Point(8, 144)
      Me.cmdInput.Name = "cmdInput"
      Me.cmdInput.Size = New System.Drawing.Size(112, 40)
      Me.cmdInput.TabIndex = 3
      Me.cmdInput.Text = "Input = EmployeeID"
      '
      'cmdReturn
      '
      Me.cmdReturn.Location = New System.Drawing.Point(8, 200)
      Me.cmdReturn.Name = "cmdReturn"
      Me.cmdReturn.Size = New System.Drawing.Size(112, 40)
      Me.cmdReturn.TabIndex = 4
      Me.cmdReturn.Text = "No Input Return Values"
      '
      'cmdOutput
      '
      Me.cmdOutput.Location = New System.Drawing.Point(8, 256)
      Me.cmdOutput.Name = "cmdOutput"
      Me.cmdOutput.Size = New System.Drawing.Size(144, 48)
      Me.cmdOutput.TabIndex = 5
      Me.cmdOutput.Text = "Input = EmployeeID, Output = @Edate, @Ldate"
      '
      'txtEmployeeId1
      '
      Me.txtEmployeeId1.Location = New System.Drawing.Point(128, 160)
      Me.txtEmployeeId1.Name = "txtEmployeeId1"
      Me.txtEmployeeId1.Size = New System.Drawing.Size(80, 20)
      Me.txtEmployeeId1.TabIndex = 6
      Me.txtEmployeeId1.Text = ""
      '
      'txtReturn
      '
      Me.txtReturn.Location = New System.Drawing.Point(128, 216)
      Me.txtReturn.Name = "txtReturn"
      Me.txtReturn.Size = New System.Drawing.Size(80, 20)
      Me.txtReturn.TabIndex = 7
      Me.txtReturn.Text = ""
      '
      'txtEmployeeId2
      '
      Me.txtEmployeeId2.Location = New System.Drawing.Point(160, 288)
      Me.txtEmployeeId2.Name = "txtEmployeeId2"
      Me.txtEmployeeId2.TabIndex = 8
      Me.txtEmployeeId2.Text = ""
      '
      'txtEDate
      '
      Me.txtEDate.Location = New System.Drawing.Point(272, 288)
      Me.txtEDate.Name = "txtEDate"
      Me.txtEDate.Size = New System.Drawing.Size(88, 20)
      Me.txtEDate.TabIndex = 9
      Me.txtEDate.Text = ""
      '
      'txtLDate
      '
      Me.txtLDate.Location = New System.Drawing.Point(376, 288)
      Me.txtLDate.Name = "txtLDate"
      Me.txtLDate.Size = New System.Drawing.Size(88, 20)
      Me.txtLDate.TabIndex = 10
      Me.txtLDate.Text = ""
      '
      'cmdClear
      '
      Me.cmdClear.Location = New System.Drawing.Point(200, 312)
      Me.cmdClear.Name = "cmdClear"
      Me.cmdClear.Size = New System.Drawing.Size(80, 23)
      Me.cmdClear.TabIndex = 11
      Me.cmdClear.Text = "Clear Screen"
      '
      'Label4
      '
      Me.Label4.Location = New System.Drawing.Point(128, 200)
      Me.Label4.Name = "Label4"
      Me.Label4.Size = New System.Drawing.Size(48, 16)
      Me.Label4.TabIndex = 12
      Me.Label4.Text = "Return"
      '
      'Label5
      '
      Me.Label5.Location = New System.Drawing.Point(160, 272)
      Me.Label5.Name = "Label5"
      Me.Label5.Size = New System.Drawing.Size(100, 16)
      Me.Label5.TabIndex = 13
      Me.Label5.Text = "Input"
      '
      'Label6
      '
      Me.Label6.Location = New System.Drawing.Point(128, 144)
      Me.Label6.Name = "Label6"
      Me.Label6.Size = New System.Drawing.Size(32, 16)
      Me.Label6.TabIndex = 14
      Me.Label6.Text = "Input"
      '
      'Label7
      '
      Me.Label7.Location = New System.Drawing.Point(272, 256)
      Me.Label7.Name = "Label7"
      Me.Label7.Size = New System.Drawing.Size(104, 32)
      Me.Label7.TabIndex = 15
      Me.Label7.Text = "Earliest Order Date (@Edate)"
      '
      'Label8
      '
      Me.Label8.Location = New System.Drawing.Point(376, 256)
      Me.Label8.Name = "Label8"
      Me.Label8.Size = New System.Drawing.Size(100, 32)
      Me.Label8.TabIndex = 16
      Me.Label8.Text = "Latest Order Date (@Ldate)"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(488, 405)
      Me.Controls.Add(Me.cmdClose)
      Me.Controls.Add(Me.TabControl1)
      Me.Name = "Form1"
      Me.Text = "Views And Stored Procedures"
      Me.TabControl1.ResumeLayout(False)
      Me.TabPage1.ResumeLayout(False)
      Me.TabPage2.ResumeLayout(False)
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub cmdCreateView_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCreateView.Click

      ' Create Command
      Dim ViewCommand As New SqlCommand(txtCreateView.Text, SqlConnection1)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Run Create View Command
         ViewCommand.ExecuteNonQuery()

         ' Display success message
         MessageBox.Show("View was created successfully")

      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()
      End Try

   End Sub

   Private Sub cmQueryView_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmQueryView.Click

      ' Clear list view control
      lvwViewRS.Columns.Clear()
      lvwViewRS.Items.Clear()

      ' Create Command
      Dim QueryCommand As New SqlCommand(txtSQL.Text, SqlConnection1)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Get Data 
         Dim NewReader As SqlDataReader = QueryCommand.ExecuteReader()

         ' Get column names for list view from data reader
         For i As Integer = 0 To NewReader.FieldCount - 1
            Dim header As New ColumnHeader
            header.Text = NewReader.GetName(i)
            lvwViewRS.Columns.Add(header)
         Next

         ' Get rows of data and show in list view
         While NewReader.Read()
            ' Create list view item
            Dim NewItem As New ListViewItem

            ' Specify text and subitems of list view
            NewItem.Text = NewReader.GetValue(0).ToString()
            For i As Integer = 1 To NewReader.FieldCount - 1
               NewItem.SubItems.Add(NewReader.GetValue(i).ToString())
            Next

            ' Add item to list view items collection
            lvwViewRS.Items.Add(NewItem)
         End While

         ' Close data reader
         NewReader.Close()

      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()

      End Try
   End Sub

   Private Sub cmdReturn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdReturn.Click

      ' Create Command
      Dim ReturnCommand As SqlCommand = SqlConnection1.CreateCommand()
      ReturnCommand.CommandType = CommandType.StoredProcedure
      ReturnCommand.CommandText = "sp_Orders_MoreThan100"

      ' Create Return Parameter
      Dim ReturnParameter As SqlParameter = ReturnCommand.Parameters.Add("returnvalue", SqlDbType.Int)
      ReturnParameter.Direction = ParameterDirection.ReturnValue

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Display Return Value
         ReturnCommand.ExecuteScalar()
         txtReturn.Text = ReturnCommand.Parameters("returnvalue").Value.ToString()
      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()
      End Try
   End Sub

   Private Sub cmdNoInput_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdNoInput.Click

      ' Clear list view control
      lvwRS.Columns.Clear()
      lvwRS.Items.Clear()

      ' Create Command
      Dim NoInputCommand As SqlCommand = SqlConnection1.CreateCommand()
      NoInputCommand.CommandType = CommandType.StoredProcedure
      NoInputCommand.CommandText = "sp_Select_AllEmployees"

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Get Data 
         Dim NewReader As SqlDataReader = NoInputCommand.ExecuteReader()

         ' Get column names for list view from data reader
         For i As Integer = 0 To NewReader.FieldCount - 1
            Dim header As New ColumnHeader
            header.Text = NewReader.GetName(i)
            lvwRS.Columns.Add(header)
         Next

         ' Get rows of data and show in list view
         While NewReader.Read()
            ' Create list view item
            Dim NewItem As New ListViewItem

            ' Specify text and subitems of list view
            NewItem.Text = NewReader.GetValue(0).ToString()
            For i As Integer = 1 To NewReader.FieldCount - 1
               NewItem.SubItems.Add(NewReader.GetValue(i).ToString())
            Next

            ' Add item to list view items collection
            lvwRS.Items.Add(NewItem)
         End While

         ' Close data reader
         NewReader.Close()

      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()

      End Try

   End Sub

   Private Sub cmdInput_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdInput.Click

      ' Clear list view control
      lvwRS.Columns.Clear()
      lvwRS.Items.Clear()

      ' Create Command
      Dim OneInputCommand As SqlCommand = SqlConnection1.CreateCommand()
      OneInputCommand.CommandType = CommandType.StoredProcedure
      OneInputCommand.CommandText = "sp_Orders_ByEmployeeId"

      ' Create Input Parameter
      Dim InputParameter As SqlParameter = OneInputCommand.Parameters.Add("@employeeid", SqlDbType.Int)
      InputParameter.Direction = ParameterDirection.Input
      InputParameter.Value = CInt(txtEmployeeId1.Text)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Get Data 
         Dim NewReader As SqlDataReader = OneInputCommand.ExecuteReader()

         ' Get column names for list view from data reader
         For i As Integer = 0 To NewReader.FieldCount - 1
            Dim header As New ColumnHeader
            header.Text = NewReader.GetName(i)
            lvwRS.Columns.Add(header)
         Next

         ' Get rows of data and show in list view
         While NewReader.Read()
            ' Create list view item
            Dim NewItem As New ListViewItem

            ' Specify text and subitems of list view
            NewItem.Text = NewReader.GetValue(0).ToString()
            For i As Integer = 1 To NewReader.FieldCount - 1
               NewItem.SubItems.Add(NewReader.GetValue(i).ToString())
            Next

            ' Add item to list view items collection
            lvwRS.Items.Add(NewItem)
         End While

         ' Close data reader
         NewReader.Close()

      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()

      End Try

   End Sub

   Private Sub cmdOutput_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOutput.Click
      ' Create Command
      Dim OutputCommand As SqlCommand = SqlConnection1.CreateCommand()
      OutputCommand.CommandType = CommandType.StoredProcedure
      OutputCommand.CommandText = "sp_Dates_ByEmployeeId"

      ' Create Input Parameter
      Dim InputParameter As SqlParameter = OutputCommand.Parameters.Add("@employeeid", SqlDbType.Int)
      InputParameter.Direction = ParameterDirection.Input
      InputParameter.Value = CInt(txtEmployeeId2.Text)

      'Create Output Parameters
      Dim OutputParameter1 As SqlParameter = OutputCommand.Parameters.Add("@edate", SqlDbType.DateTime)
      OutputParameter1.Direction = ParameterDirection.Output
      Dim OutputParameter2 As SqlParameter = OutputCommand.Parameters.Add("@ldate", SqlDbType.DateTime)
      OutputParameter2.Direction = ParameterDirection.Output


      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Display Return Values
         OutputCommand.ExecuteNonQuery()
         txtEDate.Text = OutputParameter1.Value.ToString()
         txtLDate.Text = OutputParameter2.Value.ToString()

      Catch ex As SqlException
         ' Display error message
         MessageBox.Show("Could not create the view. " & _
            ex.Message)
      Catch ex As Exception
         ' Display error message
         MessageBox.Show("An application error occurred." & _
            ex.ToString())
      Finally
         ' Close Connection
         SqlConnection1.Close()
      End Try
   End Sub
End Class
