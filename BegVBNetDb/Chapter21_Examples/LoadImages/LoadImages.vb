Imports System.IO
Imports System.Data.SqlClient

Namespace LoadImages

   Module LoadImages

      ' Module-wide variable
      Dim imageFileLocation As String = "C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\v1.1\QuickStart\aspplus\images\"
      Dim imageFilePrefix As String = "milk"
      Dim numberOfImageFiles As Integer = 8
      Dim imageFileType As String = ".gif"
      Dim maxImageSize As Integer = 10000
      Dim thisConnection As SqlConnection
      Dim thisCommand As SqlCommand

      Sub Main()
         Try
            ' Create and open connection
            OpenConnection()

            ' Create Command
            CreateCommand()

            ' Create Image Table
            CreateImageTable()

            ' Prepare To Insert Images
            PrepareInsertImages()

            ' Insert Images
            For i As Integer = 1 To numberOfImageFiles
               ExecuteInsertImage(i)
            Next

         Catch ex As Exception
            Console.WriteLine(ex.ToString())

         Finally
            ' Close Connection
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

      Sub CreateImageTable()
         ' Sql to create new table to hold images
         Dim sql As String = "CREATE TABLE ImageTable(ImageFile nvarchar(20), ImageData image)"

         ' Run command
         ExecuteCommand(sql)
      End Sub

      Sub PrepareInsertImages()
         thisCommand.CommandText = "INSERT INTO ImageTable VALUES (@ImageFile, @ImageData)"
         thisCommand.Parameters.Add("@ImageFile", SqlDbType.NVarChar)
         thisCommand.Parameters.Add("@ImageData", SqlDbType.Image)
      End Sub

      Sub ExecuteInsertImage(ByVal imageFileNumber As Integer)

         ' Get Filename and Image data
         Dim imageFileName As String = imageFilePrefix & imageFileNumber.ToString() & imageFileType
         Dim imageData() As Byte = LoadImageFile(imageFileName, imageFileLocation, maxImageSize)

         ' Set parameters
         thisCommand.Parameters("@ImageFile").Value = imageFileName
         thisCommand.Parameters("@ImageData").Value = imageData

         ' Run insert command
         ExecuteCommand(thisCommand.CommandText)
      End Sub

      Function LoadImageFile(ByVal fileName As String, ByVal fileLocation As String, ByVal maxImageSize As Integer) As Byte()

         ' Write state to console window
         Dim fullpath As String = fileLocation & fileName
         Console.WriteLine("Loading file: {0}", fullpath)

         ' Get binary reader to reader image data into variable
         Dim fs As New FileStream(fullpath, FileMode.Open)
         Dim br As New BinaryReader(fs)
         Dim imagebytes() As Byte = br.ReadBytes(maxImageSize)

         ' Write result to console window
         Console.WriteLine("Image has length {0} bytes", imagebytes.GetLength(0))

         Return imagebytes
      End Function


   End Module

End Namespace