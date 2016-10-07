Imports System
Imports System.Data
Imports System.Data.SqlClient

Module ResultSetInfo

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Create Command object
      Dim thisCommand As New SqlCommand _
         ("SELECT ContactName, ContactTitle FROM Customers " & _
          "WHERE ContactName LIKE 'M%'", thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         ' Get column names
         Console.WriteLine("Column Names: {0} | {1}", _
            thisReader.GetName(0).PadLeft(11), _
            thisReader.GetName(1))

         ' Get column data types
         Console.WriteLine("Data types: {0} | {1}", _
            thisReader.GetDataTypeName(0).PadLeft(13), _
            thisReader.GetDataTypeName(1))

         Console.WriteLine()

         While (thisReader.Read())
            ' Get column values for all rows
            Console.WriteLine("{0} | {1}", _
               thisReader.GetString(0).PadLeft(25), _
               thisReader.GetString(1))
         End While

         ' Get number of columns
         Console.WriteLine()
         Console.WriteLine("Number of columns in a row: {0}", _
            thisReader.FieldCount)

         ' Get info about each column
         Console.WriteLine("'{0}' has index {1} and type {2}", _
            thisReader.GetName(0), _
            thisReader.GetOrdinal("ContactName"), _
            thisReader.GetFieldType(0))

         Console.WriteLine("'{0}' has index {1} and type {2}", _
            thisReader.GetName(1), _
            thisReader.GetOrdinal("ContactTitle"), _
            thisReader.GetFieldType(1))

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

