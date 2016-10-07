Imports System
Imports System.Data
Imports System.Data.SqlClient

Module DataViewExample

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query
      Dim sql As String = _
         "SELECT ContactName, Country " & _
         "FROM Customers"

      Try
         ' Create Data Adapter
         Dim da As New SqlDataAdapter
         da.SelectCommand = New SqlCommand(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "Customers")

         ' Get The Data Table
         Dim dt As DataTable = ds.Tables("Customers")

         ' Create Data View
         Dim dv As New DataView(dt, _
            "country = 'Germany'", _
            "country", DataViewRowState.CurrentRows)

         ' Display Data In Data View
         For Each row As DataRowView In dv
            For i As Integer = 0 To dv.Table.Columns.Count - 1
               Console.Write(row(i).PadRight(20))
            Next
            Console.WriteLine()
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

