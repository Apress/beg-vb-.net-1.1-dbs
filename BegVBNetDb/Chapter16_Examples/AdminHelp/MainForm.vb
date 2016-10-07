Imports System.Data.SqlClient

Namespace AdminForm
   Public Class Form1
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
      Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
      Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
      Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
      Friend WithEvents btnViewLogins As System.Windows.Forms.Button
      Friend WithEvents btnValidateLogins As System.Windows.Forms.Button
      Friend WithEvents btnServerRoles As System.Windows.Forms.Button
      Friend WithEvents btnServerRoleMembers As System.Windows.Forms.Button
      Friend WithEvents btnServerRolePermissions As System.Windows.Forms.Button
      Friend WithEvents btnViewUsers As System.Windows.Forms.Button
      Friend WithEvents btnViewRoles As System.Windows.Forms.Button
      Friend WithEvents btnRoleMembers As System.Windows.Forms.Button
      Friend WithEvents btnFixedRoles As System.Windows.Forms.Button
      Friend WithEvents btnFixedRolePermissions As System.Windows.Forms.Button
      Friend WithEvents btnAllPermissions As System.Windows.Forms.Button
      Friend WithEvents btnPermissionsByUserRole As System.Windows.Forms.Button
      Friend WithEvents btnPermissionsByObject As System.Windows.Forms.Button
      Private WithEvents menuNew As System.Windows.Forms.MenuItem
      Private WithEvents menuExit As System.Windows.Forms.MenuItem
      Private WithEvents MenuItem1 As System.Windows.Forms.MenuItem
      Friend WithEvents thisConnection As System.Data.SqlClient.SqlConnection
      <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
         Me.MainMenu1 = New System.Windows.Forms.MainMenu
         Me.MenuItem1 = New System.Windows.Forms.MenuItem
         Me.menuNew = New System.Windows.Forms.MenuItem
         Me.menuExit = New System.Windows.Forms.MenuItem
         Me.GroupBox1 = New System.Windows.Forms.GroupBox
         Me.btnServerRolePermissions = New System.Windows.Forms.Button
         Me.btnServerRoleMembers = New System.Windows.Forms.Button
         Me.btnServerRoles = New System.Windows.Forms.Button
         Me.btnValidateLogins = New System.Windows.Forms.Button
         Me.btnViewLogins = New System.Windows.Forms.Button
         Me.GroupBox2 = New System.Windows.Forms.GroupBox
         Me.btnPermissionsByObject = New System.Windows.Forms.Button
         Me.btnPermissionsByUserRole = New System.Windows.Forms.Button
         Me.btnAllPermissions = New System.Windows.Forms.Button
         Me.btnFixedRolePermissions = New System.Windows.Forms.Button
         Me.btnFixedRoles = New System.Windows.Forms.Button
         Me.btnRoleMembers = New System.Windows.Forms.Button
         Me.btnViewRoles = New System.Windows.Forms.Button
         Me.btnViewUsers = New System.Windows.Forms.Button
         Me.thisConnection = New System.Data.SqlClient.SqlConnection
         Me.GroupBox1.SuspendLayout()
         Me.GroupBox2.SuspendLayout()
         Me.SuspendLayout()
         '
         'MainMenu1
         '
         Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem1})
         '
         'MenuItem1
         '
         Me.MenuItem1.Index = 0
         Me.MenuItem1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.menuNew, Me.menuExit})
         Me.MenuItem1.Text = "&File"
         '
         'menuNew
         '
         Me.menuNew.Index = 0
         Me.menuNew.Text = "&Connect to Database"
         '
         'menuExit
         '
         Me.menuExit.Index = 1
         Me.menuExit.Text = "&Exit"
         '
         'GroupBox1
         '
         Me.GroupBox1.Controls.Add(Me.btnServerRolePermissions)
         Me.GroupBox1.Controls.Add(Me.btnServerRoleMembers)
         Me.GroupBox1.Controls.Add(Me.btnServerRoles)
         Me.GroupBox1.Controls.Add(Me.btnValidateLogins)
         Me.GroupBox1.Controls.Add(Me.btnViewLogins)
         Me.GroupBox1.Location = New System.Drawing.Point(16, 16)
         Me.GroupBox1.Name = "GroupBox1"
         Me.GroupBox1.Size = New System.Drawing.Size(128, 280)
         Me.GroupBox1.TabIndex = 0
         Me.GroupBox1.TabStop = False
         Me.GroupBox1.Text = "Server Settings"
         '
         'btnServerRolePermissions
         '
         Me.btnServerRolePermissions.Location = New System.Drawing.Point(16, 232)
         Me.btnServerRolePermissions.Name = "btnServerRolePermissions"
         Me.btnServerRolePermissions.Size = New System.Drawing.Size(96, 32)
         Me.btnServerRolePermissions.TabIndex = 4
         Me.btnServerRolePermissions.Text = "Server Role Permissions"
         '
         'btnServerRoleMembers
         '
         Me.btnServerRoleMembers.Location = New System.Drawing.Point(16, 184)
         Me.btnServerRoleMembers.Name = "btnServerRoleMembers"
         Me.btnServerRoleMembers.Size = New System.Drawing.Size(96, 32)
         Me.btnServerRoleMembers.TabIndex = 3
         Me.btnServerRoleMembers.Text = "Server Role Members"
         '
         'btnServerRoles
         '
         Me.btnServerRoles.Location = New System.Drawing.Point(16, 136)
         Me.btnServerRoles.Name = "btnServerRoles"
         Me.btnServerRoles.Size = New System.Drawing.Size(96, 32)
         Me.btnServerRoles.TabIndex = 2
         Me.btnServerRoles.Text = "Server Roles"
         '
         'btnValidateLogins
         '
         Me.btnValidateLogins.Location = New System.Drawing.Point(16, 88)
         Me.btnValidateLogins.Name = "btnValidateLogins"
         Me.btnValidateLogins.Size = New System.Drawing.Size(96, 32)
         Me.btnValidateLogins.TabIndex = 1
         Me.btnValidateLogins.Text = "Validate Logins"
         '
         'btnViewLogins
         '
         Me.btnViewLogins.Location = New System.Drawing.Point(16, 40)
         Me.btnViewLogins.Name = "btnViewLogins"
         Me.btnViewLogins.Size = New System.Drawing.Size(96, 32)
         Me.btnViewLogins.TabIndex = 0
         Me.btnViewLogins.Text = "View Logins"
         '
         'GroupBox2
         '
         Me.GroupBox2.Controls.Add(Me.btnPermissionsByObject)
         Me.GroupBox2.Controls.Add(Me.btnPermissionsByUserRole)
         Me.GroupBox2.Controls.Add(Me.btnAllPermissions)
         Me.GroupBox2.Controls.Add(Me.btnFixedRolePermissions)
         Me.GroupBox2.Controls.Add(Me.btnFixedRoles)
         Me.GroupBox2.Controls.Add(Me.btnRoleMembers)
         Me.GroupBox2.Controls.Add(Me.btnViewRoles)
         Me.GroupBox2.Controls.Add(Me.btnViewUsers)
         Me.GroupBox2.Location = New System.Drawing.Point(160, 16)
         Me.GroupBox2.Name = "GroupBox2"
         Me.GroupBox2.Size = New System.Drawing.Size(240, 280)
         Me.GroupBox2.TabIndex = 1
         Me.GroupBox2.TabStop = False
         Me.GroupBox2.Text = "Database Settings"
         '
         'btnPermissionsByObject
         '
         Me.btnPermissionsByObject.Location = New System.Drawing.Point(128, 136)
         Me.btnPermissionsByObject.Name = "btnPermissionsByObject"
         Me.btnPermissionsByObject.Size = New System.Drawing.Size(96, 32)
         Me.btnPermissionsByObject.TabIndex = 7
         Me.btnPermissionsByObject.Text = "Permissions By Object"
         '
         'btnPermissionsByUserRole
         '
         Me.btnPermissionsByUserRole.Location = New System.Drawing.Point(128, 88)
         Me.btnPermissionsByUserRole.Name = "btnPermissionsByUserRole"
         Me.btnPermissionsByUserRole.Size = New System.Drawing.Size(96, 32)
         Me.btnPermissionsByUserRole.TabIndex = 6
         Me.btnPermissionsByUserRole.Text = "Permissions By User \ Role"
         '
         'btnAllPermissions
         '
         Me.btnAllPermissions.Location = New System.Drawing.Point(128, 40)
         Me.btnAllPermissions.Name = "btnAllPermissions"
         Me.btnAllPermissions.Size = New System.Drawing.Size(96, 32)
         Me.btnAllPermissions.TabIndex = 5
         Me.btnAllPermissions.Text = "All Permissions"
         '
         'btnFixedRolePermissions
         '
         Me.btnFixedRolePermissions.Location = New System.Drawing.Point(16, 232)
         Me.btnFixedRolePermissions.Name = "btnFixedRolePermissions"
         Me.btnFixedRolePermissions.Size = New System.Drawing.Size(96, 32)
         Me.btnFixedRolePermissions.TabIndex = 4
         Me.btnFixedRolePermissions.Text = "Fixed Role Permissions"
         '
         'btnFixedRoles
         '
         Me.btnFixedRoles.Location = New System.Drawing.Point(16, 184)
         Me.btnFixedRoles.Name = "btnFixedRoles"
         Me.btnFixedRoles.Size = New System.Drawing.Size(96, 32)
         Me.btnFixedRoles.TabIndex = 3
         Me.btnFixedRoles.Text = "Fixed Roles"
         '
         'btnRoleMembers
         '
         Me.btnRoleMembers.Location = New System.Drawing.Point(16, 136)
         Me.btnRoleMembers.Name = "btnRoleMembers"
         Me.btnRoleMembers.Size = New System.Drawing.Size(96, 32)
         Me.btnRoleMembers.TabIndex = 2
         Me.btnRoleMembers.Text = "Role Members"
         '
         'btnViewRoles
         '
         Me.btnViewRoles.Location = New System.Drawing.Point(16, 88)
         Me.btnViewRoles.Name = "btnViewRoles"
         Me.btnViewRoles.Size = New System.Drawing.Size(96, 32)
         Me.btnViewRoles.TabIndex = 1
         Me.btnViewRoles.Text = "View Roles"
         '
         'btnViewUsers
         '
         Me.btnViewUsers.Location = New System.Drawing.Point(16, 40)
         Me.btnViewUsers.Name = "btnViewUsers"
         Me.btnViewUsers.Size = New System.Drawing.Size(96, 32)
         Me.btnViewUsers.TabIndex = 0
         Me.btnViewUsers.Text = "View Users"
         '
         'thisConnection
         '
         Me.thisConnection.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
         "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
         '
         'Form1
         '
         Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
         Me.ClientSize = New System.Drawing.Size(408, 321)
         Me.Controls.Add(Me.GroupBox2)
         Me.Controls.Add(Me.GroupBox1)
         Me.Menu = Me.MainMenu1
         Me.Name = "Form1"
         Me.Text = "Admin Help"
         Me.GroupBox1.ResumeLayout(False)
         Me.GroupBox2.ResumeLayout(False)
         Me.ResumeLayout(False)

      End Sub

