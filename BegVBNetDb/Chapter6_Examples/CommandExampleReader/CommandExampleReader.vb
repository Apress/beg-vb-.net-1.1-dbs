Imports System
Imports System.Data
Imports System.Data.SqlClient

Module CommandExampleReader

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Create Command object
      Dim thisCommand As New SqlCommand _
         ("SELECT FirstName, LastName FROM Employees", _
          thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         While (thisReader.Read())
            Console.WriteLine("Employee: {0} {1}", _
               thisReader.GetValue(0), thisReader.GetValue(1))
         End While

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
