Imports System
Imports System.Data
Imports System.Data.SqlClient

Module WriteXML

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 
      Dim sql As String = _
         "SELECT ProductName, UnitPrice FROM Products"

      Try
         ' Create Data Adapter
         Dim da As New SqlDataAdapter
         da.SelectCommand = New SqlCommand(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "products")

         ' Extract DataSet to XML file
         ds.WriteXml("c:\begvbnetdb\chapter8_examples\productstable.xml")

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

