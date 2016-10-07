Imports System
Imports System.Data
Imports IBM.Data.DB2

Module Db2Connect

   Sub Main()
      'Connection string
      Dim connString As String = _
         "database = sample;"

      'Create connection
      Dim conn As New DB2Connection(connString)

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
         Console.WriteLine("- ServerVersion : {0}", _
            conn.ServerVersion)
         Console.WriteLine("- State : {0}", conn.State)

      Catch ex As DB2Exception
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         conn.Close()
         Console.WriteLine("Connection Closed")

      End Try

   End Sub

End Module