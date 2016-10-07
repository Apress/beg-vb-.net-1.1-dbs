Imports System
Imports System.Data
Imports System.Data.SqlClient

Module Display

   Sub Main()
      'Connection string
      Dim connString As String = "server=(local)\netsdk; " & _
         "integrated security=sspi;"

      'Create connection
      Dim conn As New SqlConnection(connString)

      Try
         ' Open Connection
         conn.Open()
         Console.WriteLine("Connection Opened")

         ' Display connection properties
         Console.WriteLine("Connection Properties")
         Console.WriteLine("- ConnectionString : {0}", _
            conn.ConnectionString)
         Console.WriteLine("- Database : {0}", _
            conn.Database)
         Console.WriteLine("- DataSource : {0}", _
            conn.DataSource)
         Console.WriteLine("- ServerVersion : {0}", _
            conn.ServerVersion)
         Console.WriteLine("- State : {0}", conn.State)
         Console.WriteLine("- WorkstationId : {0}", _
            conn.WorkstationId)

      Catch ex As SqlException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         conn.Close()
         Console.WriteLine("Connection Closed")

      End Try

   End Sub

End Module
