Public Class DataForm1
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
   Friend WithEvents OleDbSelectCommand1 As System.Data.OleDb.OleDbCommand
   Friend WithEvents OleDbInsertCommand1 As System.Data.OleDb.OleDbCommand
   Friend WithEvents OleDbUpdateCommand1 As System.Data.OleDb.OleDbCommand
   Friend WithEvents OleDbDeleteCommand1 As System.Data.OleDb.OleDbCommand
   Friend WithEvents OleDbConnection1 As System.Data.OleDb.OleDbConnection
   Friend WithEvents OleDbDataAdapter1 As System.Data.OleDb.OleDbDataAdapter
   Friend WithEvents objDataSet1 As DataFormWizard.DataSet1
   Friend WithEvents btnLoad As System.Windows.Forms.Button
   Friend WithEvents btnUpdate As System.Windows.Forms.Button
   Friend WithEvents btnCancelAll As System.Windows.Forms.Button
   Friend WithEvents lblEmployeeID As System.Windows.Forms.Label
   Friend WithEvents lblLastName As System.Windows.Forms.Label
   Friend WithEvents lblFirstName As System.Windows.Forms.Label
   Friend WithEvents lblTitle As System.Windows.Forms.Label
   Friend WithEvents lblTitleOfCourtesy As System.Windows.Forms.Label
   Friend WithEvents lblBirthDate As System.Windows.Forms.Label
   Friend WithEvents lblHireDate As System.Windows.Forms.Label
   Friend WithEvents lblAddress As System.Windows.Forms.Label
   Friend WithEvents lblCity As System.Windows.Forms.Label
   Friend WithEvents editEmployeeID As System.Windows.Forms.TextBox
   Friend WithEvents editLastName As System.Windows.Forms.TextBox
   Friend WithEvents editFirstName As System.Windows.Forms.TextBox
   Friend WithEvents editTitle As System.Windows.Forms.TextBox
   Friend WithEvents editTitleOfCourtesy As System.Windows.Forms.TextBox
   Friend WithEvents editBirthDate As System.Windows.Forms.TextBox
   Friend WithEvents editHireDate As System.Windows.Forms.TextBox
   Friend WithEvents editAddress As System.Windows.Forms.TextBox
   Friend WithEvents editCity As System.Windows.Forms.TextBox
   Friend WithEvents lblRegion As System.Windows.Forms.Label
   Friend WithEvents lblPostalCode As System.Windows.Forms.Label
   Friend WithEvents lblCountry As System.Windows.Forms.Label
   Friend WithEvents lblHomePhone As System.Windows.Forms.Label
   Friend WithEvents lblExtension As System.Windows.Forms.Label
   Friend WithEvents lblNotes As System.Windows.Forms.Label
   Friend WithEvents lblReportsTo As System.Windows.Forms.Label
   Friend WithEvents lblPhotoPath As System.Windows.Forms.Label
   Friend WithEvents editRegion As System.Windows.Forms.TextBox
   Friend WithEvents editPostalCode As System.Windows.Forms.TextBox
   Friend WithEvents editCountry As System.Windows.Forms.TextBox
   Friend WithEvents editHomePhone As System.Windows.Forms.TextBox
   Friend WithEvents editExtension As System.Windows.Forms.TextBox
   Friend WithEvents editNotes As System.Windows.Forms.TextBox
   Friend WithEvents editReportsTo As System.Windows.Forms.TextBox
   Friend WithEvents editPhotoPath As System.Windows.Forms.TextBox
   Friend WithEvents btnNavFirst As System.Windows.Forms.Button
   Friend WithEvents btnNavPrev As System.Windows.Forms.Button
   Friend WithEvents lblNavLocation As System.Windows.Forms.Label
   Friend WithEvents btnNavNext As System.Windows.Forms.Button
   Friend WithEvents btnLast As System.Windows.Forms.Button
   Friend WithEvents btnAdd As System.Windows.Forms.Button
   Friend WithEvents btnDelete As System.Windows.Forms.Button
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.OleDbSelectCommand1 = New System.Data.OleDb.OleDbCommand
      Me.OleDbInsertCommand1 = New System.Data.OleDb.OleDbCommand
      Me.OleDbUpdateCommand1 = New System.Data.OleDb.OleDbCommand
      Me.OleDbDeleteCommand1 = New System.Data.OleDb.OleDbCommand
      Me.OleDbConnection1 = New System.Data.OleDb.OleDbConnection
      Me.OleDbDataAdapter1 = New System.Data.OleDb.OleDbDataAdapter
      Me.objDataSet1 = New DataFormWizard.DataSet1
      Me.btnLoad = New System.Windows.Forms.Button
      Me.btnUpdate = New System.Windows.Forms.Button
      Me.btnCancelAll = New System.Windows.Forms.Button
      Me.lblEmployeeID = New System.Windows.Forms.Label
      Me.lblLastName = New System.Windows.Forms.Label
      Me.lblFirstName = New System.Windows.Forms.Label
      Me.lblTitle = New System.Windows.Forms.Label
      Me.lblTitleOfCourtesy = New System.Windows.Forms.Label
      Me.lblBirthDate = New System.Windows.Forms.Label
      Me.lblHireDate = New System.Windows.Forms.Label
      Me.lblAddress = New System.Windows.Forms.Label
      Me.lblCity = New System.Windows.Forms.Label
      Me.editEmployeeID = New System.Windows.Forms.TextBox
      Me.editLastName = New System.Windows.Forms.TextBox
      Me.editFirstName = New System.Windows.Forms.TextBox
      Me.editTitle = New System.Windows.Forms.TextBox
      Me.editTitleOfCourtesy = New System.Windows.Forms.TextBox
      Me.editBirthDate = New System.Windows.Forms.TextBox
      Me.editHireDate = New System.Windows.Forms.TextBox
      Me.editAddress = New System.Windows.Forms.TextBox
      Me.editCity = New System.Windows.Forms.TextBox
      Me.lblRegion = New System.Windows.Forms.Label
      Me.lblPostalCode = New System.Windows.Forms.Label
      Me.lblCountry = New System.Windows.Forms.Label
      Me.lblHomePhone = New System.Windows.Forms.Label
      Me.lblExtension = New System.Windows.Forms.Label
      Me.lblNotes = New System.Windows.Forms.Label
      Me.lblReportsTo = New System.Windows.Forms.Label
      Me.lblPhotoPath = New System.Windows.Forms.Label
      Me.editRegion = New System.Windows.Forms.TextBox
      Me.editPostalCode = New System.Windows.Forms.TextBox
      Me.editCountry = New System.Windows.Forms.TextBox
      Me.editHomePhone = New System.Windows.Forms.TextBox
      Me.editExtension = New System.Windows.Forms.TextBox
      Me.editNotes = New System.Windows.Forms.TextBox
      Me.editReportsTo = New System.Windows.Forms.TextBox
      Me.editPhotoPath = New System.Windows.Forms.TextBox
      Me.btnNavFirst = New System.Windows.Forms.Button
      Me.btnNavPrev = New System.Windows.Forms.Button
      Me.lblNavLocation = New System.Windows.Forms.Label
      Me.btnNavNext = New System.Windows.Forms.Button
      Me.btnLast = New System.Windows.Forms.Button
      Me.btnAdd = New System.Windows.Forms.Button
      Me.btnDelete = New System.Windows.Forms.Button
      Me.btnCancel = New System.Windows.Forms.Button
      CType(Me.objDataSet1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'OleDbSelectCommand1
      '
      Me.OleDbSelectCommand1.CommandText = "SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDa" & _
      "te, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Not" & _
      "es, ReportsTo, PhotoPath FROM Employees"
      Me.OleDbSelectCommand1.Connection = Me.OleDbConnection1
      '
      'OleDbInsertCommand1
      '
      Me.OleDbInsertCommand1.CommandText = "INSERT INTO Employees(LastName, FirstName, Title, TitleOfCourtesy, BirthDate, Hir" & _
      "eDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, " & _
      "Notes, ReportsTo, PhotoPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?" & _
      ", ?, ?); SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDa" & _
      "te, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, " & _
      "Photo, Notes, ReportsTo, PhotoPath FROM Employees WHERE (EmployeeID = @@IDENTITY" & _
      ")"
      Me.OleDbInsertCommand1.Connection = Me.OleDbConnection1
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("LastName", System.Data.OleDb.OleDbType.VarWChar, 20, "LastName"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("FirstName", System.Data.OleDb.OleDbType.VarWChar, 10, "FirstName"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Title", System.Data.OleDb.OleDbType.VarWChar, 30, "Title"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("TitleOfCourtesy", System.Data.OleDb.OleDbType.VarWChar, 25, "TitleOfCourtesy"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("BirthDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, "BirthDate"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("HireDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, "HireDate"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Address", System.Data.OleDb.OleDbType.VarWChar, 60, "Address"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("City", System.Data.OleDb.OleDbType.VarWChar, 15, "City"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Region", System.Data.OleDb.OleDbType.VarWChar, 15, "Region"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("PostalCode", System.Data.OleDb.OleDbType.VarWChar, 10, "PostalCode"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Country", System.Data.OleDb.OleDbType.VarWChar, 15, "Country"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("HomePhone", System.Data.OleDb.OleDbType.VarWChar, 24, "HomePhone"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Extension", System.Data.OleDb.OleDbType.VarWChar, 4, "Extension"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Photo", System.Data.OleDb.OleDbType.VarBinary, 2147483647, "Photo"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Notes", System.Data.OleDb.OleDbType.VarWChar, 1073741823, "Notes"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("ReportsTo", System.Data.OleDb.OleDbType.Integer, 4, "ReportsTo"))
      Me.OleDbInsertCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("PhotoPath", System.Data.OleDb.OleDbType.VarWChar, 255, "PhotoPath"))
      '
      'OleDbUpdateCommand1
      '
      Me.OleDbUpdateCommand1.CommandText = "UPDATE Employees SET LastName = ?, FirstName = ?, Title = ?, TitleOfCourtesy = ?," & _
      " BirthDate = ?, HireDate = ?, Address = ?, City = ?, Region = ?, PostalCode = ?," & _
      " Country = ?, HomePhone = ?, Extension = ?, Photo = ?, Notes = ?, ReportsTo = ?," & _
      " PhotoPath = ? WHERE (EmployeeID = ?) AND (Address = ? OR ? IS NULL AND Address " & _
      "IS NULL) AND (BirthDate = ? OR ? IS NULL AND BirthDate IS NULL) AND (City = ? OR" & _
      " ? IS NULL AND City IS NULL) AND (Country = ? OR ? IS NULL AND Country IS NULL) " & _
      "AND (Extension = ? OR ? IS NULL AND Extension IS NULL) AND (FirstName = ?) AND (" & _
      "HireDate = ? OR ? IS NULL AND HireDate IS NULL) AND (HomePhone = ? OR ? IS NULL " & _
      "AND HomePhone IS NULL) AND (LastName = ?) AND (PhotoPath = ? OR ? IS NULL AND Ph" & _
      "otoPath IS NULL) AND (PostalCode = ? OR ? IS NULL AND PostalCode IS NULL) AND (R" & _
      "egion = ? OR ? IS NULL AND Region IS NULL) AND (ReportsTo = ? OR ? IS NULL AND R" & _
      "eportsTo IS NULL) AND (Title = ? OR ? IS NULL AND Title IS NULL) AND (TitleOfCou" & _
      "rtesy = ? OR ? IS NULL AND TitleOfCourtesy IS NULL); SELECT EmployeeID, LastName" & _
      ", FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region," & _
      " PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath F" & _
      "ROM Employees WHERE (EmployeeID = ?)"
      Me.OleDbUpdateCommand1.Connection = Me.OleDbConnection1
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("LastName", System.Data.OleDb.OleDbType.VarWChar, 20, "LastName"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("FirstName", System.Data.OleDb.OleDbType.VarWChar, 10, "FirstName"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Title", System.Data.OleDb.OleDbType.VarWChar, 30, "Title"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("TitleOfCourtesy", System.Data.OleDb.OleDbType.VarWChar, 25, "TitleOfCourtesy"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("BirthDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, "BirthDate"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("HireDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, "HireDate"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Address", System.Data.OleDb.OleDbType.VarWChar, 60, "Address"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("City", System.Data.OleDb.OleDbType.VarWChar, 15, "City"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Region", System.Data.OleDb.OleDbType.VarWChar, 15, "Region"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("PostalCode", System.Data.OleDb.OleDbType.VarWChar, 10, "PostalCode"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Country", System.Data.OleDb.OleDbType.VarWChar, 15, "Country"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("HomePhone", System.Data.OleDb.OleDbType.VarWChar, 24, "HomePhone"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Extension", System.Data.OleDb.OleDbType.VarWChar, 4, "Extension"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Photo", System.Data.OleDb.OleDbType.VarBinary, 2147483647, "Photo"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Notes", System.Data.OleDb.OleDbType.VarWChar, 1073741823, "Notes"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("ReportsTo", System.Data.OleDb.OleDbType.Integer, 4, "ReportsTo"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("PhotoPath", System.Data.OleDb.OleDbType.VarWChar, 255, "PhotoPath"))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_EmployeeID", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "EmployeeID", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Address", System.Data.OleDb.OleDbType.VarWChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Address1", System.Data.OleDb.OleDbType.VarWChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_BirthDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_BirthDate1", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_City", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_City1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Country", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Country1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Extension", System.Data.OleDb.OleDbType.VarWChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Extension1", System.Data.OleDb.OleDbType.VarWChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_FirstName", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "FirstName", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HireDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HireDate1", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HomePhone", System.Data.OleDb.OleDbType.VarWChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HomePhone1", System.Data.OleDb.OleDbType.VarWChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_LastName", System.Data.OleDb.OleDbType.VarWChar, 20, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "LastName", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PhotoPath", System.Data.OleDb.OleDbType.VarWChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PhotoPath1", System.Data.OleDb.OleDbType.VarWChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PostalCode", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PostalCode1", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Region", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Region1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_ReportsTo", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_ReportsTo1", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Title", System.Data.OleDb.OleDbType.VarWChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Title1", System.Data.OleDb.OleDbType.VarWChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_TitleOfCourtesy", System.Data.OleDb.OleDbType.VarWChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_TitleOfCourtesy1", System.Data.OleDb.OleDbType.VarWChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbUpdateCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Select_EmployeeID", System.Data.OleDb.OleDbType.Integer, 4, "EmployeeID"))
      '
      'OleDbDeleteCommand1
      '
      Me.OleDbDeleteCommand1.CommandText = "DELETE FROM Employees WHERE (EmployeeID = ?) AND (Address = ? OR ? IS NULL AND Ad" & _
      "dress IS NULL) AND (BirthDate = ? OR ? IS NULL AND BirthDate IS NULL) AND (City " & _
      "= ? OR ? IS NULL AND City IS NULL) AND (Country = ? OR ? IS NULL AND Country IS " & _
      "NULL) AND (Extension = ? OR ? IS NULL AND Extension IS NULL) AND (FirstName = ?)" & _
      " AND (HireDate = ? OR ? IS NULL AND HireDate IS NULL) AND (HomePhone = ? OR ? IS" & _
      " NULL AND HomePhone IS NULL) AND (LastName = ?) AND (PhotoPath = ? OR ? IS NULL " & _
      "AND PhotoPath IS NULL) AND (PostalCode = ? OR ? IS NULL AND PostalCode IS NULL) " & _
      "AND (Region = ? OR ? IS NULL AND Region IS NULL) AND (ReportsTo = ? OR ? IS NULL" & _
      " AND ReportsTo IS NULL) AND (Title = ? OR ? IS NULL AND Title IS NULL) AND (Titl" & _
      "eOfCourtesy = ? OR ? IS NULL AND TitleOfCourtesy IS NULL)"
      Me.OleDbDeleteCommand1.Connection = Me.OleDbConnection1
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_EmployeeID", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "EmployeeID", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Address", System.Data.OleDb.OleDbType.VarWChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Address1", System.Data.OleDb.OleDbType.VarWChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_BirthDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_BirthDate1", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_City", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_City1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Country", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Country1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Extension", System.Data.OleDb.OleDbType.VarWChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Extension1", System.Data.OleDb.OleDbType.VarWChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_FirstName", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "FirstName", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HireDate", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HireDate1", System.Data.OleDb.OleDbType.DBTimeStamp, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HomePhone", System.Data.OleDb.OleDbType.VarWChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_HomePhone1", System.Data.OleDb.OleDbType.VarWChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_LastName", System.Data.OleDb.OleDbType.VarWChar, 20, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "LastName", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PhotoPath", System.Data.OleDb.OleDbType.VarWChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PhotoPath1", System.Data.OleDb.OleDbType.VarWChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PostalCode", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_PostalCode1", System.Data.OleDb.OleDbType.VarWChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Region", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Region1", System.Data.OleDb.OleDbType.VarWChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_ReportsTo", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_ReportsTo1", System.Data.OleDb.OleDbType.Integer, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Title", System.Data.OleDb.OleDbType.VarWChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_Title1", System.Data.OleDb.OleDbType.VarWChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_TitleOfCourtesy", System.Data.OleDb.OleDbType.VarWChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      Me.OleDbDeleteCommand1.Parameters.Add(New System.Data.OleDb.OleDbParameter("Original_TitleOfCourtesy1", System.Data.OleDb.OleDbType.VarWChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      '
      'OleDbConnection1
      '
      Me.OleDbConnection1.ConnectionString = "Integrated Security=SSPI;Packet Size=4096;Data Source=""(local)\NetSDK"";Tag with c" & _
      "olumn collation when possible=False;Initial Catalog=Northwind;Use Procedure for " & _
      "Prepare=1;Auto Translate=True;Persist Security Info=False;Provider=""SQLOLEDB.1"";" & _
      "Workstation ID=DISTILLERY;Use Encryption for Data=False"
      '
      'OleDbDataAdapter1
      '
      Me.OleDbDataAdapter1.DeleteCommand = Me.OleDbDeleteCommand1
      Me.OleDbDataAdapter1.InsertCommand = Me.OleDbInsertCommand1
      Me.OleDbDataAdapter1.SelectCommand = Me.OleDbSelectCommand1
      Me.OleDbDataAdapter1.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "Employees", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("EmployeeID", "EmployeeID"), New System.Data.Common.DataColumnMapping("LastName", "LastName"), New System.Data.Common.DataColumnMapping("FirstName", "FirstName"), New System.Data.Common.DataColumnMapping("Title", "Title"), New System.Data.Common.DataColumnMapping("TitleOfCourtesy", "TitleOfCourtesy"), New System.Data.Common.DataColumnMapping("BirthDate", "BirthDate"), New System.Data.Common.DataColumnMapping("HireDate", "HireDate"), New System.Data.Common.DataColumnMapping("Address", "Address"), New System.Data.Common.DataColumnMapping("City", "City"), New System.Data.Common.DataColumnMapping("Region", "Region"), New System.Data.Common.DataColumnMapping("PostalCode", "PostalCode"), New System.Data.Common.DataColumnMapping("Country", "Country"), New System.Data.Common.DataColumnMapping("HomePhone", "HomePhone"), New System.Data.Common.DataColumnMapping("Extension", "Extension"), New System.Data.Common.DataColumnMapping("Photo", "Photo"), New System.Data.Common.DataColumnMapping("Notes", "Notes"), New System.Data.Common.DataColumnMapping("ReportsTo", "ReportsTo"), New System.Data.Common.DataColumnMapping("PhotoPath", "PhotoPath")})})
      Me.OleDbDataAdapter1.UpdateCommand = Me.OleDbUpdateCommand1
      '
      'objDataSet1
      '
      Me.objDataSet1.DataSetName = "DataSet1"
      Me.objDataSet1.Locale = New System.Globalization.CultureInfo("en-GB")
      '
      'btnLoad
      '
      Me.btnLoad.Location = New System.Drawing.Point(10, 10)
      Me.btnLoad.Name = "btnLoad"
      Me.btnLoad.TabIndex = 0
      Me.btnLoad.Text = "&Load"
      '
      'btnUpdate
      '
      Me.btnUpdate.Location = New System.Drawing.Point(365, 10)
      Me.btnUpdate.Name = "btnUpdate"
      Me.btnUpdate.TabIndex = 1
      Me.btnUpdate.Text = "&Update"
      '
      'btnCancelAll
      '
      Me.btnCancelAll.Location = New System.Drawing.Point(365, 43)
      Me.btnCancelAll.Name = "btnCancelAll"
      Me.btnCancelAll.TabIndex = 2
      Me.btnCancelAll.Text = "Ca&ncel All"
      '
      'lblEmployeeID
      '
      Me.lblEmployeeID.Location = New System.Drawing.Point(10, 76)
      Me.lblEmployeeID.Name = "lblEmployeeID"
      Me.lblEmployeeID.TabIndex = 3
      Me.lblEmployeeID.Text = "EmployeeID"
      '
      'lblLastName
      '
      Me.lblLastName.Location = New System.Drawing.Point(10, 109)
      Me.lblLastName.Name = "lblLastName"
      Me.lblLastName.TabIndex = 4
      Me.lblLastName.Text = "LastName"
      '
      'lblFirstName
      '
      Me.lblFirstName.Location = New System.Drawing.Point(10, 142)
      Me.lblFirstName.Name = "lblFirstName"
      Me.lblFirstName.TabIndex = 5
      Me.lblFirstName.Text = "FirstName"
      '
      'lblTitle
      '
      Me.lblTitle.Location = New System.Drawing.Point(10, 175)
      Me.lblTitle.Name = "lblTitle"
      Me.lblTitle.TabIndex = 6
      Me.lblTitle.Text = "Title"
      '
      'lblTitleOfCourtesy
      '
      Me.lblTitleOfCourtesy.Location = New System.Drawing.Point(10, 208)
      Me.lblTitleOfCourtesy.Name = "lblTitleOfCourtesy"
      Me.lblTitleOfCourtesy.TabIndex = 7
      Me.lblTitleOfCourtesy.Text = "TitleOfCourtesy"
      '
      'lblBirthDate
      '
      Me.lblBirthDate.Location = New System.Drawing.Point(10, 241)
      Me.lblBirthDate.Name = "lblBirthDate"
      Me.lblBirthDate.TabIndex = 8
      Me.lblBirthDate.Text = "BirthDate"
      '
      'lblHireDate
      '
      Me.lblHireDate.Location = New System.Drawing.Point(10, 274)
      Me.lblHireDate.Name = "lblHireDate"
      Me.lblHireDate.TabIndex = 9
      Me.lblHireDate.Text = "HireDate"
      '
      'lblAddress
      '
      Me.lblAddress.Location = New System.Drawing.Point(10, 307)
      Me.lblAddress.Name = "lblAddress"
      Me.lblAddress.TabIndex = 10
      Me.lblAddress.Text = "Address"
      '
      'lblCity
      '
      Me.lblCity.Location = New System.Drawing.Point(10, 340)
      Me.lblCity.Name = "lblCity"
      Me.lblCity.TabIndex = 11
      Me.lblCity.Text = "City"
      '
      'editEmployeeID
      '
      Me.editEmployeeID.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.EmployeeID"))
      Me.editEmployeeID.Location = New System.Drawing.Point(120, 76)
      Me.editEmployeeID.Name = "editEmployeeID"
      Me.editEmployeeID.TabIndex = 12
      Me.editEmployeeID.Text = ""
      '
      'editLastName
      '
      Me.editLastName.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.LastName"))
      Me.editLastName.Location = New System.Drawing.Point(120, 109)
      Me.editLastName.Name = "editLastName"
      Me.editLastName.TabIndex = 13
      Me.editLastName.Text = ""
      '
      'editFirstName
      '
      Me.editFirstName.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.FirstName"))
      Me.editFirstName.Location = New System.Drawing.Point(120, 142)
      Me.editFirstName.Name = "editFirstName"
      Me.editFirstName.TabIndex = 14
      Me.editFirstName.Text = ""
      '
      'editTitle
      '
      Me.editTitle.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Title"))
      Me.editTitle.Location = New System.Drawing.Point(120, 175)
      Me.editTitle.Name = "editTitle"
      Me.editTitle.TabIndex = 15
      Me.editTitle.Text = ""
      '
      'editTitleOfCourtesy
      '
      Me.editTitleOfCourtesy.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.TitleOfCourtesy"))
      Me.editTitleOfCourtesy.Location = New System.Drawing.Point(120, 208)
      Me.editTitleOfCourtesy.Name = "editTitleOfCourtesy"
      Me.editTitleOfCourtesy.TabIndex = 16
      Me.editTitleOfCourtesy.Text = ""
      '
      'editBirthDate
      '
      Me.editBirthDate.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.BirthDate"))
      Me.editBirthDate.Location = New System.Drawing.Point(120, 241)
      Me.editBirthDate.Name = "editBirthDate"
      Me.editBirthDate.TabIndex = 17
      Me.editBirthDate.Text = ""
      '
      'editHireDate
      '
      Me.editHireDate.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.HireDate"))
      Me.editHireDate.Location = New System.Drawing.Point(120, 274)
      Me.editHireDate.Name = "editHireDate"
      Me.editHireDate.TabIndex = 18
      Me.editHireDate.Text = ""
      '
      'editAddress
      '
      Me.editAddress.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Address"))
      Me.editAddress.Location = New System.Drawing.Point(120, 307)
      Me.editAddress.Name = "editAddress"
      Me.editAddress.TabIndex = 19
      Me.editAddress.Text = ""
      '
      'editCity
      '
      Me.editCity.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.City"))
      Me.editCity.Location = New System.Drawing.Point(120, 340)
      Me.editCity.Name = "editCity"
      Me.editCity.TabIndex = 20
      Me.editCity.Text = ""
      '
      'lblRegion
      '
      Me.lblRegion.Location = New System.Drawing.Point(230, 76)
      Me.lblRegion.Name = "lblRegion"
      Me.lblRegion.TabIndex = 21
      Me.lblRegion.Text = "Region"
      '
      'lblPostalCode
      '
      Me.lblPostalCode.Location = New System.Drawing.Point(230, 109)
      Me.lblPostalCode.Name = "lblPostalCode"
      Me.lblPostalCode.TabIndex = 22
      Me.lblPostalCode.Text = "PostalCode"
      '
      'lblCountry
      '
      Me.lblCountry.Location = New System.Drawing.Point(230, 142)
      Me.lblCountry.Name = "lblCountry"
      Me.lblCountry.TabIndex = 23
      Me.lblCountry.Text = "Country"
      '
      'lblHomePhone
      '
      Me.lblHomePhone.Location = New System.Drawing.Point(230, 175)
      Me.lblHomePhone.Name = "lblHomePhone"
      Me.lblHomePhone.TabIndex = 24
      Me.lblHomePhone.Text = "HomePhone"
      '
      'lblExtension
      '
      Me.lblExtension.Location = New System.Drawing.Point(230, 208)
      Me.lblExtension.Name = "lblExtension"
      Me.lblExtension.TabIndex = 25
      Me.lblExtension.Text = "Extension"
      '
      'lblNotes
      '
      Me.lblNotes.Location = New System.Drawing.Point(230, 241)
      Me.lblNotes.Name = "lblNotes"
      Me.lblNotes.TabIndex = 26
      Me.lblNotes.Text = "Notes"
      '
      'lblReportsTo
      '
      Me.lblReportsTo.Location = New System.Drawing.Point(230, 274)
      Me.lblReportsTo.Name = "lblReportsTo"
      Me.lblReportsTo.TabIndex = 27
      Me.lblReportsTo.Text = "ReportsTo"
      '
      'lblPhotoPath
      '
      Me.lblPhotoPath.Location = New System.Drawing.Point(230, 307)
      Me.lblPhotoPath.Name = "lblPhotoPath"
      Me.lblPhotoPath.TabIndex = 28
      Me.lblPhotoPath.Text = "PhotoPath"
      '
      'editRegion
      '
      Me.editRegion.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Region"))
      Me.editRegion.Location = New System.Drawing.Point(340, 76)
      Me.editRegion.Name = "editRegion"
      Me.editRegion.TabIndex = 29
      Me.editRegion.Text = ""
      '
      'editPostalCode
      '
      Me.editPostalCode.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.PostalCode"))
      Me.editPostalCode.Location = New System.Drawing.Point(340, 109)
      Me.editPostalCode.Name = "editPostalCode"
      Me.editPostalCode.TabIndex = 30
      Me.editPostalCode.Text = ""
      '
      'editCountry
      '
      Me.editCountry.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Country"))
      Me.editCountry.Location = New System.Drawing.Point(340, 142)
      Me.editCountry.Name = "editCountry"
      Me.editCountry.TabIndex = 31
      Me.editCountry.Text = ""
      '
      'editHomePhone
      '
      Me.editHomePhone.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.HomePhone"))
      Me.editHomePhone.Location = New System.Drawing.Point(340, 175)
      Me.editHomePhone.Name = "editHomePhone"
      Me.editHomePhone.TabIndex = 32
      Me.editHomePhone.Text = ""
      '
      'editExtension
      '
      Me.editExtension.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Extension"))
      Me.editExtension.Location = New System.Drawing.Point(340, 208)
      Me.editExtension.Name = "editExtension"
      Me.editExtension.TabIndex = 33
      Me.editExtension.Text = ""
      '
      'editNotes
      '
      Me.editNotes.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.Notes"))
      Me.editNotes.Location = New System.Drawing.Point(340, 241)
      Me.editNotes.Name = "editNotes"
      Me.editNotes.TabIndex = 34
      Me.editNotes.Text = ""
      '
      'editReportsTo
      '
      Me.editReportsTo.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.ReportsTo"))
      Me.editReportsTo.Location = New System.Drawing.Point(340, 274)
      Me.editReportsTo.Name = "editReportsTo"
      Me.editReportsTo.TabIndex = 35
      Me.editReportsTo.Text = ""
      '
      'editPhotoPath
      '
      Me.editPhotoPath.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.objDataSet1, "Employees.PhotoPath"))
      Me.editPhotoPath.Location = New System.Drawing.Point(340, 307)
      Me.editPhotoPath.Name = "editPhotoPath"
      Me.editPhotoPath.TabIndex = 36
      Me.editPhotoPath.Text = ""
      '
      'btnNavFirst
      '
      Me.btnNavFirst.Location = New System.Drawing.Point(195, 373)
      Me.btnNavFirst.Name = "btnNavFirst"
      Me.btnNavFirst.Size = New System.Drawing.Size(40, 23)
      Me.btnNavFirst.TabIndex = 37
      Me.btnNavFirst.Text = "<<"
      '
      'btnNavPrev
      '
      Me.btnNavPrev.Location = New System.Drawing.Point(235, 373)
      Me.btnNavPrev.Name = "btnNavPrev"
      Me.btnNavPrev.Size = New System.Drawing.Size(35, 23)
      Me.btnNavPrev.TabIndex = 38
      Me.btnNavPrev.Text = "<"
      '
      'lblNavLocation
      '
      Me.lblNavLocation.BackColor = System.Drawing.Color.White
      Me.lblNavLocation.Location = New System.Drawing.Point(270, 373)
      Me.lblNavLocation.Name = "lblNavLocation"
      Me.lblNavLocation.Size = New System.Drawing.Size(95, 23)
      Me.lblNavLocation.TabIndex = 39
      Me.lblNavLocation.Text = "No Records"
      Me.lblNavLocation.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'btnNavNext
      '
      Me.btnNavNext.Location = New System.Drawing.Point(365, 373)
      Me.btnNavNext.Name = "btnNavNext"
      Me.btnNavNext.Size = New System.Drawing.Size(35, 23)
      Me.btnNavNext.TabIndex = 40
      Me.btnNavNext.Text = ">"
      '
      'btnLast
      '
      Me.btnLast.Location = New System.Drawing.Point(400, 373)
      Me.btnLast.Name = "btnLast"
      Me.btnLast.Size = New System.Drawing.Size(40, 23)
      Me.btnLast.TabIndex = 41
      Me.btnLast.Text = ">>"
      '
      'btnAdd
      '
      Me.btnAdd.Location = New System.Drawing.Point(195, 406)
      Me.btnAdd.Name = "btnAdd"
      Me.btnAdd.TabIndex = 42
      Me.btnAdd.Text = "&Add"
      '
      'btnDelete
      '
      Me.btnDelete.Location = New System.Drawing.Point(280, 406)
      Me.btnDelete.Name = "btnDelete"
      Me.btnDelete.TabIndex = 43
      Me.btnDelete.Text = "&Delete"
      '
      'btnCancel
      '
      Me.btnCancel.Location = New System.Drawing.Point(365, 406)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.TabIndex = 44
      Me.btnCancel.Text = "&Cancel"
      '
      'DataForm1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(442, 454)
      Me.Controls.Add(Me.btnLoad)
      Me.Controls.Add(Me.btnUpdate)
      Me.Controls.Add(Me.btnCancelAll)
      Me.Controls.Add(Me.lblEmployeeID)
      Me.Controls.Add(Me.lblLastName)
      Me.Controls.Add(Me.lblFirstName)
      Me.Controls.Add(Me.lblTitle)
      Me.Controls.Add(Me.lblTitleOfCourtesy)
      Me.Controls.Add(Me.lblBirthDate)
      Me.Controls.Add(Me.lblHireDate)
      Me.Controls.Add(Me.lblAddress)
      Me.Controls.Add(Me.lblCity)
      Me.Controls.Add(Me.editEmployeeID)
      Me.Controls.Add(Me.editLastName)
      Me.Controls.Add(Me.editFirstName)
      Me.Controls.Add(Me.editTitle)
      Me.Controls.Add(Me.editTitleOfCourtesy)
      Me.Controls.Add(Me.editBirthDate)
      Me.Controls.Add(Me.editHireDate)
      Me.Controls.Add(Me.editAddress)
      Me.Controls.Add(Me.editCity)
      Me.Controls.Add(Me.lblRegion)
      Me.Controls.Add(Me.lblPostalCode)
      Me.Controls.Add(Me.lblCountry)
      Me.Controls.Add(Me.lblHomePhone)
      Me.Controls.Add(Me.lblExtension)
      Me.Controls.Add(Me.lblNotes)
      Me.Controls.Add(Me.lblReportsTo)
      Me.Controls.Add(Me.lblPhotoPath)
      Me.Controls.Add(Me.editRegion)
      Me.Controls.Add(Me.editPostalCode)
      Me.Controls.Add(Me.editCountry)
      Me.Controls.Add(Me.editHomePhone)
      Me.Controls.Add(Me.editExtension)
      Me.Controls.Add(Me.editNotes)
      Me.Controls.Add(Me.editReportsTo)
      Me.Controls.Add(Me.editPhotoPath)
      Me.Controls.Add(Me.btnNavFirst)
      Me.Controls.Add(Me.btnNavPrev)
      Me.Controls.Add(Me.lblNavLocation)
      Me.Controls.Add(Me.btnNavNext)
      Me.Controls.Add(Me.btnLast)
      Me.Controls.Add(Me.btnAdd)
      Me.Controls.Add(Me.btnDelete)
      Me.Controls.Add(Me.btnCancel)
      Me.Name = "DataForm1"
      Me.Text = "DataForm1"
      CType(Me.objDataSet1, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      Me.BindingContext(objDataSet1, "Employees").CancelCurrentEdit()
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
      If (Me.BindingContext(objDataSet1, "Employees").Count > 0) Then
         Me.BindingContext(objDataSet1, "Employees").RemoveAt(Me.BindingContext(objDataSet1, "Employees").Position)
         Me.objDataSet1_PositionChanged()
      End If

   End Sub
   Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
      Try
         'Clear out the current edits
         Me.BindingContext(objDataSet1, "Employees").EndCurrentEdit()
         Me.BindingContext(objDataSet1, "Employees").AddNew()
      Catch eEndEdit As System.Exception
         System.Windows.Forms.MessageBox.Show(eEndEdit.Message)
      End Try
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
      Try
         'Attempt to update the datasource.
         Me.UpdateDataSet()
      Catch eUpdate As System.Exception
         'Add your error handling code here.
         'Display error message, if any.
         System.Windows.Forms.MessageBox.Show(eUpdate.Message)
      End Try
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnLoad_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoad.Click
      Try
         'Attempt to load the dataset.
         Me.LoadDataSet()
      Catch eLoad As System.Exception
         'Add your error handling code here.
         'Display error message, if any.
         System.Windows.Forms.MessageBox.Show(eLoad.Message)
      End Try
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnNavFirst_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNavFirst.Click
      Me.BindingContext(objDataSet1, "Employees").Position = 0
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnLast_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLast.Click
      Me.BindingContext(objDataSet1, "Employees").Position = (Me.objDataSet1.Tables("Employees").Rows.Count - 1)
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnNavPrev_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNavPrev.Click
      Me.BindingContext(objDataSet1, "Employees").Position = (Me.BindingContext(objDataSet1, "Employees").Position - 1)
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub btnNavNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNavNext.Click
      Me.BindingContext(objDataSet1, "Employees").Position = (Me.BindingContext(objDataSet1, "Employees").Position + 1)
      Me.objDataSet1_PositionChanged()

   End Sub
   Private Sub objDataSet1_PositionChanged()
      Me.lblNavLocation.Text = (((Me.BindingContext(objDataSet1, "Employees").Position + 1).ToString + " of  ") _
                  + Me.BindingContext(objDataSet1, "Employees").Count.ToString)

   End Sub
   Private Sub btnCancelAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelAll.Click
      Me.objDataSet1.RejectChanges()

   End Sub
   Public Sub UpdateDataSet()
      'Create a new dataset to hold the changes that have been made to the main dataset.
      Dim objDataSetChanges As DataFormWizard.DataSet1 = New DataFormWizard.DataSet1
      'Stop any current edits.
      Me.BindingContext(objDataSet1, "Employees").EndCurrentEdit()
      'Get the changes that have been made to the main dataset.
      objDataSetChanges = CType(objDataSet1.GetChanges, DataFormWizard.DataSet1)
      'Check to see if any changes have been made.
      If (Not (objDataSetChanges) Is Nothing) Then
         Try
            'There are changes that need to be made, so attempt to update the datasource by
            'calling the update method and passing the dataset and any parameters.
            Me.UpdateDataSource(objDataSetChanges)
            objDataSet1.Merge(objDataSetChanges)
            objDataSet1.AcceptChanges()
         Catch eUpdate As System.Exception
            'Add your error handling code here.
            Throw eUpdate
         End Try
         'Add your code to check the returned dataset for any errors that may have been
         'pushed into the row object's error.
      End If

   End Sub
   Public Sub LoadDataSet()
      'Create a new dataset to hold the records returned from the call to FillDataSet.
      'A temporary dataset is used because filling the existing dataset would
      'require the databindings to be rebound.
      Dim objDataSetTemp As DataFormWizard.DataSet1
      objDataSetTemp = New DataFormWizard.DataSet1
      Try
         'Attempt to fill the temporary dataset.
         Me.FillDataSet(objDataSetTemp)
      Catch eFillDataSet As System.Exception
         'Add your error handling code here.
         Throw eFillDataSet
      End Try
      Try
         'Empty the old records from the dataset.
         objDataSet1.Clear()
         'Merge the records into the main dataset.
         objDataSet1.Merge(objDataSetTemp)
      Catch eLoadMerge As System.Exception
         'Add your error handling code here.
         Throw eLoadMerge
      End Try

   End Sub
   Public Sub UpdateDataSource(ByVal ChangedRows As DataFormWizard.DataSet1)
      Try
         'The data source only needs to be updated if there are changes pending.
         If (Not (ChangedRows) Is Nothing) Then
            'Open the connection.
            Me.OleDbConnection1.Open()
            'Attempt to update the data source.
            OleDbDataAdapter1.Update(ChangedRows)
         End If
      Catch updateException As System.Exception
         'Add your error handling code here.
         Throw updateException
      Finally
         'Close the connection whether or not the exception was thrown.
         Me.OleDbConnection1.Close()
      End Try

   End Sub
   Public Sub FillDataSet(ByVal dataSet As DataFormWizard.DataSet1)
      'Turn off constraint checking before the dataset is filled.
      'This allows the adapters to fill the dataset without concern
      'for dependencies between the tables.
      dataSet.EnforceConstraints = False
      Try
         'Open the connection.
         Me.OleDbConnection1.Open()
         'Attempt to fill the dataset through the OleDbDataAdapter1.
         Me.OleDbDataAdapter1.Fill(dataSet)
      Catch fillException As System.Exception
         'Add your error handling code here.
         Throw fillException
      Finally
         'Turn constraint checking back on.
         dataSet.EnforceConstraints = True
         'Close the connection whether or not the exception was thrown.
         Me.OleDbConnection1.Close()
      End Try

   End Sub
End Class
