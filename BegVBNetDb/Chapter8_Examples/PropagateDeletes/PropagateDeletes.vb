Imports System
Imports System.Data
Imports System.Data.SqlClient

Module PropagateDeletes

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 
      Dim sql As String = _
         "SELECT * FROM Employees " & _
         "WHERE Country = 'Australia'"

      Dim deleteSql As String = _
         "DELETE FROM Employees " & _
         "WHERE EmployeeId = @employeeid"

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

         ' Delete Employees
         ' 1. Create Command
         Dim deleteCmd As New SqlCommand(deleteSql, thisConnection)

         ' 2. Map Parameters
         deleteCmd.Parameters.Add("@employeeid", _
            SqlDbType.Int, 4, "employeeid")

         ' 3. Select Employees
         Dim filter1 As String = _
            "firstname = 'Edna' and lastname = 'Everage'"

         ' 4. Delete Employees from local DataTable
         For Each row As DataRow In dt.Select(filter1)
            row.Delete()
         Next


         ' 5. Propagate deletions to database
         da.DeleteCommand = deleteCmd
         da.Update(ds, "employees")

         ' Display Rows After Alteration
         Console.WriteLine("=========")
         Console.WriteLine("After altering the dataset")
         For Each row As DataRow In dt.Rows
            Console.WriteLine("{0} | {1} | {2}", _
               row("FirstName").ToString().PadRight(10), _
               row("LastName").ToString().PadRight(10), _
               row("City"))
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