#End Region

      Protected Sub GetNewConnection()
         thisConnection.Open()
      End Sub

      Protected Sub CheckConnection()
         If thisConnection.State = ConnectionState.Closed Then
            GetNewConnection()
         End If
      End Sub


      Private Sub menuNew_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles menuNew.Click
         GetNewConnection()
      End Sub

      Private Sub menuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles menuExit.Click
         Me.Close()
      End Sub

#Region "Command Helpers"
      Private Function GetSPCommand() As SqlCommand
         Dim thisCommand As New SqlCommand
         thisCommand.Connection = thisConnection
         thisCommand.CommandType = CommandType.StoredProcedure
         Return thisCommand
      End Function

      Private Function GetLoginsCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helplogins"
         Return thisCommand
      End Function

      Private Function GetValidateLoginsCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_validatelogins"
         Return thisCommand
      End Function

      Private Function GetUsersCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helpuser"
         Return thisCommand
      End Function

      Private Function GetServerRoleCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helpsrvrole"
         Return thisCommand
      End Function

      Private Function GetServerRoleMembersCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helpsrvrolemember"
         Return thisCommand
      End Function

      Private Function GetServerRolePermissionCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_srvrolepermission"
         Return thisCommand
      End Function

      Private Function GetFixedDbRolesCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helpdbfixedrole"
         Return thisCommand
      End Function

      Private Function GetRolesCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helprole"
         Return thisCommand
      End Function

      Private Function GetRoleMembersCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helprolemember"
         Return thisCommand
      End Function

      Private Function GetDbFixedRolePermissionsCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_dbfixedrolepermission"
         Return thisCommand
      End Function

      Private Function GetPermissionsCommand() As SqlCommand
         Dim thisCommand As SqlCommand = GetSPCommand()
         thisCommand.CommandText = "sp_helprotect"
         Return thisCommand
      End Function

      Private Function GetUserObjectsCommand() As SqlCommand
         Dim thisCommand As New SqlCommand
         thisCommand.Connection = thisConnection
         thisCommand.CommandText = "SELECT name FROM sysobjects " & _
          "WHERE (type='P' OR type='U' OR type='V') and " & _
          "NOT objectproperty (id, 'IsMSShipped') > 0 " & _
          "ORDER BY name"
         Return thisCommand
      End Function
