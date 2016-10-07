Imports System
Imports System.Data
Imports System.Data.Odbc

Module CommandOdbcExample

   Sub Main()
      'Create Connection object
      Dim thisConnection As New OdbcConnection _
         ("dsn=NorthwindOdbc")

      'Create Command object
      Dim nonqueryCommand As OdbcCommand = _
         thisConnection.CreateCommand()

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute NonQuery To Create Table
         nonqueryCommand.CommandText = _
            "CREATE TABLE MyTable " & _
            "(MyName VARCHAR (30), MyNumber integer)"
         Console.WriteLine("Executing {0}", _
            nonqueryCommand.CommandText)
         Console.WriteLine("Number of rows affected : {0}", _
            nonqueryCommand.ExecuteNonQuery())

         ' Create INSERT statement with ? unnamed parameters
         nonqueryCommand.CommandText = _
            "INSERT INTO MyTable VALUES (?, ?)"

         ' Add Parameters to Command Parameters collection
         nonqueryCommand.Parameters.Add("@MyName", OdbcType.VarChar, 30)
         nonqueryCommand.Parameters.Add("@MyNumber", OdbcType.Int)

         ' Prepare command not supported in ODBC
         ' nonqueryCommand.Prepare()

         ' Data to be inserted
         Dim names() As String = {"Zach", "Sarah", "John", "Donald"}
         For i As Integer = 1 To 4
            nonqueryCommand.Parameters("@MyName").Value = names(i - 1)
            nonqueryCommand.Parameters("@MyNumber").Value = i
            Console.WriteLine("Executing {0}", _
               nonqueryCommand.CommandText)
            Console.WriteLine("Number of rows affected : {0}", _
               nonqueryCommand.ExecuteNonQuery())
         Next i

         ' Check to see the data we inserted
         nonqueryCommand.CommandText = _
            "SELECT MyName, MyNumber FROM MyTable"
         Dim thisReader As OdbcDataReader = nonqueryCommand.ExecuteReader()

         While (thisReader.Read())
            Console.WriteLine("Name and Number: {0} {1}", _
               thisReader.GetValue(0), thisReader.GetValue(1))
         End While

         ' Close the reader so we can execute another command
         thisReader.Close()

         ' Drop Temporary table
         nonqueryCommand.CommandText = "DROP TABLE MyTable"
         nonqueryCommand.ExecuteNonQuery()

      Catch ex As OdbcException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         thisConnection.Close()
         Console.WriteLine("Connection Closed")

      End Try
   End Sub
End Module

