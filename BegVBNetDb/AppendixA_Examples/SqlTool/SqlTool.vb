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
   Friend WithEvents rtfSql As System.Windows.Forms.RichTextBox
   Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
   Friend WithEvents listViewResult As System.Windows.Forms.ListView
   Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
   Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
   Friend WithEvents menuItemExecute As System.Windows.Forms.MenuItem
   Friend WithEvents menuItemFormat As System.Windows.Forms.MenuItem
   Friend WithEvents MenuItem4 As System.Windows.Forms.MenuItem
   Friend WithEvents menuItemExit As System.Windows.Forms.MenuItem
   Friend WithEvents thisConnection As System.Data.SqlClient.SqlConnection
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.rtfSql = New System.Windows.Forms.RichTextBox
      Me.Splitter1 = New System.Windows.Forms.Splitter
      Me.listViewResult = New System.Windows.Forms.ListView
      Me.MainMenu1 = New System.Windows.Forms.MainMenu
      Me.MenuItem1 = New System.Windows.Forms.MenuItem
      Me.menuItemExecute = New System.Windows.Forms.MenuItem
      Me.menuItemFormat = New System.Windows.Forms.MenuItem
      Me.MenuItem4 = New System.Windows.Forms.MenuItem
      Me.menuItemExit = New System.Windows.Forms.MenuItem
      Me.thisConnection = New System.Data.SqlClient.SqlConnection
      Me.SuspendLayout()
      '
      'rtfSql
      '
      Me.rtfSql.Dock = System.Windows.Forms.DockStyle.Top
      Me.rtfSql.Font = New System.Drawing.Font("Courier New", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.rtfSql.Location = New System.Drawing.Point(0, 0)
      Me.rtfSql.Name = "rtfSql"
      Me.rtfSql.Size = New System.Drawing.Size(292, 120)
      Me.rtfSql.TabIndex = 0
      Me.rtfSql.Text = ""
      '
      'Splitter1
      '
      Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Top
      Me.Splitter1.Location = New System.Drawing.Point(0, 120)
      Me.Splitter1.Name = "Splitter1"
      Me.Splitter1.Size = New System.Drawing.Size(292, 3)
      Me.Splitter1.TabIndex = 1
      Me.Splitter1.TabStop = False
      '
      'listViewResult
      '
      Me.listViewResult.Dock = System.Windows.Forms.DockStyle.Fill
      Me.listViewResult.GridLines = True
      Me.listViewResult.Location = New System.Drawing.Point(0, 123)
      Me.listViewResult.Name = "listViewResult"
      Me.listViewResult.Size = New System.Drawing.Size(292, 150)
      Me.listViewResult.TabIndex = 2
      Me.listViewResult.View = System.Windows.Forms.View.Details
      '
      'MainMenu1
      '
      Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem1})
      '
      'MenuItem1
      '
      Me.MenuItem1.Index = 0
      Me.MenuItem1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.menuItemExecute, Me.menuItemFormat, Me.MenuItem4, Me.menuItemExit})
      Me.MenuItem1.Text = "&Actions"
      '
      'menuItemExecute
      '
      Me.menuItemExecute.Index = 0
      Me.menuItemExecute.Shortcut = System.Windows.Forms.Shortcut.F5
      Me.menuItemExecute.Text = "&Execute"
      '
      'menuItemFormat
      '
      Me.menuItemFormat.Index = 1
      Me.menuItemFormat.Shortcut = System.Windows.Forms.Shortcut.F12
      Me.menuItemFormat.Text = "&Format Statements"
      '
      'MenuItem4
      '
      Me.MenuItem4.Index = 2
      Me.MenuItem4.Text = "--"
      '
      'menuItemExit
      '
      Me.menuItemExit.Index = 3
      Me.menuItemExit.Text = "E&xit"
      '
      'thisConnection
      '
      Me.thisConnection.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(292, 273)
      Me.Controls.Add(Me.listViewResult)
      Me.Controls.Add(Me.Splitter1)
      Me.Controls.Add(Me.rtfSql)
      Me.Menu = Me.MainMenu1
      Me.Name = "Form1"
      Me.Text = "SqlTool"
      Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
      Me.ResumeLayout(False)

   End Sub

