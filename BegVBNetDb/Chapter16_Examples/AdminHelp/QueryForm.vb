Imports System.Data.SqlClient

Namespace AdminForm
   Public Class QueryForm
      Inherits System.Windows.Forms.Form

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
      Private WithEvents btnRefresh As System.Windows.Forms.Button
      Private WithEvents btnClose As System.Windows.Forms.Button
      Private WithEvents QueryPanel As System.Windows.Forms.Panel
      <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
         Me.QueryPanel = New System.Windows.Forms.Panel
         Me.btnRefresh = New System.Windows.Forms.Button
         Me.btnClose = New System.Windows.Forms.Button
         Me.SuspendLayout()
         '
         'QueryPanel
         '
         Me.QueryPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                     Or System.Windows.Forms.AnchorStyles.Left) _
                     Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
         Me.QueryPanel.AutoScroll = True
         Me.QueryPanel.Location = New System.Drawing.Point(8, 8)
         Me.QueryPanel.Name = "QueryPanel"
         Me.QueryPanel.Size = New System.Drawing.Size(528, 304)
         Me.QueryPanel.TabIndex = 0
         '
         'btnRefresh
         '
         Me.btnRefresh.Location = New System.Drawing.Point(199, 320)
         Me.btnRefresh.Name = "btnRefresh"
         Me.btnRefresh.TabIndex = 1
         Me.btnRefresh.Text = "&Refresh"
         '
         'btnClose
         '
         Me.btnClose.Location = New System.Drawing.Point(279, 320)
         Me.btnClose.Name = "btnClose"
         Me.btnClose.TabIndex = 2
         Me.btnClose.Text = "&Close"
         '
         'QueryForm
         '
         Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
         Me.ClientSize = New System.Drawing.Size(552, 349)
         Me.Controls.Add(Me.btnClose)
         Me.Controls.Add(Me.btnRefresh)
         Me.Controls.Add(Me.QueryPanel)
         Me.Name = "QueryForm"
         Me.Text = "QueryForm"
         Me.ResumeLayout(False)

      End Sub

#End Region

      Protected SqlCommand As SqlCommand

      Public Sub New(ByVal cmd As SqlCommand)
         InitializeComponent()
         Me.SqlCommand = cmd
         If cmd.Parameters.Count > 0 Then
            Me.Text = String.Format("{0} : {1}={2}", _
               cmd.CommandText, _
               cmd.Parameters(0).ParameterName, _
               cmd.Parameters(0).Value.ToString())
         Else
            Me.Text = cmd.CommandText
         End If
         RunQuery()
      End Sub

      Protected Sub RunQuery()
         ' Remove all controls from panel
         QueryPanel.Controls.Clear()

         ' Get data in dataset
         Dim da As New SqlDataAdapter(SqlCommand)
         Dim ds As New DataSet

         Try
            da.Fill(ds)
         Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
         End Try

         ' Controls are added to panel in an array
         Dim controls(ds.Tables.Count * 2) As Control

         For i As Integer = 0 To ds.Tables.Count - 1
            ' Create a gris for current resultset
            Dim grid As New DataGrid
            grid.DataSource = ds.Tables(i)
            grid.Dock = DockStyle.Fill
            grid.ReadOnly = True

            ' Panel to hold grid and scrollbars as applicable
            Dim panel As New Panel

            Dim niceHeight As Integer = ds.Tables(i).Rows.Count * 25 + 30
            If niceHeight < 100 Then
               niceHeight = 100
            End If
            panel.Height = niceHeight

            If Not i = ds.Tables.Count - 1 Then
               ' panel docks to top
               panel.Dock = DockStyle.Top
               controls((i * 2)) = panel

               ' splitter docks underneath panel
               Dim splitter As New Splitter
               splitter.Dock = DockStyle.Top
               controls((i * 2) + 1) = splitter
            Else
               ' last panel is set to fit remaining space
               panel.Dock = DockStyle.Fill
               controls((i * 2)) = panel

            End If

            ' Add datagrid into panel
            panel.AutoScroll = True
            SizeColumns(grid)
            panel.Controls.Add(grid)
         Next

         ' put all controls on page
         Array.Reverse(controls)
         QueryPanel.Controls.AddRange(controls)
      End Sub

      Protected Sub SizeColumns(ByVal grid As DataGrid)
         Dim g As Graphics = CreateGraphics()
         Dim dt As DataTable = CType(grid.DataSource, DataTable)
         Dim dgts As New DataGridTableStyle
         dgts.MappingName = dt.TableName

         For Each col As DataColumn In dt.Columns
            Dim maxSize As Integer = 0
            Dim size As SizeF = g.MeasureString(col.ColumnName, grid.Font)
            If size.Width > maxSize Then
               maxSize = CInt(size.Width)
            End If

            Dim dgcs As DataGridColumnStyle = New DataGridTextBoxColumn
            dgcs.MappingName = col.ColumnName
            dgcs.HeaderText = col.ColumnName
            dgcs.Width = maxSize + 5
            dgts.GridColumnStyles.Add(dgcs)
         Next

         grid.TableStyles.Add(dgts)
         g.Dispose()
      End Sub

      Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
         RunQuery()
      End Sub

      Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
         Me.Close()
      End Sub
   End Class

End Namespace

