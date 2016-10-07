
Namespace DisplayImages
   Public Class Form1
      Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

      Public Sub New()
         MyBase.New()

         'This call is required by the Windows Form Designer.
         InitializeComponent()

         'Add any initialization after the InitializeComponent() call
         img = New Images

         If img.GetRow() Then
            Me.txtFileName.Text = img.GetFileName()
            Me.pbxImage.Image = CType(img.GetImage(), Image)
         Else
            Me.txtFileName.Text = "DONE"
            Me.pbxImage.Image = Nothing
         End If
      End Sub

      'Form overrides dispose to clean up the component list.
      Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
         img.EndImages()
         If disposing Then
            If Not (components Is Nothing) Then
               components.Dispose()
            End If
         End If
         MyBase.Dispose(disposing)
      End Sub

      'Required by the Windows Form Designer
      Private components As System.ComponentModel.IContainer

      'NOTE: The following procedure is required by the Windows Form Designer
      'It can be modified using the Windows Form Designer.  
      'Do not modify it using the code editor.
      Friend WithEvents pbxImage As System.Windows.Forms.PictureBox
      Friend WithEvents btnNext As System.Windows.Forms.Button
      Friend WithEvents txtFileName As System.Windows.Forms.TextBox
      <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
         Me.pbxImage = New System.Windows.Forms.PictureBox
         Me.btnNext = New System.Windows.Forms.Button
         Me.txtFileName = New System.Windows.Forms.TextBox
         Me.SuspendLayout()
         '
         'pbxImage
         '
         Me.pbxImage.Location = New System.Drawing.Point(8, 48)
         Me.pbxImage.Name = "pbxImage"
         Me.pbxImage.Size = New System.Drawing.Size(280, 216)
         Me.pbxImage.TabIndex = 0
         Me.pbxImage.TabStop = False
         '
         'btnNext
         '
         Me.btnNext.Location = New System.Drawing.Point(200, 16)
         Me.btnNext.Name = "btnNext"
         Me.btnNext.TabIndex = 1
         Me.btnNext.Text = "Next"
         '
         'txtFileName
         '
         Me.txtFileName.Location = New System.Drawing.Point(8, 16)
         Me.txtFileName.Name = "txtFileName"
         Me.txtFileName.Size = New System.Drawing.Size(160, 20)
         Me.txtFileName.TabIndex = 2
         Me.txtFileName.Text = ""
         '
         'Form1
         '
         Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
         Me.ClientSize = New System.Drawing.Size(292, 273)
         Me.Controls.Add(Me.txtFileName)
         Me.Controls.Add(Me.btnNext)
         Me.Controls.Add(Me.pbxImage)
         Me.Name = "Form1"
         Me.Text = "Display Images"
         Me.ResumeLayout(False)

      End Sub

#End Region

      Private img As images


      Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
         If img.GetRow() Then
            Me.txtFileName.Text = img.GetFileName()
            Me.pbxImage.Image = CType(img.GetImage(), Image)
         Else
            Me.txtFileName.Text = "DONE"
            Me.pbxImage.Image = Nothing
         End If
      End Sub
   End Class
End Namespace


