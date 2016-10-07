Public Class Form1
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        SqlDataAdapterEmployees.Fill(DataSetEmployees1)

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
    Friend WithEvents SqlConnectionNorthwind As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlInsertCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlUpdateCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDeleteCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDataAdapterEmployees As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents DataSetEmployees1 As Employees.DataSetEmployees
    Friend WithEvents ListBoxNames As System.Windows.Forms.ListBox
    Friend WithEvents TextBoxNotes As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents TextBoxFirstName As System.Windows.Forms.TextBox
    Friend WithEvents TextBoxLastName As System.Windows.Forms.TextBox
    Friend WithEvents TextBoxBirthDate As System.Windows.Forms.TextBox
    Friend WithEvents TextBoxHomePhone As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.SqlConnectionNorthwind = New System.Data.SqlClient.SqlConnection
      Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand
      Me.SqlInsertCommand1 = New System.Data.SqlClient.SqlCommand
      Me.SqlUpdateCommand1 = New System.Data.SqlClient.SqlCommand
      Me.SqlDeleteCommand1 = New System.Data.SqlClient.SqlCommand
      Me.SqlDataAdapterEmployees = New System.Data.SqlClient.SqlDataAdapter
      Me.DataSetEmployees1 = New Employees.DataSetEmployees
      Me.ListBoxNames = New System.Windows.Forms.ListBox
      Me.TextBoxNotes = New System.Windows.Forms.TextBox
      Me.Label1 = New System.Windows.Forms.Label
      Me.Label2 = New System.Windows.Forms.Label
      Me.Label3 = New System.Windows.Forms.Label
      Me.Label4 = New System.Windows.Forms.Label
      Me.Label5 = New System.Windows.Forms.Label
      Me.TextBoxFirstName = New System.Windows.Forms.TextBox
      Me.TextBoxLastName = New System.Windows.Forms.TextBox
      Me.TextBoxBirthDate = New System.Windows.Forms.TextBox
      Me.TextBoxHomePhone = New System.Windows.Forms.TextBox
      CType(Me.DataSetEmployees1, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'SqlConnectionNorthwind
      '
      Me.SqlConnectionNorthwind.ConnectionString = "workstation id=DISTILLERY;packet size=4096;integrated security=SSPI;data source=""" & _
      "(local)\NetSDK"";persist security info=False;initial catalog=Northwind"
      '
      'SqlSelectCommand1
      '
      Me.SqlSelectCommand1.CommandText = "SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDa" & _
      "te, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Not" & _
      "es, ReportsTo, PhotoPath FROM Employees"
      Me.SqlSelectCommand1.Connection = Me.SqlConnectionNorthwind
      '
      'SqlInsertCommand1
      '
      Me.SqlInsertCommand1.CommandText = "INSERT INTO Employees(LastName, FirstName, Title, TitleOfCourtesy, BirthDate, Hir" & _
      "eDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, " & _
      "Notes, ReportsTo, PhotoPath) VALUES (@LastName, @FirstName, @Title, @TitleOfCour" & _
      "tesy, @BirthDate, @HireDate, @Address, @City, @Region, @PostalCode, @Country, @H" & _
      "omePhone, @Extension, @Photo, @Notes, @ReportsTo, @PhotoPath); SELECT EmployeeID" & _
      ", LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, Cit" & _
      "y, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, P" & _
      "hotoPath FROM Employees WHERE (EmployeeID = @@IDENTITY)"
      Me.SqlInsertCommand1.Connection = Me.SqlConnectionNorthwind
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@LastName", System.Data.SqlDbType.NVarChar, 20, "LastName"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FirstName", System.Data.SqlDbType.NVarChar, 10, "FirstName"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Title", System.Data.SqlDbType.NVarChar, 30, "Title"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@TitleOfCourtesy", System.Data.SqlDbType.NVarChar, 25, "TitleOfCourtesy"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@BirthDate", System.Data.SqlDbType.DateTime, 8, "BirthDate"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@HireDate", System.Data.SqlDbType.DateTime, 8, "HireDate"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Address", System.Data.SqlDbType.NVarChar, 60, "Address"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@City", System.Data.SqlDbType.NVarChar, 15, "City"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Region", System.Data.SqlDbType.NVarChar, 15, "Region"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@PostalCode", System.Data.SqlDbType.NVarChar, 10, "PostalCode"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Country", System.Data.SqlDbType.NVarChar, 15, "Country"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@HomePhone", System.Data.SqlDbType.NVarChar, 24, "HomePhone"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Extension", System.Data.SqlDbType.NVarChar, 4, "Extension"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Photo", System.Data.SqlDbType.VarBinary, 2147483647, "Photo"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Notes", System.Data.SqlDbType.NVarChar, 1073741823, "Notes"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@ReportsTo", System.Data.SqlDbType.Int, 4, "ReportsTo"))
      Me.SqlInsertCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@PhotoPath", System.Data.SqlDbType.NVarChar, 255, "PhotoPath"))
      '
      'SqlUpdateCommand1
      '
      Me.SqlUpdateCommand1.CommandText = "UPDATE Employees SET LastName = @LastName, FirstName = @FirstName, Title = @Title" & _
      ", TitleOfCourtesy = @TitleOfCourtesy, BirthDate = @BirthDate, HireDate = @HireDa" & _
      "te, Address = @Address, City = @City, Region = @Region, PostalCode = @PostalCode" & _
      ", Country = @Country, HomePhone = @HomePhone, Extension = @Extension, Photo = @P" & _
      "hoto, Notes = @Notes, ReportsTo = @ReportsTo, PhotoPath = @PhotoPath WHERE (Empl" & _
      "oyeeID = @Original_EmployeeID) AND (Address = @Original_Address OR @Original_Add" & _
      "ress IS NULL AND Address IS NULL) AND (BirthDate = @Original_BirthDate OR @Origi" & _
      "nal_BirthDate IS NULL AND BirthDate IS NULL) AND (City = @Original_City OR @Orig" & _
      "inal_City IS NULL AND City IS NULL) AND (Country = @Original_Country OR @Origina" & _
      "l_Country IS NULL AND Country IS NULL) AND (Extension = @Original_Extension OR @" & _
      "Original_Extension IS NULL AND Extension IS NULL) AND (FirstName = @Original_Fir" & _
      "stName) AND (HireDate = @Original_HireDate OR @Original_HireDate IS NULL AND Hir" & _
      "eDate IS NULL) AND (HomePhone = @Original_HomePhone OR @Original_HomePhone IS NU" & _
      "LL AND HomePhone IS NULL) AND (LastName = @Original_LastName) AND (PhotoPath = @" & _
      "Original_PhotoPath OR @Original_PhotoPath IS NULL AND PhotoPath IS NULL) AND (Po" & _
      "stalCode = @Original_PostalCode OR @Original_PostalCode IS NULL AND PostalCode I" & _
      "S NULL) AND (Region = @Original_Region OR @Original_Region IS NULL AND Region IS" & _
      " NULL) AND (ReportsTo = @Original_ReportsTo OR @Original_ReportsTo IS NULL AND R" & _
      "eportsTo IS NULL) AND (Title = @Original_Title OR @Original_Title IS NULL AND Ti" & _
      "tle IS NULL) AND (TitleOfCourtesy = @Original_TitleOfCourtesy OR @Original_Title" & _
      "OfCourtesy IS NULL AND TitleOfCourtesy IS NULL); SELECT EmployeeID, LastName, Fi" & _
      "rstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, Pos" & _
      "talCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath FROM " & _
      "Employees WHERE (EmployeeID = @EmployeeID)"
      Me.SqlUpdateCommand1.Connection = Me.SqlConnectionNorthwind
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@LastName", System.Data.SqlDbType.NVarChar, 20, "LastName"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FirstName", System.Data.SqlDbType.NVarChar, 10, "FirstName"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Title", System.Data.SqlDbType.NVarChar, 30, "Title"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@TitleOfCourtesy", System.Data.SqlDbType.NVarChar, 25, "TitleOfCourtesy"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@BirthDate", System.Data.SqlDbType.DateTime, 8, "BirthDate"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@HireDate", System.Data.SqlDbType.DateTime, 8, "HireDate"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Address", System.Data.SqlDbType.NVarChar, 60, "Address"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@City", System.Data.SqlDbType.NVarChar, 15, "City"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Region", System.Data.SqlDbType.NVarChar, 15, "Region"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@PostalCode", System.Data.SqlDbType.NVarChar, 10, "PostalCode"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Country", System.Data.SqlDbType.NVarChar, 15, "Country"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@HomePhone", System.Data.SqlDbType.NVarChar, 24, "HomePhone"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Extension", System.Data.SqlDbType.NVarChar, 4, "Extension"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Photo", System.Data.SqlDbType.VarBinary, 2147483647, "Photo"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Notes", System.Data.SqlDbType.NVarChar, 1073741823, "Notes"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@ReportsTo", System.Data.SqlDbType.Int, 4, "ReportsTo"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@PhotoPath", System.Data.SqlDbType.NVarChar, 255, "PhotoPath"))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_EmployeeID", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "EmployeeID", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Address", System.Data.SqlDbType.NVarChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_BirthDate", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_City", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Country", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Extension", System.Data.SqlDbType.NVarChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_FirstName", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "FirstName", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_HireDate", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_HomePhone", System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_LastName", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "LastName", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_PhotoPath", System.Data.SqlDbType.NVarChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_PostalCode", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Region", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_ReportsTo", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Title", System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_TitleOfCourtesy", System.Data.SqlDbType.NVarChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlUpdateCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@EmployeeID", System.Data.SqlDbType.Int, 4, "EmployeeID"))
      '
      'SqlDeleteCommand1
      '
      Me.SqlDeleteCommand1.CommandText = "DELETE FROM Employees WHERE (EmployeeID = @Original_EmployeeID) AND (Address = @O" & _
      "riginal_Address OR @Original_Address IS NULL AND Address IS NULL) AND (BirthDate" & _
      " = @Original_BirthDate OR @Original_BirthDate IS NULL AND BirthDate IS NULL) AND" & _
      " (City = @Original_City OR @Original_City IS NULL AND City IS NULL) AND (Country" & _
      " = @Original_Country OR @Original_Country IS NULL AND Country IS NULL) AND (Exte" & _
      "nsion = @Original_Extension OR @Original_Extension IS NULL AND Extension IS NULL" & _
      ") AND (FirstName = @Original_FirstName) AND (HireDate = @Original_HireDate OR @O" & _
      "riginal_HireDate IS NULL AND HireDate IS NULL) AND (HomePhone = @Original_HomePh" & _
      "one OR @Original_HomePhone IS NULL AND HomePhone IS NULL) AND (LastName = @Origi" & _
      "nal_LastName) AND (PhotoPath = @Original_PhotoPath OR @Original_PhotoPath IS NUL" & _
      "L AND PhotoPath IS NULL) AND (PostalCode = @Original_PostalCode OR @Original_Pos" & _
      "talCode IS NULL AND PostalCode IS NULL) AND (Region = @Original_Region OR @Origi" & _
      "nal_Region IS NULL AND Region IS NULL) AND (ReportsTo = @Original_ReportsTo OR @" & _
      "Original_ReportsTo IS NULL AND ReportsTo IS NULL) AND (Title = @Original_Title O" & _
      "R @Original_Title IS NULL AND Title IS NULL) AND (TitleOfCourtesy = @Original_Ti" & _
      "tleOfCourtesy OR @Original_TitleOfCourtesy IS NULL AND TitleOfCourtesy IS NULL)"
      Me.SqlDeleteCommand1.Connection = Me.SqlConnectionNorthwind
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_EmployeeID", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "EmployeeID", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Address", System.Data.SqlDbType.NVarChar, 60, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Address", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_BirthDate", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "BirthDate", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_City", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "City", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Country", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Country", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Extension", System.Data.SqlDbType.NVarChar, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Extension", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_FirstName", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "FirstName", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_HireDate", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HireDate", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_HomePhone", System.Data.SqlDbType.NVarChar, 24, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "HomePhone", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_LastName", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "LastName", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_PhotoPath", System.Data.SqlDbType.NVarChar, 255, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PhotoPath", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_PostalCode", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "PostalCode", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Region", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Region", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_ReportsTo", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "ReportsTo", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_Title", System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "Title", System.Data.DataRowVersion.Original, Nothing))
      Me.SqlDeleteCommand1.Parameters.Add(New System.Data.SqlClient.SqlParameter("@Original_TitleOfCourtesy", System.Data.SqlDbType.NVarChar, 25, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "TitleOfCourtesy", System.Data.DataRowVersion.Original, Nothing))
      '
      'SqlDataAdapterEmployees
      '
      Me.SqlDataAdapterEmployees.DeleteCommand = Me.SqlDeleteCommand1
      Me.SqlDataAdapterEmployees.InsertCommand = Me.SqlInsertCommand1
      Me.SqlDataAdapterEmployees.SelectCommand = Me.SqlSelectCommand1
      Me.SqlDataAdapterEmployees.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "Employees", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("EmployeeID", "EmployeeID"), New System.Data.Common.DataColumnMapping("LastName", "LastName"), New System.Data.Common.DataColumnMapping("FirstName", "FirstName"), New System.Data.Common.DataColumnMapping("Title", "Title"), New System.Data.Common.DataColumnMapping("TitleOfCourtesy", "TitleOfCourtesy"), New System.Data.Common.DataColumnMapping("BirthDate", "BirthDate"), New System.Data.Common.DataColumnMapping("HireDate", "HireDate"), New System.Data.Common.DataColumnMapping("Address", "Address"), New System.Data.Common.DataColumnMapping("City", "City"), New System.Data.Common.DataColumnMapping("Region", "Region"), New System.Data.Common.DataColumnMapping("PostalCode", "PostalCode"), New System.Data.Common.DataColumnMapping("Country", "Country"), New System.Data.Common.DataColumnMapping("HomePhone", "HomePhone"), New System.Data.Common.DataColumnMapping("Extension", "Extension"), New System.Data.Common.DataColumnMapping("Photo", "Photo"), New System.Data.Common.DataColumnMapping("Notes", "Notes"), New System.Data.Common.DataColumnMapping("ReportsTo", "ReportsTo"), New System.Data.Common.DataColumnMapping("PhotoPath", "PhotoPath")})})
      Me.SqlDataAdapterEmployees.UpdateCommand = Me.SqlUpdateCommand1
      '
      'DataSetEmployees1
      '
      Me.DataSetEmployees1.DataSetName = "DataSetEmployees"
      Me.DataSetEmployees1.Locale = New System.Globalization.CultureInfo("en-GB")
      '
      'ListBoxNames
      '
      Me.ListBoxNames.DataSource = Me.DataSetEmployees1.Employees
      Me.ListBoxNames.DisplayMember = "LastName"
      Me.ListBoxNames.Location = New System.Drawing.Point(24, 16)
      Me.ListBoxNames.Name = "ListBoxNames"
      Me.ListBoxNames.Size = New System.Drawing.Size(120, 134)
      Me.ListBoxNames.TabIndex = 0
      Me.ListBoxNames.ValueMember = "EmployeeID"
      '
      'TextBoxNotes
      '
      Me.TextBoxNotes.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.DataSetEmployees1, "Employees.Notes"))
      Me.TextBoxNotes.Location = New System.Drawing.Point(16, 200)
      Me.TextBoxNotes.Multiline = True
      Me.TextBoxNotes.Name = "TextBoxNotes"
      Me.TextBoxNotes.Size = New System.Drawing.Size(464, 56)
      Me.TextBoxNotes.TabIndex = 1
      Me.TextBoxNotes.Text = ""
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(24, 168)
      Me.Label1.Name = "Label1"
      Me.Label1.TabIndex = 2
      Me.Label1.Text = "Notes"
      '
      'Label2
      '
      Me.Label2.Location = New System.Drawing.Point(184, 24)
      Me.Label2.Name = "Label2"
      Me.Label2.TabIndex = 3
      Me.Label2.Text = "First Name"
      '
      'Label3
      '
      Me.Label3.Location = New System.Drawing.Point(184, 64)
      Me.Label3.Name = "Label3"
      Me.Label3.TabIndex = 4
      Me.Label3.Text = "Last Name"
      '
      'Label4
      '
      Me.Label4.Location = New System.Drawing.Point(184, 104)
      Me.Label4.Name = "Label4"
      Me.Label4.TabIndex = 5
      Me.Label4.Text = "Birth Date"
      '
      'Label5
      '
      Me.Label5.Location = New System.Drawing.Point(184, 144)
      Me.Label5.Name = "Label5"
      Me.Label5.TabIndex = 6
      Me.Label5.Text = "Home Phone"
      '
      'TextBoxFirstName
      '
      Me.TextBoxFirstName.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.DataSetEmployees1, "Employees.FirstName"))
      Me.TextBoxFirstName.Location = New System.Drawing.Point(304, 16)
      Me.TextBoxFirstName.Name = "TextBoxFirstName"
      Me.TextBoxFirstName.Size = New System.Drawing.Size(152, 20)
      Me.TextBoxFirstName.TabIndex = 7
      Me.TextBoxFirstName.Text = ""
      '
      'TextBoxLastName
      '
      Me.TextBoxLastName.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.DataSetEmployees1, "Employees.LastName"))
      Me.TextBoxLastName.Location = New System.Drawing.Point(304, 56)
      Me.TextBoxLastName.Name = "TextBoxLastName"
      Me.TextBoxLastName.Size = New System.Drawing.Size(152, 20)
      Me.TextBoxLastName.TabIndex = 8
      Me.TextBoxLastName.Text = ""
      '
      'TextBoxBirthDate
      '
      Me.TextBoxBirthDate.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.DataSetEmployees1, "Employees.BirthDate"))
      Me.TextBoxBirthDate.Location = New System.Drawing.Point(304, 96)
      Me.TextBoxBirthDate.Name = "TextBoxBirthDate"
      Me.TextBoxBirthDate.Size = New System.Drawing.Size(152, 20)
      Me.TextBoxBirthDate.TabIndex = 9
      Me.TextBoxBirthDate.Text = ""
      '
      'TextBoxHomePhone
      '
      Me.TextBoxHomePhone.DataBindings.Add(New System.Windows.Forms.Binding("Text", Me.DataSetEmployees1, "Employees.HomePhone"))
      Me.TextBoxHomePhone.Location = New System.Drawing.Point(304, 136)
      Me.TextBoxHomePhone.Name = "TextBoxHomePhone"
      Me.TextBoxHomePhone.Size = New System.Drawing.Size(152, 20)
      Me.TextBoxHomePhone.TabIndex = 10
      Me.TextBoxHomePhone.Text = ""
      '
      'Form1
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(504, 273)
      Me.Controls.Add(Me.TextBoxHomePhone)
      Me.Controls.Add(Me.TextBoxBirthDate)
      Me.Controls.Add(Me.TextBoxLastName)
      Me.Controls.Add(Me.TextBoxFirstName)
      Me.Controls.Add(Me.Label5)
      Me.Controls.Add(Me.Label4)
      Me.Controls.Add(Me.Label3)
      Me.Controls.Add(Me.Label2)
      Me.Controls.Add(Me.Label1)
      Me.Controls.Add(Me.TextBoxNotes)
      Me.Controls.Add(Me.ListBoxNames)
      Me.Name = "Form1"
      Me.Text = "Form1"
      CType(Me.DataSetEmployees1, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region


   Private Sub ListBoxNames_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBoxNames.SelectedValueChanged
      If ListBoxNames.SelectedIndex <> -1 Then
         ' Clear the data bindings on the text boxes
         TextBoxFirstName.DataBindings.Clear()
         TextBoxLastName.DataBindings.Clear()
         TextBoxBirthDate.DataBindings.Clear()
         TextBoxHomePhone.DataBindings.Clear()
         TextBoxNotes.DataBindings.Clear()

         ' Add a new binding, with a new data source: the selected row
         TextBoxFirstName.DataBindings.Add("Text", DataSetEmployees1.Employees.Rows(ListBoxNames.SelectedIndex), "FirstName")
         TextBoxLastName.DataBindings.Add("Text", DataSetEmployees1.Employees.Rows(ListBoxNames.SelectedIndex), "LastName")
         TextBoxBirthDate.DataBindings.Add("Text", DataSetEmployees1.Employees.Rows(ListBoxNames.SelectedIndex), "BirthDate")
         TextBoxHomePhone.DataBindings.Add("Text", DataSetEmployees1.Employees.Rows(ListBoxNames.SelectedIndex), "HomePhone")
         TextBoxNotes.DataBindings.Add("Text", DataSetEmployees1.Employees.Rows(ListBoxNames.SelectedIndex), "Notes")
      End If
   End Sub

   Private Sub TextBox_Validated(ByVal sender As Object, ByVal e As System.EventArgs) Handles _
      TextBoxNotes.Validated, TextBoxLastName.Validated, TextBoxBirthDate.Validated, _
      TextBoxFirstName.Validated, TextBoxHomePhone.Validated
      ' Open the connection
      SqlConnectionNorthwind.Open()

      ' Update
      SqlDataAdapterEmployees.Update(DataSetEmployees1, "Employees")

      ' Refresh the data in the dataset
      SqlDataAdapterEmployees.Fill(DataSetEmployees1)

      ' Close the connection
      SqlConnectionNorthwind.Close()
   End Sub
End Class
