Imports System
Imports System.Data
Imports System.Data.SqlClient

Module PopDataSet

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Sql Query
      Dim sql As String = _
         "SELECT ProductName, UnitPrice " & _
         "FROM Products " & _
         "WHERE UnitPrice < 20"

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Create Data Adapter
         Dim da As New SqlDataAdapter(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "products")

         ' Get Data Table
         Dim dt As DataTable = ds.Tables("products")

         'Display Data
         For Each row As DataRow In dt.Rows
            For Each col As DataColumn In dt.Columns
               Console.WriteLine(row(col))
            Next
            Console.WriteLine("".PadLeft(20, "="))
         Next


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

