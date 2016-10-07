Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleParameters

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=tempdb")

      'Create Command object
      Dim nonqueryCommand As SqlCommand = _
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

         ' Create INSERT statement with named parameters
         nonqueryCommand.CommandText = _
            "INSERT INTO MyTable VALUES (@MyName, @MyNumber)"

         ' Add Parameters to Command Parameters collection
         nonqueryCommand.Parameters.Add("@MyName", SqlDbType.VarChar, 30)
         nonqueryCommand.Parameters.Add("@MyNumber", SqlDbType.Int)

         ' Prepare command for repeated execution
         nonqueryCommand.Prepare()

         ' Data to be inserted
         Dim names() As String = {"Zach", "Sarah", "John", "Donald"}
         For i As Integer = 0 To 3
            nonqueryCommand.Parameters("@MyName").Value = names(i)
            nonqueryCommand.Parameters("@MyNumber").Value = i
            Console.WriteLine("Executing {0}", _
               nonqueryCommand.CommandText)
            Console.WriteLine("Number of rows affected : {0}", _
               nonqueryCommand.ExecuteNonQuery())
         Next i

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

