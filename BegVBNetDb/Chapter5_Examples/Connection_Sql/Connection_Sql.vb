Imports System
Imports System.Data
Imports System.Data.SqlClient

Module Connection_Sql

   Sub Main()
      'Connection string
      Dim connString As String = "server=(local)\netsdk; " & _
         "integrated security=true;"

      'Create connection
      Dim conn As New SqlConnection(connString)

      Try
         ' Open Connection
         conn.Open()
         Console.WriteLine("Connection Opened")

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
