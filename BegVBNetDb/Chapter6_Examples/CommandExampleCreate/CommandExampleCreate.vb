Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleCreate

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
            "CREATE TABLE MyTmpTable (COL1 integer)"
         Console.WriteLine("Executing {0}", _
            nonqueryCommand.CommandText)
         Console.WriteLine("Number of rows affected : {0}", _
            nonqueryCommand.ExecuteNonQuery())

         ' Execute NonQuery To Insert Data
         nonqueryCommand.CommandText = _
            "INSERT INTO MyTmpTable VALUES (37)"
         Console.WriteLine("Executing {0}", _
            nonqueryCommand.CommandText)
         Console.WriteLine("Number of rows affected : {0}", _
            nonqueryCommand.ExecuteNonQuery())

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
