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
   Friend WithEvents btnCommit As System.Windows.Forms.Button
   Friend WithEvents btnRollback As System.Windows.Forms.Button
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents txtOrderId As System.Windows.Forms.TextBox
   Friend WithEvents thisConnection As System.Data.SqlClient.SqlConnection
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.btnCommit = New System.Windows.Forms.Button
      Me.btnRollback = New System.Windows.Forms.Button
      Me.Label1 = New System.Windows.Forms.Label
      Me.txtOrderId = New System.Windows.Forms.TextBox
      Me.thisConnection = New System.Data.SqlClient.SqlConnection
      Me.SuspendLayout()
      '
      'btnCommit
      '
      Me.btnCommit.Location = New System.Drawing.Point(152, 48)
      Me.btnCommit.Name = "btnCommit"
      Me.btnCommit.Size = New System.Drawing.Size(112, 32)
      Me.btnCommit.TabIndex = 0
      Me.btnCommit.Text = "Delete Order (Commit)"
      '
      'btnRollback
      '
      Me.btnRollback.Location = New System.Drawing.Point(16, 48)
      Me.btnRollback.Name = "btnRollback"
      Me.btnRollback.Size = New System.Drawing.Size(120, 32)
      Me.btnRollback.TabIndex = 1
      Me.btnRollback.Text = "Delete Order (Rollback)"
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(16, 18)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(56, 16)
      Me.Label1.TabIndex = 2
      Me.Label1.Text = "OrderID :"
      '
      'txtOrderId
      '
      Me.txtOrderId.Location = New System.Drawing.Point(72, 16)
      Me.txtOrderId.Name = "txtOrderId"
      Me.txtOrderId.Size = New System.Drawing.Size(192, 20)
      Me.txtOrderId.TabIndex = 3
      Me.txtOrderId.Text = "TextBox1"
      '
      'thisConnection
      '
      Me.thisConnection.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(292, 101)
      Me.Controls.Add(Me.txtOrderId)
      Me.Controls.Add(Me.Label1)
      Me.Controls.Add(Me.btnRollback)
      Me.Controls.Add(Me.btnCommit)
      Me.Name = "Form1"
      Me.Text = "Transactions"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnRollback_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRollback.Click

      ' SQL Delete Command
      Dim sql As String = "DELETE FROM Orders " & _
         "WHERE OrderId = " & txtOrderId.Text

      ' Create command
      Dim thisCommand As New SqlCommand(sql, thisConnection)

      ' Create Transaction
      Dim thisTransaction As SqlTransaction

      Try
         ' Open Connection
         thisConnection.Open()

         ' Begin transaction and attach it to command
         thisTransaction = thisConnection.BeginTransaction()
         thisCommand.Transaction = thisTransaction

         ' Run delete command
         thisCommand.ExecuteNonQuery()

         ' Commit transaction
         thisTransaction.Commit()

         ' Display success
         MessageBox.Show("Transaction Committed. Data Deleted")

      Catch ex As Exception
         ' Roll back transaction
         thisTransaction.Rollback()

         MessageBox.Show("Transaction rolled back : " & ex.Message, "Error")

      Finally
         ' Close Connection
         thisConnection.Close()

      End Try
   End Sub

   Private Sub btnCommit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCommit.Click
      ' SQL Delete Commands
      Dim sql1 As String = "DELETE FROM [Order Details] " & _
         "WHERE OrderId = " & txtOrderId.Text

      Dim sql2 As String = "DELETE FROM Orders " & _
         "WHERE OrderId = " & txtOrderId.Text

      ' Create command
      Dim thisCommand As New SqlCommand(sql1, thisConnection)

      ' Create Transaction
      Dim thisTransaction As SqlTransaction

      Try
         ' Open Connection
         thisConnection.Open()

         ' Begin transaction and attach it to command
         thisTransaction = thisConnection.BeginTransaction()
         thisCommand.Transaction = thisTransaction

         ' Run first delete command
         thisCommand.ExecuteNonQuery()

         ' Setup and run second delete command
         thisCommand.CommandText = sql2
         thisCommand.ExecuteNonQuery()

         ' Commit transaction
         thisTransaction.Commit()

         ' Display success
         MessageBox.Show("Transaction Committed. Data Deleted")

      Catch ex As Exception
         ' Roll back transaction
         thisTransaction.Rollback()

         MessageBox.Show("Transaction rolled back : " & ex.Message, "Error")

      Finally
         ' Close Connection
         thisConnection.Close()

      End Try
   End Sub
End Class