#End Region


      Private Sub btnViewLogins_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnViewLogins.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetLoginsCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnValidateLogins_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnValidateLogins.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetValidateLoginsCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub



      Private Sub btnServerRoles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnServerRoles.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetServerRoleCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnServerRoleMembers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnServerRoleMembers.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetServerRoleMembersCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnServerRolePermissions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnServerRolePermissions.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetServerRoleCommand()
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            Dim po As New PickOne("Select a server role")
            po.AppendListContents(dr, "ServerRole")
            dr.Close()

            If po.ShowDialog() = DialogResult.OK Then
               cmd = GetServerRolePermissionCommand()
               Dim param As New SqlParameter("@srvrolename", po.Selected)
               cmd.Parameters.Add(param)

               Dim qf As New QueryForm(cmd)
               qf.ShowDialog()
            End If
         End If
      End Sub

      Private Sub btnViewUsers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnViewUsers.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetUsersCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnViewRoles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnViewRoles.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetRolesCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnRoleMembers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRoleMembers.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetRoleMembersCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnFixedRoles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFixedRoles.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetFixedDbRolesCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnFixedRolePermissions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFixedRolePermissions.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetFixedDbRolesCommand()
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            Dim po As New PickOne("Select a server role")
            po.AppendListContents(dr, "DbFixedRole")
            dr.Close()

            If po.ShowDialog() = DialogResult.OK Then
               cmd = GetDbFixedRolePermissionsCommand()
               Dim param As New SqlParameter("@rolename", po.Selected)
               cmd.Parameters.Add(param)

               Dim qf As New QueryForm(cmd)
               qf.ShowDialog()
            End If
         End If
      End Sub

      Private Sub btnAllPermissions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAllPermissions.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetPermissionsCommand()
            Dim qf As New QueryForm(cmd)
            qf.ShowDialog()
         End If
      End Sub

      Private Sub btnPermissionsByUserRole_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPermissionsByUserRole.Click
         ' need to pick up all roles and all users in the current database
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetUsersCommand()
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            Dim po As New PickOne("Select a user or role")
            po.AppendListContents(dr, "UserName")
            dr.Close()

            cmd = GetRolesCommand()
            dr = cmd.ExecuteReader()
            po.AppendListContents(dr, "RoleName")
            dr.Close()

            If po.ShowDialog() = DialogResult.OK Then
               cmd = GetPermissionsCommand()
               Dim param As New SqlParameter("@name", po.Selected)
               cmd.Parameters.Add(param)

               Dim qf As New QueryForm(cmd)
               qf.ShowDialog()
            End If
         End If
      End Sub

      Private Sub btnPermissionsByObject_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPermissionsByObject.Click
         CheckConnection()
         If Not thisConnection Is Nothing Then
            Dim cmd As SqlCommand = GetUserObjectsCommand()
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            Dim po As New PickOne("Select an object or statement")
            po.AppendListContents(dr, "name")
            dr.Close()

            Dim statementPermissions() As String = {"CREATE DATABASE", _
               "CREATE DEFAULT", "CREATE FUNCTION", "CREATE PROCEDURE", _
               "CREATE RULE", "CREATE TABLE", "CREATE VIEW", _
               "BACKUP DATABASE", "BACKUP LOG"}

            po.AppendListContents(statementPermissions)

            If po.ShowDialog() = DialogResult.OK Then
               cmd = GetPermissionsCommand()
               Dim param As New SqlParameter("@name", po.Selected)
               cmd.Parameters.Add(param)

               Dim qf As New QueryForm(cmd)
               qf.ShowDialog()
            End If
         End If
      End Sub
   End Class

End Namespace




