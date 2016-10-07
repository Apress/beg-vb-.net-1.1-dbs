Imports System
Imports System.Data
Imports System.Data.SqlClient

Module OrdinalIndexer

   Sub Main()
      'Create Connection object
      Dim thisConnection As New SqlConnection _
         ("server=(local)\netsdk;" & _
          "integrated security=sspi;" & _
          "database=northwind")

      'Create Command object
      Dim thisCommand As New SqlCommand _
         ("SELECT CompanyName, ContactName FROM Customers " & _
          "WHERE ContactName LIKE 'M%'", thisConnection)

      Try
         ' Open Connection
         thisConnection.Open()
         Console.WriteLine("Connection Opened")

         ' Execute Query
         Dim thisReader As SqlDataReader = thisCommand.ExecuteReader()

         Console.WriteLine("{0}  {1}", _
            "Company Name".PadLeft(25), _
            "Contact Name".PadLeft(25))

         While (thisReader.Read())
            Console.WriteLine("{0} | {1}", _
               thisReader("CompanyName").ToString().PadLeft(25), _
               thisReader("ContactName").ToString().PadLeft(25))
         End While

         'Close DataReader
         thisReader.Close()

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
