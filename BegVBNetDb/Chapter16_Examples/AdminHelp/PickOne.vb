Imports System.Data.SqlClient

Namespace AdminForm
   Public Class PickOne
      Inherits System.Windows.Forms.Form

      Protected list As ArrayList = Nothing

#Region " Windows Form Designer generated code "

      Public Sub New()
         MyBase.New()

         'This call is required by the Windows Form Designer.
         InitializeComponent()

         'Add any initialization after the InitializeComponent() call

      End Sub

      'Form overrides dispose to clean up the component list.
      Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
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
      Friend WithEvents PickList As System.Windows.Forms.ComboBox
      Friend WithEvents btnOK As System.Windows.Forms.Button
      Friend WithEvents btnCancel As System.Windows.Forms.Button
      <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
         Me.PickList = New System.Windows.Forms.ComboBox
         Me.btnOK = New System.Windows.Forms.Button
         Me.btnCancel = New System.Windows.Forms.Button
         Me.SuspendLayout()
         '
         'PickList
         '
         Me.PickList.Location = New System.Drawing.Point(24, 16)
         Me.PickList.Name = "PickList"
         Me.PickList.Size = New System.Drawing.Size(248, 21)
         Me.PickList.TabIndex = 0
         '
         'btnOK
         '
         Me.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK
         Me.btnOK.Location = New System.Drawing.Point(48, 64)
         Me.btnOK.Name = "btnOK"
         Me.btnOK.TabIndex = 1
         Me.btnOK.Text = "&Ok"
         '
         'btnCancel
         '
         Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
         Me.btnCancel.Location = New System.Drawing.Point(152, 64)
         Me.btnCancel.Name = "btnCancel"
         Me.btnCancel.TabIndex = 2
         Me.btnCancel.Text = "&Cancel"
         '
         'PickOne
         '
         Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
         Me.ClientSize = New System.Drawing.Size(292, 93)
         Me.Controls.Add(Me.btnCancel)
         Me.Controls.Add(Me.btnOK)
         Me.Controls.Add(Me.PickList)
         Me.Name = "PickOne"
         Me.Text = "PickOne"
         Me.ResumeLayout(False)

      End Sub

#End Region

      Public Sub New(ByVal title As String)
         InitializeComponent()
         Me.Text = title
         list = New ArrayList
      End Sub

      Public Sub AppendListContents(ByVal dr As SqlDataReader, ByVal fieldName As String)
         While dr.Read()
            list.Add(dr(fieldName))
         End While
         PickList.DataSource = list
      End Sub

      Public Sub AppendListContents(ByVal items() As String)
         For i As Integer = 0 To items.Length - 1
            list.Add(items(i))
         Next
      End Sub

      Public ReadOnly Property Selected() As String
         Get
            Return PickList.SelectedItem.ToString()
         End Get
      End Property
   End Class
End Namespace


