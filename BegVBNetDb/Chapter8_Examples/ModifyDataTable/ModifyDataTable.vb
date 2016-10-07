Imports System
Imports System.Data
Imports System.Data.SqlClient

Module ModifyDataTable

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 
      Dim sql As String = _
         "SELECT * FROM Employees " & _
         "WHERE Country = 'UK'"

      Try
         ' Create Data Adapter
         Dim da As New SqlDataAdapter
         da.SelectCommand = New SqlCommand(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "Employees")

         ' Get the Data Table
         Dim dt As DataTable = ds.Tables("Employees")

         ' Display Rows Before Changed
         Console.WriteLine("Before altering the dataset")
         For Each row As DataRow In dt.Rows
            Console.WriteLine("{0} | {1} | {2}", _
               row("FirstName").ToString().PadRight(10), _
               row("LastName").ToString().PadRight(10), _
               row("City"))
         Next

         ' FirstName column should be nullable
         dt.Columns("firstname").AllowDBNull = True

         ' Modify city in first row
         dt.Rows(0)("City") = "Birmingham"

         ' Add A Row
         Dim newRow As DataRow = dt.NewRow()
         newRow("firstname") = "Edna"
         newRow("lastname") = "Everage"
         newRow("titleofcourtesy") = "Dame"
         newRow("city") = "Sydney"
         newRow("country") = "Australia"
         dt.Rows.Add(newRow)

         ' Display Rows After Alteration
         Console.WriteLine("=========")
         Console.WriteLine("After altering the dataset")
         For Each row As DataRow In dt.Rows
            Console.WriteLine("{0} | {1} | {2}", _
               row("FirstName").ToString().PadRight(10), _
               row("LastName").ToString().PadRight(10), _
               row("City"))
         Next

         ' Code for updating the database would be here

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

