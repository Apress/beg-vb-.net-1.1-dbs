Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleNonQuery

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Create Command objects
      Dim scalarCommand As New SqlCommand _
         ("SELECT COUNT(*) FROM Employees", thisConnection)
      Dim nonqueryCommand As SqlCommand = _
         thisConnection.CreateCommand()

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Scalar Query
         Console.WriteLine("Before INSERT, Number of Employees = {0}", _
            scalarCommand.ExecuteScalar())

         ' Set up and execute INSERT Command
         nonqueryCommand.CommandText = _
            "INSERT INTO Employees (Firstname,Lastname) " & _
            "VALUES ('Aaron','Aardvark')"
         Console.WriteLine("Executing {0}", nonqueryCommand.CommandText)
         Console.WriteLine("Number of rows affected : {0}", _
            nonqueryCommand.ExecuteNonQuery())

         ' Execute Scalar Query Again
         Console.WriteLine("After INSERT, Number of Employees = {0}", _
            scalarCommand.ExecuteScalar())

         ' Set up and execute DELETE Command
         nonqueryCommand.CommandText = _
            "DELETE FROM Employees WHERE " & _
            "Firstname='Aaron' AND Lastname='Aardvark'"
         Console.WriteLine("Executing {0}", nonqueryCommand.CommandText)
         Console.WriteLine("Number of rows affected : {0}", _
            nonqueryCommand.ExecuteNonQuery())

         ' Execute Scalar Query Again
         Console.WriteLine("After DELETE, Number of Employees = {0}", _
            scalarCommand.ExecuteScalar())

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
