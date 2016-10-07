Imports System
Imports System.Data
Imports System.Data.SqlClient

Module FilterSort

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 1
      Dim sql1 As String = _
         "SELECT * FROM Customers "

      ' Sql Query 2
      Dim sql2 As String = _
         "SELECT * FROM Products " & _
         "WHERE UnitPrice < 10"

      ' Combine Queries
      Dim sql As String = sql1 & sql2

      Try
         ' Create Data Adapter
         Dim da As New SqlDataAdapter
         da.SelectCommand = New SqlCommand(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "customers")

         ' Get the Data Tables Collection
         Dim dtc As DataTableCollection = ds.Tables

         ' Get and Display First Data Table
         ' 1. Display header
         Console.WriteLine("Results From Customers Table")
         Console.WriteLine("CompanyName".PadRight(25) & _
            " | ContactName")

         ' 2. Set display filter
         Dim filter1 As String = "country = 'Germany'"

         ' 3. Set sort
         Dim sort1 As String = "companyname asc"

         ' 4. Display filtered and sorted data
         For Each row As DataRow In dtc("Customers").Select(filter1, sort1)
            Console.WriteLine("{0} | {1}", _
               row("CompanyName").ToString().PadRight(25), _
               row("ContactName"))
         Next

         ' Get and Display Second Data Table
         ' 1. Display header
         Console.WriteLine("========================")
         Console.WriteLine("Results from Products Table")
         Console.WriteLine("ProductName".PadRight(31) & _
            " | UnitPrice")

         ' 2. Display Data
         For Each row As DataRow In dtc(1).Rows
            Console.WriteLine("{0} | {1}", _
               row("ProductName").ToString().PadRight(31), _
               row("unitprice"))
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

