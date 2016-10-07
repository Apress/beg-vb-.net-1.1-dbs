Imports System
Imports System.Data
Imports System.Data.OleDb

Module AccessConnect

   Sub Main()
      'Connection string
      Dim connString As String = _
         "provider= microsoft.jet.oledb.4.0; " & _
         "data source=c:\begvbnetdb\northwind.mdb;"

      'Create connection
      Dim conn As New OleDbConnection(connString)

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

      Catch ex As OleDbException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         conn.Close()
         Console.WriteLine("Connection Closed")

      End Try

   End Sub

End Module
