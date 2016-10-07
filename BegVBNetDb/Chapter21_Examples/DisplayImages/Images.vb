Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Namespace DisplayImages
   Public Class Images

      ' Global declarations
      Dim imageFilename As String = ""
      Dim imageBytes() As Byte
      Dim imageConnection As SqlConnection
      Dim imageCommand As SqlCommand
      Dim imageReader As SqlDataReader

      Sub New()
         ' Create connection
         imageConnection = New SqlConnection _
            ("server=(local)\netsdk;" & _
             "integrated security=sspi;" & _
             "database=tempdb")

         ' Create command
         imageCommand = New SqlCommand _
            ("SELECT ImageFile, ImageData " & _
             "FROM ImageTable", imageConnection)

         ' open connection and create reader
         imageConnection.Open()
         imageReader = imageCommand.ExecuteReader()
      End Sub

      Function GetImage() As Bitmap
         Dim ms As New MemoryStream(imageBytes)
         Dim bmap As New Bitmap(ms)
         Return bmap
      End Function

      Function GetFileName() As String
         Return imageFilename
      End Function

      Function GetRow() As Boolean
         If imageReader.Read() Then
            imageFilename = imageReader.GetValue(0).ToString()
            imageBytes = CType(imageReader.GetValue(1), Byte())
            Return True
         Else
            Return False
         End If
      End Function

      Sub EndImages()
         ' Close reader and connection
         imageReader.Close()
         imageConnection.Close()
      End Sub
   End Class
End Namespace

