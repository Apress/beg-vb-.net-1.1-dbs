Imports System
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.Serialization.Formatters.Binary

Module WriteXML

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      ' Sql Query 
      Dim sql As String = _
         "SELECT * FROM Orders"

      ' Create file stream
      Dim fs As New FileStream _
         ("c:\begvbnetdb\chapter22_examples\orderstable.bin", _
           FileMode.Create)


      Try
         ' Create Data Adapter
         Dim da As New SqlDataAdapter
         da.SelectCommand = New SqlCommand(sql, thisConnection)

         ' Create and fill Dataset
         Dim ds As New DataSet
         da.Fill(ds, "orders")

         ' Extract DataSet to XML file
         ds.WriteXml("c:\begvbnetdb\chapter22_examples\orderstable.xml")

         ' Create binary formatter
         Dim bf As New BinaryFormatter()

         ' Specify binary serialization for dataset
         ds.RemotingFormat = SerializationFormat.Binary

         ' Output dataset
         bf.Serialize(fs, ds)

      Catch ex As SqlException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close filestream
         fs.Close()

         ' Close Connection
         thisConnection.Close()
         Console.WriteLine("Connection Closed")
      End Try
   End Sub
End Module

