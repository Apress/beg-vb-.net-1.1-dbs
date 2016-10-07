Imports System.Data.SqlClient
Imports System.IO

Namespace LoadText
   Module LoadText

      ' Global Declarations
      Dim FileName As String = "C:\BegVBNetDb\Chapter21_Examples\LoadImages\LoadImages.vb"
      Dim thisConnection As SqlConnection
      Dim thisCommand As SqlCommand

      Sub Main()
         Try
            ' Get Text File
            GetTextFile(FileName)

            ' Open Connection
            OpenConnection()

            ' Build Command
            CreateCommand()

            ' Create Text Table
            CreateTextTable()

            ' Prepare insert command
            PrepareInsertTextFile()

            ' Load Text file
            ExecuteInsertTextFile(FileName)

            ' Display status
            Console.WriteLine("Loaded {0} into table", FileName)

         Catch ex As Exception
            Console.WriteLine(ex.ToString())

         Finally
            ' Close connection
            CloseConnection()
         End Try
      End Sub

      Sub OpenConnection()
         ' Create Connection object
         thisConnection = New SqlConnection _
            ("server=(local)\netsdk;" & _
             "integrated security=sspi;" & _
             "database=tempdb")

         ' Open Connection
         thisConnection.Open()
      End Sub

      Sub CloseConnection()
         ' Close connection
         thisConnection.Close()
         Console.WriteLine("Connection Closed")
      End Sub

      Sub CreateCommand()
         thisCommand = New SqlCommand
         thisCommand.Connection = thisConnection
      End Sub

      Sub ExecuteCommand(ByVal cmdText As String)
         thisCommand.CommandText = cmdText
         Console.WriteLine("Executing : " & thisCommand.CommandText)
         Dim result As Integer = thisCommand.ExecuteNonQuery()
         Console.WriteLine("ExecuteNonQuery returns {0}", result.ToString())
      End Sub

      Sub CreateTextTable()
         ExecuteCommand("IF EXISTS( " & _
            "SELECT table_name FROM information_schema.tables " & _
            "WHERE table_name = 'TextTable') " & _
            "DROP TABLE TextTable")

         ExecuteCommand("CREATE TABLE TextTable " & _
            "(TextFile varchar(255), TextData text)")
      End Sub

      Sub PrepareInsertTextFile()
         thisCommand.CommandText = "INSERT INTO TextTable " & _
            "VALUES (@TextFile, @TextData)"
         thisCommand.Parameters.Add("@TextFile", SqlDbType.NVarChar)
         thisCommand.Parameters.Add("@TextData", SqlDbType.Text)
      End Sub

      Sub ExecuteInsertTextFile(ByVal textFile As String)
         Dim textData As String = GetTextFile(textFile)
         thisCommand.Parameters("@TextFile").Value = textFile
         thisCommand.Parameters("@TextData").Value = textData
         ExecuteCommand(thisCommand.CommandText)
      End Sub

      Function GetTextFile(ByVal textFile As String) As String
         ' Display status
         Console.WriteLine("Loading file : {0}", textFile)

         ' Stream text into string
         Dim fs As New FileStream(textFile, FileMode.Open)
         Dim sr As New StreamReader(fs)
         Dim textBytes As String = sr.ReadToEnd()

         ' Display length of file
         Console.WriteLine("File has length {0} bytes", textBytes.Length.ToString())

         ' Close reader and stream
         sr.Close()
         fs.Close()

         Return textBytes
      End Function
   End Module
End Namespace

