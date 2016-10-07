Imports System
Imports System.Data
Imports System.Data.Odbc

Module OdbcProvider
   Sub Main()
      ' Set up connection string
      Dim ConnString As String = "dsn=NorthwindOdbc"

      ' Set up query string
      Dim CmdString As String = "SELECT * FROM employees"

      'Declare Connection and DataReader variables
      Dim Conn As OdbcConnection
      Dim Reader As OdbcDataReader

      Try
         'Open Connection
         Conn = New OdbcConnection(ConnString)
         Conn.Open()

         'Execute Query
         Dim Cmd As New OdbcCommand(CmdString, Conn)
         Reader = Cmd.ExecuteReader()

         'Display output header
         Console.WriteLine("This program demonstrates the use " & _
            "of the Odbc Data Provider." & ControlChars.NewLine)
         Console.WriteLine("Querying database {0} with query {1}" & _
            ControlChars.NewLine, Conn.Database, Cmd.CommandText)
         Console.WriteLine("FirstName" & ControlChars.Tab & "LastName")

         'Process The Result Set
         While (Reader.Read())
            Console.WriteLine(Reader("FirstName").PadLeft(9) & _
               ControlChars.Tab & Reader(1))
         End While

      Catch ex As Exception
         Console.WriteLine("Error: {0}", ex)

      Finally
         'Close Connection
         Reader.Close()
         Conn.Close()

      End Try

   End Sub
End Module
