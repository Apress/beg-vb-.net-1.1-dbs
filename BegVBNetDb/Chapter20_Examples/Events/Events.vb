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
   Friend WithEvents btnStateChange As System.Windows.Forms.Button
   Friend WithEvents btnInfoMessage As System.Windows.Forms.Button
   Friend WithEvents btnRowUpdating As System.Windows.Forms.Button
   Friend WithEvents btnMultiple As System.Windows.Forms.Button
   Friend WithEvents lbxEventLog As System.Windows.Forms.ListBox
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents thisConnection As System.Data.SqlClient.SqlConnection
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.thisConnection = New System.Data.SqlClient.SqlConnection
      Me.btnStateChange = New System.Windows.Forms.Button
      Me.btnInfoMessage = New System.Windows.Forms.Button
      Me.btnRowUpdating = New System.Windows.Forms.Button
      Me.btnMultiple = New System.Windows.Forms.Button
      Me.lbxEventLog = New System.Windows.Forms.ListBox
      Me.Label1 = New System.Windows.Forms.Label
      Me.SuspendLayout()
      '
      'thisConnection
      '
      Me.thisConnection.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'btnStateChange
      '
      Me.btnStateChange.Location = New System.Drawing.Point(16, 16)
      Me.btnStateChange.Name = "btnStateChange"
      Me.btnStateChange.Size = New System.Drawing.Size(112, 32)
      Me.btnStateChange.TabIndex = 0
      Me.btnStateChange.Text = "Connection StateChange Event"
      '
      'btnInfoMessage
      '
      Me.btnInfoMessage.Location = New System.Drawing.Point(16, 64)
      Me.btnInfoMessage.Name = "btnInfoMessage"
      Me.btnInfoMessage.Size = New System.Drawing.Size(112, 32)
      Me.btnInfoMessage.TabIndex = 1
      Me.btnInfoMessage.Text = "Connection InfoMessage Event"
      '
      'btnRowUpdating
      '
      Me.btnRowUpdating.Location = New System.Drawing.Point(16, 112)
      Me.btnRowUpdating.Name = "btnRowUpdating"
      Me.btnRowUpdating.Size = New System.Drawing.Size(112, 32)
      Me.btnRowUpdating.TabIndex = 2
      Me.btnRowUpdating.Text = "SqlDataAdapter RowUpdating Event"
      '
      'btnMultiple
      '
      Me.btnMultiple.Location = New System.Drawing.Point(16, 160)
      Me.btnMultiple.Name = "btnMultiple"
      Me.btnMultiple.Size = New System.Drawing.Size(112, 32)
      Me.btnMultiple.TabIndex = 3
      Me.btnMultiple.Text = "Multiple Handlers"
      '
      'lbxEventLog
      '
      Me.lbxEventLog.Location = New System.Drawing.Point(144, 40)
      Me.lbxEventLog.Name = "lbxEventLog"
      Me.lbxEventLog.Size = New System.Drawing.Size(248, 342)
      Me.lbxEventLog.TabIndex = 4
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(144, 16)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(56, 16)
      Me.Label1.TabIndex = 5
      Me.Label1.Text = "Event Log"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(400, 397)
      Me.Controls.Add(Me.Label1)
      Me.Controls.Add(Me.lbxEventLog)
      Me.Controls.Add(Me.btnMultiple)
      Me.Controls.Add(Me.btnRowUpdating)
      Me.Controls.Add(Me.btnInfoMessage)
      Me.Controls.Add(Me.btnStateChange)
      Me.Name = "Form1"
      Me.Text = "ADO.NET Event Demo"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnStateChange_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStateChange.Click
      ' Sql Query
      Dim sql As String = "SELECT TOP 1 " & _
         "CustomerId, CompanyName FROM Customers"

      ' Create command
      Dim thisCommand As New SqlCommand(sql, thisConnection)

      ' Clear event log
      lbxEventLog.Items.Clear()

      Try

         ' Open connection and fire statechange event
         thisConnection.Open()

         ' Create datareader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Display rows in event log
         While thisReader.Read()
            lbxEventLog.Items.Add(thisReader.GetString(0) _
               + "-" + thisReader.GetString(1))
         End While
      Catch ex As SqlException
         MessageBox.Show(ex.Message)
      Finally
         ' Close connection and fire StateChange event
         thisConnection.Close()
      End Try
   End Sub


   Private Sub StateIsChanged(ByVal sender As Object, ByVal e As System.Data.StateChangeEventArgs) Handles thisConnection.StateChange
      ' Event handler for the StateChange Event
      lbxEventLog.Items.Add("------------------------------")
      lbxEventLog.Items.Add("Entering StateChange EventHandler")
      lbxEventLog.Items.Add("Sender = " + sender.ToString())
      lbxEventLog.Items.Add("Original State = " + e.OriginalState.ToString())
      lbxEventLog.Items.Add("Current State = " + e.CurrentState.ToString())
      lbxEventLog.Items.Add("Exiting StateChange EventHandler")
      lbxEventLog.Items.Add("------------------------------")
   End Sub

   Private Sub btnInfoMessage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnInfoMessage.Click
      ' Sql Query
      Dim sql As String = "SELECT TOP 1 " & _
         "CustomerId, CompanyName FROM Customers"

      ' Create command
      Dim thisCommand As New SqlCommand(sql, thisConnection)

      ' Clear event log
      lbxEventLog.Items.Clear()
      Try


         ' Open connection and fire statechange event
         thisConnection.Open()

         ' Create datareader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Display rows in event log
         While thisReader.Read()
            lbxEventLog.Items.Add(thisReader.GetString(0) _
               + "-" + thisReader.GetString(1))
         End While

         ' Close data reader
         thisReader.Close()

         ' execute a PRINT statement
         thisCommand.CommandText = "PRINT 'GET first customer name and id'"
         thisCommand.ExecuteNonQuery()

      Catch ex As SqlException
         MessageBox.Show(ex.Message)

      Finally
         ' Close connection and fire StateChange event
         thisConnection.Close()
      End Try
   End Sub

   Private Sub PrintInfoMessage(ByVal sender As Object, ByVal e As System.Data.SqlClient.SqlInfoMessageEventArgs) Handles thisConnection.InfoMessage
      For Each err As SqlError In e.Errors
         lbxEventLog.Items.Add("------------------------------")
         lbxEventLog.Items.Add("Entering InfoMessage Event Handler")
         lbxEventLog.Items.Add("Source- " + err.Source.ToString())
         lbxEventLog.Items.Add("State- " + err.State.ToString())
         lbxEventLog.Items.Add("Number- " + err.Number.ToString())
         lbxEventLog.Items.Add("Procedure- " + err.Procedure)
         lbxEventLog.Items.Add("Server- " + err.Server)
         lbxEventLog.Items.Add("Message- " + err.Message)
         lbxEventLog.Items.Add("Exiting InfoMessage Event Handler")
         lbxEventLog.Items.Add("------------------------------")
      Next
   End Sub

   Private Sub btnRowUpdating_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRowUpdating.Click
      ' Sql Query
      Dim sql As String = "SELECT * FROM Customers"

      ' Clear event log
      lbxEventLog.Items.Clear()

      Try
         ' Open connection and fire statechange event
         thisConnection.Open()

         ' Create data adapter
         Dim thisAdapter As New SqlDataAdapter(sql, thisConnection)

         ' Create command builder
         Dim cb As New SqlCommandBuilder(thisAdapter)

         ' Create and fill dataset (only first row)
         Dim ds As New DataSet
         thisAdapter.Fill(ds, 0, 1, "Customers")

         ' Add Handlers
         AddHandler thisAdapter.RowUpdating, AddressOf OnRowUpdating
         AddHandler thisAdapter.RowUpdated, AddressOf OnRowUpdated

         ' Modify dataset
         Dim dt As DataTable = ds.Tables("Customers")
         dt.Rows(0)(1) = "The Volcano Corporation"

         ' Update. This fires both events
         thisAdapter.Update(ds, "Customers")

         ' Remove handlers
         RemoveHandler thisAdapter.RowUpdating, AddressOf OnRowUpdating
         RemoveHandler thisAdapter.RowUpdated, AddressOf OnRowUpdated

      Catch ex As SqlException
         MessageBox.Show(ex.Message)
      Finally
         ' Close Connection
         thisConnection.Close()
      End Try
   End Sub

   ' Handler for OnRowUpdating
   Private Sub OnRowUpdating(ByVal sender As Object, ByVal e As SqlRowUpdatingEventArgs)
      DisplayEventArgs(e)
   End Sub

   ' Handler for OnRowUpdated
   Private Sub OnRowUpdated(ByVal sender As Object, ByVal e As SqlRowUpdatedEventArgs)
      DisplayEventArgs(e)
   End Sub

   Private Sub DisplayEventArgs(ByVal args As SqlRowUpdatedEventArgs)
      lbxEventLog.Items.Add("OnRowUpdated Event")
      lbxEventLog.Items.Add("Records Affected = " & args.RecordsAffected.ToString())
   End Sub

   Private Sub DisplayEventArgs(ByVal args As SqlRowUpdatingEventArgs)
      lbxEventLog.Items.Add("OnRowUpdating Event")
      If Not args.Status = UpdateStatus.Continue Then
         lbxEventLog.Items.Add("RowStatus = " & args.Status.ToString())
      End If
   End Sub

   Private Sub btnMultiple_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMultiple.Click
      ' Sql Query
      Dim sql As String = "SELECT TOP 1 " & _
         "CustomerId, CompanyName FROM Customers"

      ' Create command
      Dim thisCommand As New SqlCommand(sql, thisConnection)

      ' Clear event log
      lbxEventLog.Items.Clear()

      ' Add second handler to StateChange event
      AddHandler thisConnection.StateChange, AddressOf StateIsChanged2

      Try

         ' Open connection and fire two statechange events
         thisConnection.Open()

         ' Create datareader
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Display rows in event log
         While thisReader.Read()
            lbxEventLog.Items.Add(thisReader.GetString(0) _
               + "-" + thisReader.GetString(1))
         End While
      Catch ex As SqlException
         MessageBox.Show(ex.Message)
      Finally
         ' Remove second handler from StateChange event
         RemoveHandler thisConnection.StateChange, AddressOf StateIsChanged2

         ' Close connection and fire one StateChange event
         thisConnection.Close()
      End Try
   End Sub

   Private Sub StateIsChanged2(ByVal sender As Object, ByVal e As System.Data.StateChangeEventArgs)
      ' Event handler for the StateChange Event
      lbxEventLog.Items.Add("------------------------------")
      lbxEventLog.Items.Add("Entering Second StateChange EventHandler")
      lbxEventLog.Items.Add("Sender = " + sender.ToString())
      lbxEventLog.Items.Add("Original State = " + e.OriginalState.ToString())
      lbxEventLog.Items.Add("Current State = " + e.CurrentState.ToString())
      lbxEventLog.Items.Add("Exiting Second StateChange EventHandler")
      lbxEventLog.Items.Add("------------------------------")
   End Sub
End Class
