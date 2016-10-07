Imports System
Imports System.Data
Imports System.Data.OracleClient

Module OracleConnect

   Sub Main()
      'Connection string
      Dim connString As String = _
         "server = o92; " & _
         "uid = scott;" & _
         "password = tiger;"

      'Create connection
      Dim conn As New OracleConnection(connString)

      Try
         ' Open Connection
         conn.Open()
         Console.WriteLine("Connection Opened")

         ' Display connection properties
         Console.WriteLine("Connection Properties")
         Console.WriteLine("- ConnectionString : {0}", _
            conn.ConnectionString)
         Console.WriteLine("- ServerVersion : {0}", _
            conn.ServerVersion)
         Console.WriteLine("- State : {0}", conn.State)

      Catch ex As OracleException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         conn.Close()
         Console.WriteLine("Connection Closed")

      End Try

   End Sub

End Module
