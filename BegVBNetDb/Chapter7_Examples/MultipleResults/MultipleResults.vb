Imports System
Imports System.Data
Imports System.Data.SqlClient

Module MultipleResults

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Sql Query 1
      Dim sql1 As String = _
         "SELECT CompanyName, ContactName " & _
         "FROM Customers WHERE CompanyName LIKE 'A%'"

      'Sql Query 2
      Dim sql2 As String = _
         "SELECT firstname, lastname " & _
         "FROM Employees"

      'Combine queries
      Dim sql As String = sql1 & sql2

      'Create Command object
      Dim thisCommand As New SqlCommand _
         (sql, thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Loop through result sets
         Do
            ' Fetch Data
            While (thisReader.Read())
               Console.WriteLine("{0} | {1}", _
               thisReader(0), _
               thisReader(1))
            End While
            Console.WriteLine("".PadLeft(60, "="))
         Loop While (thisReader.NextResult())


         'Close DataReader
         thisReader.Close()

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


