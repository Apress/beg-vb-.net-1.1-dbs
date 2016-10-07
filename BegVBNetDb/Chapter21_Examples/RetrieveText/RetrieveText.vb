Imports System.Data.SqlClient

Namespace RetrieveText
   Module RetrieveText

      ' Global declarations
      Dim textFile As String
      Dim textChars() As Char
      Dim thisConnection As SqlConnection
      Dim thisCommand As SqlCommand
      Dim thisReader As SqlDataReader

      Sub Main()
         ' Create Connection object
         thisConnection = New SqlConnection _
            ("server=(local)\netsdk;" & _
             "integrated security=sspi;" & _
             "database=tempdb")

         ' Create Command object
         thisCommand = New SqlCommand _
            ("SELECT TextFile, TextData " & _
             "FROM TextTable", _
             thisConnection)

         Try
            ' Open Connection
            thisConnection.Open()

            ' Create data reader
            thisReader = thisCommand.ExecuteReader()

            While GetRow()
               Console.WriteLine("--- End of file {0} ", textFile)
            End While
         Catch ex As Exception
            Console.WriteLine(ex.ToString())

         Finally
            EndRetrieval()

         End Try
      End Sub

      Function GetRow() As Boolean
         Dim textSize As Long
         Dim bufferSize As Integer = 100
         Dim charsRead As Long
         Dim textChars(bufferSize) As Char

         If thisReader.Read() Then
            ' Get File Name
            textFile = thisReader.GetString(0)

            ' Display file info
            Console.WriteLine("--- Start of file {0} ", textFile)
            textSize = thisReader.GetChars(1, 0, Nothing, 0, 0)
            Console.WriteLine("--- Size of file : {0} chars", textSize)

            ' Display piece of file
            charsRead = thisReader.GetChars(1, 0, textChars, 0, 100)
            Console.WriteLine(New String(textChars))
            Console.WriteLine("--- Last 100 characters in text")
            charsRead = thisReader.GetChars(1, textSize - 100, textChars, 0, 100)
            Console.WriteLine(New String(textChars))

            Return True
         Else
            Return False
         End If
      End Function

      Sub EndRetrieval()
         ' Close Reader and Connection
         thisReader.Close()
         thisConnection.Close()
      End Sub
   End Module
End Namespace


