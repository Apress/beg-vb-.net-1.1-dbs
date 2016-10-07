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
   Friend WithEvents ExecuteButton As System.Windows.Forms.Button
   Friend WithEvents SqlStatement As System.Windows.Forms.TextBox
   Friend WithEvents ResultBox As System.Windows.Forms.ListView
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.Label1 = New System.Windows.Forms.Label
      Me.Label2 = New System.Windows.Forms.Label
      Me.ExecuteButton = New System.Windows.Forms.Button
      Me.SqlStatement = New System.Windows.Forms.TextBox
      Me.ResultBox = New System.Windows.Forms.ListView
      Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
      Me.SuspendLayout()
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(112, 8)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(272, 23)
      Me.Label1.TabIndex = 0
      Me.Label1.Text = "Type a SQL Query below and press Go to execute it"
      '
      'Label2
      '
      Me.Label2.Location = New System.Drawing.Point(136, 192)
      Me.Label2.Name = "Label2"
      Me.Label2.Size = New System.Drawing.Size(224, 16)
      Me.Label2.TabIndex = 1
      Me.Label2.Text = "The data matching your query is as follows"
      '
      'ExecuteButton
      '
      Me.ExecuteButton.Location = New System.Drawing.Point(200, 152)
      Me.ExecuteButton.Name = "ExecuteButton"
      Me.ExecuteButton.TabIndex = 2
      Me.ExecuteButton.Text = "Go"
      '
      'SqlStatement
      '
      Me.SqlStatement.Location = New System.Drawing.Point(16, 32)
      Me.SqlStatement.Multiline = True
      Me.SqlStatement.Name = "SqlStatement"
      Me.SqlStatement.Size = New System.Drawing.Size(464, 104)
      Me.SqlStatement.TabIndex = 3
      Me.SqlStatement.Text = ""
      '
      'ResultBox
      '
      Me.ResultBox.GridLines = True
      Me.ResultBox.Location = New System.Drawing.Point(16, 216)
      Me.ResultBox.Name = "ResultBox"
      Me.ResultBox.Size = New System.Drawing.Size(464, 152)
      Me.ResultBox.TabIndex = 4
      Me.ResultBox.View = System.Windows.Forms.View.Details
      '
      'SqlConnection1
      '
      Me.SqlConnection1.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(496, 373)
      Me.Controls.Add(Me.ResultBox)
      Me.Controls.Add(Me.SqlStatement)
      Me.Controls.Add(Me.ExecuteButton)
      Me.Controls.Add(Me.Label2)
      Me.Controls.Add(Me.Label1)
      Me.Name = "Form1"
      Me.Text = "QueryProcessor"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub ExecuteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExecuteButton.Click
      ' Clear list view column headers and items
      ResultBox.Columns.Clear()
      ResultBox.Items.Clear()

      ' Get SQL Query from textbox
      Dim sql As String = SqlStatement.Text

      ' Create Command object
      Dim NewQuery As New SqlCommand(sql, SqlConnection1)

      Try
         ' Open Connection
         SqlConnection1.Open()

         ' Execute Command and Get Data 
         Dim NewReader As SqlDataReader = NewQuery.ExecuteReader()

         ' Get column names for list view from data reader
         For i As Integer = 0 To NewReader.FieldCount - 1
            Dim header As New ColumnHeader
            header.Text = NewReader.GetName(i)
            ResultBox.Columns.Add(header)
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
            ResultBox.Items.Add(NewItem)
         End While

         ' Close data reader
         NewReader.Close()

      Catch ex As SqlException
         ' Create and error column header
         Dim ErrorHeader As New ColumnHeader
         ErrorHeader.Text = "SQL Error"
         ResultBox.Columns.Add(ErrorHeader)

         ' Add Error List Item
         Dim ErrorItem As New ListViewItem(ex.Message)
         ResultBox.Items.Add(ErrorItem)

      Catch ex As Exception
         ' Create and error column header
         Dim ErrorHeader As New ColumnHeader
         ErrorHeader.Text = "Error"
         ResultBox.Columns.Add(ErrorHeader)

         ' Add Error List Item
         Dim ErrorItem As New ListViewItem("An error has occurred")
         ResultBox.Items.Add(ErrorItem)

      Finally

         SqlConnection1.Close()

      End Try
   End Sub
End Class