#End Region

   ' Global Application Variables
   Dim thisCommand As SqlCommand
   Dim SqlKeywords() As String = _
      {"select", "update", "insert", "into", "delete", "from", _
       "values", "truncate", "table", "join", "on", "where", _
       "create", "drop", "set", "in", "between", "is", "null", _
       "not", "Order by", "asc", "desc", "and"}

   Private Sub menuItemExecute_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles menuItemExecute.Click
      ' Get selected text
      Dim selectedText As String = rtfSql.SelectedText

      ' If no text is selected, use all text
      If selectedText.Length = 0 Then
         selectedText = rtfSql.Text
      End If

      ' If SELECT is in the text, treat it as a query
      If selectedText.ToLower().IndexOf("select", 0) >= 0 Then
         ExecuteSelect(selectedText)
      Else
         ExecuteNonQuery(selectedText)
      End If
   End Sub

   Sub ExecuteSelect(ByVal query As String)

      Dim first As Boolean = True
      Dim lvi As ListViewItem
      thisCommand = New SqlCommand(query, thisConnection)

      ' Clear List View
      listViewResult.Items.Clear()
      listViewResult.Columns.Clear()

      Try
         ' Open Connection
         thisConnection.Open()

         ' Execute Query and get data reader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Check data reader was returned
         If thisReader Is Nothing Then
            Return
         End If

         ' Reader valid so create columns in list view
         thisReader.Read()
         For i As Integer = 0 To thisReader.FieldCount - 1
            listViewResult.Columns.Add _
               (thisReader.GetName(i).ToString(), 100, _
                HorizontalAlignment.Left)
         Next

         ' Add rows in reader to listview
         Do
            For i As Integer = 0 To thisReader.FieldCount - 1
               If i = 0 Then
                  lvi = listViewResult.Items.Add(thisReader.GetValue(i).tostring())
               Else
                  lvi.SubItems.Add(thisReader.GetValue(i).tostring())
               End If
            Next
         Loop While thisReader.Read()

      Catch ex As Exception
         MessageBox.Show(ex.Message)

      Finally
         ' Close Connection
         thisConnection.Close()

      End Try
   End Sub

   Sub ExecuteNonQuery(ByVal sql As String)
      Dim rowsAffected As Integer = 0
      Dim lvi As ListViewItem
      thisCommand = New SqlCommand(sql, thisConnection)

      ' Clear List View
      listViewResult.Items.Clear()
      listViewResult.Columns.Clear()

      Try
         ' Open Connection
         thisConnection.Open()

         ' Execute the Statement
         rowsAffected = thisCommand.ExecuteNonQuery()

         ' Display the number of rows affected
         listViewResult.Columns.Add _
            ("Row Affected", -2, HorizontalAlignment.Left)
         lvi = listViewResult.Items.Add(rowsAffected.ToString())

      Catch ex As Exception
         MessageBox.Show(ex.Message)

      Finally
         ' Close connection
         thisConnection.Close()
      End Try
   End Sub

   Private Sub menuItemFormat_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles menuItemFormat.Click

      Dim NotFinishedWordSearch As Boolean

      ' Loop through each keyword in the array 
      For i As Integer = 0 To SqlKeywords.Length - 1

         ' Start word search for each keyword
         NotFinishedWordSearch = True

         ' Set start location in text for find routine
         Dim PositionInText As Integer = 0

         ' Check to see if keyword is in the SQL
         While NotFinishedWordSearch

            ' Obtain a location of the search string in richTextBox1.
            Dim indexToText As Integer = rtfSql.Find(SqlKeywords(i), PositionInText, RichTextBoxFinds.WholeWord)

            ' Determine whether the text was found
            If indexToText >= 0 Then

               ' If text foud highlight it and make it upper case
               rtfSql.SelectionColor = Color.Blue
               rtfSql.SelectedText = SqlKeywords(i).ToUpper()

               ' Move search start to next character
               PositionInText += 1
            Else
               ' If text not found , finish search for this word
               NotFinishedWordSearch = False
            End If
         End While
      Next
   End Sub

   Private Sub menuItemExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles menuItemExit.Click
      Application.Exit()
   End Sub
End Class
