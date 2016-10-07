Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleSql

   Sub Main()
      'Create Connection object
      Dim connString As String = "server=(local)\netsdk; " & _
         "integrated security=sspi;"
      Dim thisConnection As New SqlConnection(connString)

      'Create Command object
      Dim thisCommand As New SqlCommand
      Console.WriteLine("Command Created")

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Connect Command To Connection
         thisCommand.Connection = thisConnection

         ' Associate SQL with Command
         thisCommand.CommandText = "SELECT COUNT(*) FROM Employees"
         Console.WriteLine("Ready to execute : {0}", _
            thisCommand.CommandText)

      Catch ex As SqlException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         thisConnection.Close()
         Console.WriteLine("Connection Closed")

      End Try

   End Sub

End Module
