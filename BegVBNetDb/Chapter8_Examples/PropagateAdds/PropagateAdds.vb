Imports System
Imports System.Data
Imports System.Data.SqlClient

Module PropagateAdds

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

      Dim insertSql As String = _
         "INSERT INTO Employees " & _
         "(firstname, lastname, titleofcourtesy, city, country)" & _
         " VALUES " & _
         "(@firstname, @lastname, @titleofcourtesy, @city, @country)"

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

         ' Insert employees
         ' 1. Create command
         Dim insertCmd As New SqlCommand(insertSql, thisConnection)

         ' 2. Map parameters
         insertCmd.Parameters.Add("@firstname", _
            SqlDbType.NVarChar, 10, "firstname")
         insertCmd.Parameters.Add("@lastname", _
            SqlDbType.NVarChar, 20, "lastname")
         insertCmd.Parameters.Add("@titleofcourtesy", _
            SqlDbType.NVarChar, 25, "titleofcourtesy")
         insertCmd.Parameters.Add("@city", _
            SqlDbType.NVarChar, 15, "city")
         insertCmd.Parameters.Add("@country", _
            SqlDbType.NVarChar, 15, "country")

         ' 3. Insert employees
         da.InsertCommand = insertCmd
         da.Update(ds, "Employees")

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

