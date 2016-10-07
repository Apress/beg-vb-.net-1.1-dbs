Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleScalar

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Create Command object
      Dim thisCommand As New SqlCommand _
         ("SELECT COUNT(*) FROM Employees", thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Console.WriteLine("Number of Employees : {0}", _
            thisCommand.ExecuteScalar())

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
