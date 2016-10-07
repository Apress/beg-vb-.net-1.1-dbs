Imports System
Imports System.Data
Imports System.Data.SqlClient

Module PropagateChanges

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Select Query 
      Dim sql As String = _
         "SELECT * FROM Employees " & _
         "WHERE Country = 'UK'"

      ' Sql Update Statement
      Dim updateSql As String = _
         "UPDATE Employees " & _
         "SET City = @City " & _
         "WHERE EmployeeId = @EmployeeId"

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

         ' Modify city in first row
         dt.Rows(0)("City") = "Birmingham"

         ' Display Rows After Alteration
         Console.WriteLine("=========")
         Console.WriteLine("After altering the dataset")
         For Each row As DataRow In dt.Rows
            Console.WriteLine("{0} | {1} | {2}", _
               row("FirstName").ToString().PadRight(10), _
               row("LastName").ToString().PadRight(10), _
               row("City"))
         Next

         ' Update Employees
         ' 1. Create Command
         Dim UpdateCmd As New SqlCommand(updateSql, thisConnection)

         ' 2. Map Parameters
         ' 2.1 City
         UpdateCmd.Parameters.Add("@city", _
            SqlDbType.NVarChar, 15, "city")

         ' 2.2 EmployeeId
         Dim idParam As SqlParameter = _
            UpdateCmd.Parameters.Add("@employeeId", _
            SqlDbType.Int, 4, "employeeid")
         idParam.SourceVersion = DataRowVersion.Original

         ' Update employees
         da.UpdateCommand = UpdateCmd
         da.Update(ds, "employees")


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

