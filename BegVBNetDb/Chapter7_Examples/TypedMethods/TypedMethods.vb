Imports System
Imports System.Data
Imports System.Data.SqlClient

Module TypedMethods

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Sql Query
      Dim sql As String = _
         "SELECT ProductName, UnitPrice, " & _
                "UnitsInStock, Discontinued " & _
         "FROM Products"

      'Create Command object
      Dim thisCommand As New SqlCommand _
         (sql, thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Fetch Data
         While (thisReader.Read())
            Console.WriteLine("{0} | {1} | {2} | {3}", _
            thisReader.GetString(0).PadLeft(32), _
            thisReader.GetDecimal(1), _
            thisReader.GetInt16(2), _
            thisReader.GetBoolean(3))
         End While

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

