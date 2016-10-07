Imports System
Imports System.Data
Imports System.Data.OleDb

Module CommandOleDbQuery

   Sub Main()
      'Create Connection object
      Dim thisConnection As New OleDbConnection _
         ("Provider=Microsoft.Jet.OLEDB.4.0;" & _
          "Data Source=C:\BegVbNetDb\northwind.mdb")

      'Create Command object
      Dim thisCommand As New OleDbCommand _
         ("SELECT ProductID, ProductName FROM Products", _
          thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As OleDbDataReader = thisCommand.ExecuteReader()

         While (thisReader.Read())
            Console.WriteLine("Product: {0} {1}", _
               thisReader.GetValue(0), thisReader.GetValue(1))
         End While

      Catch ex As OleDbException
         ' Display error
         Console.WriteLine("Error: " & ex.ToString())
      Finally
         ' Close Connection
         thisConnection.Close()
         Console.WriteLine("Connection Closed")
      End Try
   End Sub
End Module
