Imports System
Imports System.Data
Imports System.Data.SqlClient

Module SchemaTable

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Sql Query
      Dim sql As String = _
         "SELECT * FROM Employees"

      'Create Command object
      Dim thisCommand As New SqlCommand _
         (sql, thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Get schema table for employees table
         Dim schema As DataTable = thisReader.GetSchemaTable()

         ' Display each row in the schema table
         ' Each row describes a column in the employees table
         For Each row As DataRow In schema.Rows
            For Each col As DataColumn In schema.Columns
               Console.WriteLine(col.ColumnName & " = " & row(col).ToString())
            Next
            Console.WriteLine("---------------")
         Next


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

