<%@ Page masterPageFile="~/WebAdminWithConfirmation.master" inherits="System.Web.Administration.ProvidersPage" debug="true"%>
<%@ Register TagPrefix="uc" TagName="ProviderSettings" Src="ProviderSettings.ascx"%>
<%@ MasterType virtualPath="~/WebAdminWithConfirmation.master" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Management" %>

<script runat="server" language="cs">

private const string _providerTypeStringSuffix = ", System.Web, Version=2.0.3500.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";

public string OldAccessDescription {
    get {
        string s = (string)ViewState["OldAccessDescription"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldAccessDescription"] = value;
        ProviderInfo.AccessDescription = value;
    }
}

public string OldAccessFileName {
    get {
        string s = (string)ViewState["OldAccessFileName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldAccessFileName"] = value;
        ProviderInfo.AccessFileName = value;
    }
}

public string OldAccessFriendlyName {
    get {
        string s = (string)ViewState["OldAccessFriendlyName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldAccessFriendlyName"] = value;
        ProviderInfo.AccessFriendlyName = value;
    }
}

public ProviderSettings.DatabaseType OldDatabaseType {
    get {
        object o = ViewState["OldDatabaseType"];
        return((o == null) ? ProviderSettings.DatabaseType.Sql : (ProviderSettings.DatabaseType) o);
    }
    set {
        ViewState["OldDatabaseType"] = value;
        ProviderInfo.CurrentDatabaseType = value;
    }
}

public string OldSqlDatabaseName {
    get {
        string s = (string)ViewState["OldSqlDatabaseName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlDatabaseName"] = value;
        ProviderInfo.SqlDatabaseName = value;
    }
}

public string OldSqlDescription {
    get {
        string s = (string)ViewState["OldSqlDescription"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlDescription"] = value;
        ProviderInfo.SqlDescription = value;
    }
}

public string OldSqlFriendlyName {
    get {
        string s = (string)ViewState["OldSqlFriendlyName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlFriendlyName"] = value;
        ProviderInfo.SqlFriendlyName = value;
    }
}

public string OldSqlLoginName {
    get {
        string s = (string)ViewState["OldSqlLoginName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlLoginName"] = value;
        ProviderInfo.SqlLoginName = value;
    }
}

public string OldSqlLoginPassword {
    get {
        string s = (string)ViewState["OldSqlLoginPassword"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlLoginPassword"] = value;
        ProviderInfo.SqlLoginPassword = value;
    }
}

public bool OldSqlMixedMode {
    get {
        object o = ViewState["OldSqlMixedMode"];
        return((o == null) ? false : (bool) o);
    }
    set {
        ViewState["OldSqlMixedMode"] = value;
        ProviderInfo.SqlMixedMode = value;
    }
}

public string OldSqlServerName {
    get {
        string s = (string)ViewState["OldSqlServerName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["OldSqlServerName"] = value;
        ProviderInfo.SqlServerName = value;
    }
}

private string SqlLoginPassword {
    get {
        return (string)Session["SqlLoginPassword"];
	}
    set {
        Session["SqlLoginPassword"] = value;
	}
}

private bool EditMode {
    get {
        object s = ViewState["EditMode"];
        return (s == null) ? false: (bool)s;
    }
    set {
        ViewState["EditMode"] = value;
    }
}

private string EditedProviderName {
    get {
        object s = ViewState["EditedProviderName"];
        return (s == null) ? string.Empty : (string)s;
    }
    set {
        ViewState["EditedProviderName"] = value;
    }
}

private string ServiceName {
    get {
        string s = (string)ViewState["ServiceName"];
        return (s == null) ? string.Empty : (string)s;
    }
    set {
        ViewState["ServiceName"] = value;
    }
}

private System.Configuration.ProviderSettings AddCommonProvider(ProviderSettingsCollection providers,
                                                                string friendlyName,
                                                                string connectionStringName,
                                                                string description,
                                                                string type) {
    System.Configuration.ProviderSettings ps = new System.Configuration.ProviderSettings();
    string editedProviderName = EditedProviderName;
    if (EditMode && providers[editedProviderName] != null) {
        providers.Remove(editedProviderName);
    }
    AddCommonProviderParameters(ps, friendlyName, connectionStringName, description, type);

    if (friendlyName != editedProviderName && providers[friendlyName] != null) {
        providers.Remove(friendlyName);
    }
    providers.Add(ps);
    return ps;
}

private void AddCommonProviderParameters(System.Configuration.ProviderSettings ps, string friendlyName, string connectionStringName, string description, string type) {
    ps.Name = friendlyName;
    ps.Parameters["connectionStringName"] = connectionStringName;
    ps.Parameters["applicationName"] = ApplicationPath;
    ps.Parameters["description"] = description; // ProviderInfo.AccessDescription;    
    ps.Type = type;// "System.Web.Security.AccessMembershipProvider, System.Web, Version=2.0.3500.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
}

private void AddMembershipProvider(Configuration config, string friendlyName, string connectionStringName, string description, string type) {
    MembershipSection membershipSection = (MembershipSection) config.GetSection("system.web/membership");
    System.Configuration.ProviderSettings ps = AddCommonProvider(membershipSection.Providers, friendlyName, connectionStringName, description, type);
    SetProviderProperties(ps, RequiresUniqueEmail, supportsPasswordRetrieval, supportsPasswordReset, StorePasswordSecure, requiresQuestionAndAnswer);
    membershipSection.DefaultProvider = friendlyName;
}


public void SetProviderProperties(System.Configuration.ProviderSettings ps, CheckBox requiresUniqueEmail, CheckBox supportsPasswordRetrieval, CheckBox supportsPasswordReset, CheckBox storePasswordSecure, CheckBox requiresQuestionAndAnswer) {
    ps.Parameters["requiresUniqueEmail"] = requiresUniqueEmail.Checked.ToString().ToLower(CultureInfo.InvariantCulture);
    ps.Parameters["enablePasswordRetrieval"] = supportsPasswordRetrieval.Checked.ToString().ToLower(CultureInfo.InvariantCulture);
    ps.Parameters["enablePasswordReset"] = supportsPasswordReset.Checked.ToString().ToLower(CultureInfo.InvariantCulture);
    ps.Parameters["requiresQuestionAndAnswer"] = requiresQuestionAndAnswer.Checked.ToString().ToLower(CultureInfo.InvariantCulture);
    if (!supportsPasswordRetrieval.Checked) {
        ps.Parameters["passwordFormat"] = "Hashed";
    }
    else {
        if (storePasswordSecure.Checked) {
            ps.Parameters["passwordFormat"] = "Encrypted";
        }
        else {
            ps.Parameters["passwordFormat"] = "Clear";
        }
    }
}
        
private void AddRoleManagerProvider(Configuration config, string friendlyName, string connectionStringName, string description, string type) {
    RoleManagerSection roleManagerSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
    AddCommonProvider(roleManagerSection.Providers, friendlyName, connectionStringName, description, type);
    // this is set at 'section' level
    roleManagerSection.Domain = RoleDomainTextBox.Text;
    roleManagerSection.DefaultProvider = friendlyName;
}

private void AddProfileProvider(Configuration config, string friendlyName, string connectionStringName, string description, string type) {
    ProfileSection profileSection = (ProfileSection)config.GetSection("system.web/profile");
    AddCommonProvider(profileSection.Providers, friendlyName, connectionStringName, description, type);
    profileSection.DefaultProvider = friendlyName;
}

private void AddSiteCountersProvider(Configuration config, string friendlyName, string connectionStringName, string description, string type) {
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    System.Configuration.ProviderSettings ps = AddCommonProvider(siteCountersSection.Providers, friendlyName, connectionStringName, description, type);
    SetSiteCountersProviderSettings(ps, CommitIntervalTextBox.Text, CommitTimeoutTextBox.Text);
    siteCountersSection.DefaultProvider = friendlyName;
}

private void AddPageCountersProvider(Configuration config, string friendlyName, string connectionStringName, string description, string type) {
    SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
    System.Configuration.ProviderSettings ps = AddCommonProvider(siteCountersSection.Providers, friendlyName, connectionStringName, description, type);
    SetSiteCountersProviderSettings(ps, CommitIntervalTextBox.Text, CommitTimeoutTextBox.Text);
    siteCountersSection.PageCounters.DefaultProvider = friendlyName;
}

void BackToPreviousPage(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

private void CreateAccessDB() {
    const string accessMembershipProviderType = "System.Web.Security.AccessMembershipProvider" + _providerTypeStringSuffix;
    const string accessRoleProviderType = "System.Web.Security.AccessRoleProvider" + _providerTypeStringSuffix;
    const string accessProfileProviderType = "System.Web.Profile.AccessProfileProvider" + _providerTypeStringSuffix;
    const string accessSiteCountersProviderType = "System.Web.AccessSiteCountersProvider" + _providerTypeStringSuffix;

    const string fileExt = ".mdb";
    string fileText = ProviderInfo.AccessFileName.Trim();
    if (fileText.Length < fileExt.Length ||
        string.Compare(fileText, fileText.Length - fileExt.Length, fileExt, 0, fileExt.Length, true, CultureInfo.InvariantCulture) != 0) {
        fileText += fileExt;
    }

    string connectionStringName = "webAdminConnection" + DateTime.Now.Ticks.ToString();
    string path = ApplicationPhysicalPath != null ? ApplicationPhysicalPath : Server.MapPath(ApplicationPath);
    string pathData = path + @"\DATA";
    Configuration config = GetWebConfiguration(ApplicationPath);
    string serviceName = ServiceName;
    string accessFriendlyName = ProviderInfo.AccessFriendlyName;
    string accessDescription = ProviderInfo.AccessDescription;
    if (serviceName == "all") {
        AddMembershipProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessMembershipProviderType);
        AddRoleManagerProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessRoleProviderType);
        AddProfileProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessProfileProviderType);
        AddSiteCountersProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessSiteCountersProviderType);

        // For PageCounters, make the default provider empty to pick up the default config from SiteCounters.
        SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
        siteCountersSection.PageCounters.DefaultProvider = null;
    }
    else if (serviceName == "membership") {
        AddMembershipProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessMembershipProviderType);
    }
    else if (serviceName == "roleManager") {
        AddRoleManagerProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessRoleProviderType);
    }
    else if (serviceName == "profile") {
        AddProfileProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessProfileProviderType);
    }
    else if (serviceName == "siteCounters") {
        AddSiteCountersProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessSiteCountersProviderType);
    }
    else if (serviceName == "pageCounters") {
        AddPageCountersProvider(config, accessFriendlyName, connectionStringName, accessDescription, accessSiteCountersProviderType);
    }
    else {
        throw new HttpException((string)GetPageResourceObject("UnrecognizedService") + serviceName);
    }

    CurrentProvider = accessFriendlyName;

    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    css.ConnectionString = "DATA\\" + fileText;
    connectionStringSection.ConnectionStrings.Add(css);
    addProviderLiteral.Text = ProviderInfo.AccessFriendlyName;

    CreateAccessFile(pathData,fileText);
    UpdateConfig(config); 
}

public void CreateSQLDB() {
    string connectionStringName = "webAdminConnection" + DateTime.Now.Ticks.ToString();
    WebSiteAdministrationToolSection waConfig = (WebSiteAdministrationToolSection)Context.GetConfig("system.web/webSiteAdministrationTool");

    // Only install sql db if the config is local only.
    if (waConfig.LocalOnly) {
        try {
            if (ProviderInfo.SqlMixedMode) {
                SqlServices.Install(ProviderInfo.SqlServerName, ProviderInfo.SqlLoginName,
                                    SqlLoginPassword, ProviderInfo.SqlDatabaseName, SqlFeatures.All);
            }
            else {
                SqlServices.Install(ProviderInfo.SqlServerName, ProviderInfo.SqlDatabaseName, SqlFeatures.All);
            }
        }
        catch (Exception ex) {
            WebAdminBasePage.SetCurrentException(Context, ex);
            Response.Redirect("~/error.aspx"); // Reports problem with selected provider and allows user to try to fix it.
            return;
        }
    }

    const string sqlMembershipProviderType = "System.Web.Security.SqlMembershipProvider" + _providerTypeStringSuffix;
    const string sqlRoleProviderType = "System.Web.Security.SqlRoleProvider" + _providerTypeStringSuffix;
    const string sqlProfileProviderType = "System.Web.Profile.SqlProfileProvider" + _providerTypeStringSuffix;
    const string sqlSiteCountersProviderType = "System.Web.SqlSiteCountersProvider" + _providerTypeStringSuffix;

    Configuration config;
    config = GetWebConfiguration(ApplicationPath);
    System.Configuration.ProviderSettings ps = new System.Configuration.ProviderSettings();

    string sqlFriendlyName = ProviderInfo.SqlFriendlyName;
    string sqlDescription = ProviderInfo.SqlDescription;
    String serviceName = ServiceName;

    if (serviceName == "all") {
        AddMembershipProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlMembershipProviderType);
        AddRoleManagerProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlRoleProviderType);
        AddProfileProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlProfileProviderType);
        AddSiteCountersProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlSiteCountersProviderType);

        // For PageCounters, make the default provider empty to pick up the default config from SiteCounters.
        SiteCountersSection siteCountersSection = (SiteCountersSection)config.GetSection("system.web/siteCounters");
        siteCountersSection.PageCounters.DefaultProvider = null;
    }
    else if (serviceName == "membership") {
        AddMembershipProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlMembershipProviderType);
    }
    else if (serviceName == "roleManager") {
        AddRoleManagerProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlRoleProviderType);
    }
    else if (serviceName == "profile") {
        AddProfileProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlProfileProviderType);
    }
    else if (serviceName == "siteCounters") {
        AddSiteCountersProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlSiteCountersProviderType);
    }
    else if (serviceName == "pageCounters") {
        AddPageCountersProvider(config, sqlFriendlyName, connectionStringName, sqlDescription, sqlSiteCountersProviderType);
    }
    else {
        throw new HttpException("Unrecognizable service name: " + serviceName);
    }

    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    if (ProviderInfo.SqlMixedMode) {
        css.ConnectionString = "server=" + ProviderInfo.SqlServerName +
                               ";user ID=" + ProviderInfo.SqlLoginName +
                               ";password=" + SqlLoginPassword +
                               ";database=" + ProviderInfo.SqlDatabaseName;
    }
    else {
        css.ConnectionString = "server=" + ProviderInfo.SqlServerName +
                               ";Integrated Security=SSPI;database=" + ProviderInfo.SqlDatabaseName;
    }
    connectionStringSection.ConnectionStrings.Add(css);
    addProviderLiteral.Text = sqlFriendlyName;
    UpdateConfig(config);
}

private void Page_Load() {
    if (!IsPostBack) {
        
        ServiceName = HttpUtility.HtmlDecode(Request["service"]);
        EditMode = Request["edit"] == "1";
        EditedProviderName = HttpUtility.HtmlDecode(Request["name"]);
        if (EditMode) {
            PopulateProperties();
        }
    }
}

private void PopulateMembershipProviderSettings(System.Configuration.ProviderSettings ps) {
    string value = ps.Parameters["requiresUniqueEmail"];
    if (value == null) {
        RequiresUniqueEmail.Checked = true;
    }
    else {
        RequiresUniqueEmail.Checked = Convert.ToBoolean(value, CultureInfo.InvariantCulture);
    }

    value = ps.Parameters["enablePasswordRetrieval"];
    if (value == null) {
        supportsPasswordRetrieval.Checked = false;
    }
    else {
        supportsPasswordRetrieval.Checked = Convert.ToBoolean(value, CultureInfo.InvariantCulture);
    }

    value = ps.Parameters["enablePasswordReset"];
    if (value == null) {
        supportsPasswordReset.Checked = true;
    }
    else {
        supportsPasswordReset.Checked = Convert.ToBoolean(value, CultureInfo.InvariantCulture);
    }

    value = ps.Parameters["requiresQuestionAndAnswer"];
    if (value == null) {
        requiresQuestionAndAnswer.Checked = true;
    }
    else {
        requiresQuestionAndAnswer.Checked = Convert.ToBoolean(value, CultureInfo.InvariantCulture);
    }

    // passwordFormat default is "Hashed"
    value = ps.Parameters["passwordFormat"];
    if (value != null &&
        string.Compare(value, 0, "Clear", 0, value.Length, true, CultureInfo.InvariantCulture) == 0) {
        StorePasswordSecure.Checked = false;
    }

    StorePasswordSecure.Enabled = supportsPasswordRetrieval.Checked;
}

private void PopulateRoleProviderSettings(RoleManagerSection roleManagerSection) {
    string value = roleManagerSection.Domain;
    if (value == null) {
        RoleDomainTextBox.Text = "";
    }
    else {
        RoleDomainTextBox.Text = value;
    }
}

private void PopulateProperties() {
    string serviceName = ServiceName;
    string friendlyName = EditedProviderName;

    Configuration config = GetWebConfiguration(ApplicationPath);
    System.Configuration.ProviderSettings ps = null;

    if (serviceName == "all" ||
        serviceName == "membership") {
        MembershipSection membershipSection = (MembershipSection) config.GetSection("system.web/membership");
        ps = membershipSection.Providers[friendlyName];
        PopulateMembershipProviderSettings(ps);
        SetOldDatabaseType(ps, "SqlMembershipProvider", "AccessMembershipProvider");

        if (serviceName == "all") {
            SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
            PopulateSiteCountersProviderSettings(siteCountersSection.Providers[friendlyName]);
        }

        if (serviceName == "all") {
            RoleManagerSection roleManagerSection = (RoleManagerSection) config.GetSection("system.web/roleManager");
            PopulateRoleProviderSettings(roleManagerSection);
        }

    }
    else if (serviceName == "roleManager") {
        RoleManagerSection roleManagerSection = (RoleManagerSection) config.GetSection("system.web/roleManager");
        ps = roleManagerSection.Providers[friendlyName];
        PopulateRoleProviderSettings(roleManagerSection);
        SetOldDatabaseType(ps, "SqlRoleProvider", "AccessRoleProvider");
    }
    else if (serviceName == "profile") {
        ProfileSection profileSection = (ProfileSection) config.GetSection("system.web/profile");
        ps = profileSection.Providers[friendlyName];
        SetOldDatabaseType(ps, "SqlProfileProvider", "AccessProfileProvider");
    }
    else if (serviceName == "siteCounters" ||
             serviceName == "pageCounters") {
        SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
        ps = siteCountersSection.Providers[friendlyName];
        PopulateSiteCountersProviderSettings(ps);
        SetOldDatabaseType(ps, "SqlSiteCountersProvider", "AccessSiteCountersProvider");
    }
    else {
        throw new HttpException("Unrecognizable service name: " + serviceName);
    }

    string description = ps.Parameters["description"];
    string connectionStringName = ps.Parameters["connectionStringName"];
    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");

    // Review: Current Management API doesn't allow retrieve a connection string setting via direct name look up
    // Need to create an object with the name set for looking up instead.
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    css = connectionStringSection.ConnectionStrings[connectionStringSection.ConnectionStrings.IndexOf(css)];
    string connectionString = css.ConnectionString;

    // Determine which database type
    if (OldDatabaseType == ProviderSettings.DatabaseType.Sql) {
        string serverName;
        string databaseName;

        if (connectionString.IndexOf("Integrated Security=") != -1) {
            ParseSqlConnectionString(connectionString, out serverName, out databaseName);
            OldSqlMixedMode = false;
        }
        else {
            string loginName;
            string loginPassword;
            ParseSqlConnectionString(connectionString, out serverName, out databaseName,
                                     out loginName, out loginPassword);

            // Track data form comparison later and populate data to the user control
            OldSqlLoginName = loginName;
            OldSqlLoginPassword = loginPassword;
            OldSqlMixedMode = true;
        }

        // Track data for comparison later and populate data to the user control
        OldSqlFriendlyName = friendlyName;
        OldSqlServerName = serverName;
        OldSqlDatabaseName = databaseName;
        OldSqlDescription = description;
    }
    else {
        string fileName = ParseAccessConnectionString(connectionString);

        // Track data form comparison later and populate data to the user control
        OldAccessFriendlyName = friendlyName;
        OldAccessFileName = fileName;
        OldAccessDescription = description;
    }
}

private void PopulateSiteCountersProviderSettings(System.Configuration.ProviderSettings ps) {
    string value = ps.Parameters["commitInterval"];
    if (value == null) {
        CommitIntervalTextBox.Text = "90";
    }
    else {
        CommitIntervalTextBox.Text = value;
    }

    value = ps.Parameters["commitTimeout"];
    if (value == null) {
        CommitTimeoutTextBox.Text = "60";
    }
    else {
        CommitTimeoutTextBox.Text = value;
    }
}

private void SaveClick(object s, EventArgs e) {
    SqlLoginPassword = ProviderInfo.SqlLoginPassword;

    if (EditMode) {
        actionLiteral.Text = "edited";
        successLiteral.Text = String.Format((string)GetPageResourceObject("Success"), actionLiteral.Text, addProviderService.Text, addProviderLiteral.Text);
        AddAnotherButton.Visible = false;
    }

    string serviceName = ServiceName;
    if (serviceName == "membership" || serviceName == "all") {
        mv1.ActiveViewIndex = 1;
        return;
    }
    else if (serviceName == "siteCounters" ||
             serviceName == "pageCounters") {
        mv1.ActiveViewIndex = 2;
        return;
    }
    else if (serviceName == "roleManager") {
        mv1.ActiveViewIndex = 3;
        return;
    }


    if (ProviderInfo.CurrentDatabaseType == ProviderSettings.DatabaseType.Access) {
        CreateAccessDB();
    }
    else {
        CreateSQLDB();
    }

    // No need to go to confirmation page if in edit mode
    if (EditMode) {
        ReturnToPreviousPage(s, e);
    }

    string service;
    if (ServiceName == "roleManager") {
        service = "RoleManager";
    }
    else {
        service = "Profile";
    }

    addProviderService.Text = service;
    successLiteral.Text = String.Format((string)GetPageResourceObject("Success"), actionLiteral.Text, addProviderService.Text, addProviderLiteral.Text);
    Master.SetDisplayUI(true);
}

private void SaveMembership(object s, EventArgs e) {
    if (ServiceName == "all") {
        mv1.ActiveViewIndex = 2;
        return;
    }

    if (ProviderInfo.CurrentDatabaseType == ProviderSettings.DatabaseType.Access) {
        CreateAccessDB();
    }
    else {
        CreateSQLDB();
    }

    mv1.ActiveViewIndex = 0;

    // No need to go to confirmation page if in edit mode
    if (EditMode) {
        ReturnToPreviousPage(s, e);
    }

    string service;
    if (ServiceName == "membership") {
        service = "Membership";
    }
    else {
        service = "";
    }
    addProviderService.Text = service;
    successLiteral.Text = String.Format((string)GetPageResourceObject("Success"), actionLiteral.Text, addProviderService.Text, addProviderLiteral.Text);
    Master.SetDisplayUI(true);
}

private void SaveSiteCounters(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    if (ServiceName == "all") {
        mv1.ActiveViewIndex = 3;
        return;
    }

    if (ProviderInfo.CurrentDatabaseType == ProviderSettings.DatabaseType.Access) {
        CreateAccessDB();
    }
    else {
        CreateSQLDB();
    }

    mv1.ActiveViewIndex = 0;

    // No need to go to confirmation page if in edit mode
    if (EditMode) {
        ReturnToPreviousPage(s, e);
    }

    string service;
    if (ServiceName == "siteCounters") {
        service = "SiteCounters";
    }
    else if (ServiceName == "pageCounters") {
        service = "PageCounters";
    }
    else {
        service = "";
    }
    addProviderService.Text = service;
    successLiteral.Text = String.Format((string)GetPageResourceObject("Success"), actionLiteral.Text, addProviderService.Text, addProviderLiteral.Text);
    Master.SetDisplayUI(true);
}

private void SaveRole(object s, EventArgs e) {
    if (!IsValid) {
        return;
    }

    if (ProviderInfo.CurrentDatabaseType == ProviderSettings.DatabaseType.Access) {
        CreateAccessDB();
    }
    else {
        CreateSQLDB();
    }

    mv1.ActiveViewIndex = 0;

    // No need to go to confirmation page if in edit mode
    if (EditMode) {
        ReturnToPreviousPage(s, e);
    }

    string service;
    if (ServiceName == "roleManager") {
        service = "RoleManager";
    }
    else {
        service = "";
    }
    addProviderService.Text = service;
    successLiteral.Text = String.Format((string)GetPageResourceObject("Success"), actionLiteral.Text, addProviderService.Text, addProviderLiteral.Text);
    Master.SetDisplayUI(true);
}

private void SetOldDatabaseType(System.Configuration.ProviderSettings ps,
                                string sqlProviderName,
                                string accessProviderName) {
    string type = ps.Type;

    // TODO: Culture dependent string lookup
    if (type.IndexOf(sqlProviderName) != -1) {
        OldDatabaseType = ProviderSettings.DatabaseType.Sql;
    }
    else if (type.IndexOf(accessProviderName) != -1) {
        OldDatabaseType = ProviderSettings.DatabaseType.Access;
    }
    else {
        throw new HttpException((string)GetPageResourceObject("ExceptionText"));
    }
}

private void SetSiteCountersProviderSettings(System.Configuration.ProviderSettings ps,
                                             string commitIntervalString,
                                             string commitTimeoutString) {
    ps.Parameters["commitInterval"] = commitIntervalString;
    ps.Parameters["commitTimeout"] = commitTimeoutString;

    // applicationName is set in AddCommonProvider method but it is not recognized
    // by SiteCounters provider
    ps.Parameters["applicationName"] = null;
}

private void SupportsPasswordRetrievalChanged(object s, EventArgs e) {
    CheckBox c = (CheckBox)s;
    if (!c.Checked) {
        StorePasswordSecure.Checked = true;
        StorePasswordSecure.Enabled = false;
        return;
    }
    StorePasswordSecure.Enabled = true;
}

// Confirmation's related handlers
void AddAnother_Click(object s, EventArgs e) {
    ProviderInfo.ResetUI();
    Master.SetDisplayUI(false);
}

void OK_Click0(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

void OK_Click1(object s, EventArgs e) {
    Mv0.ActiveViewIndex = 0;
    Master.SetDisplayUI(false);
}

void TestClick(object s, EventArgs e) {
    string connectionString;
    if (ProviderInfo.SqlMixedMode) {
        connectionString = "server=" + ProviderInfo.SqlServerName +
                               ";user ID=" + ProviderInfo.SqlLoginName +
                               ";password=" + SqlLoginPassword +
                               ";database=" + ProviderInfo.SqlDatabaseName;
    }
    else {
        connectionString = "server=" + ProviderInfo.SqlServerName +
                               ";Integrated Security=SSPI;database=" + ProviderInfo.SqlDatabaseName;
    }
    TestConnectionLiteral.Text = TestConnectionText(TestConnection(connectionString, true /* sql */), true /* sql */, ProviderInfo.SqlDatabaseName);
    Mv0.ActiveViewIndex = 1;
    OKButton0.Visible = false;
    OKButton1.Visible = true;
    AddAnotherButton.Visible = false;
    Master.SetDisplayUI(true /* confirmation */);
}

</script>

<%-- Main Content --%>
<asp:content runat="server" contentplaceholderid="titleBar">
<asp:literal runat="server" text="<%$ Resources:AddProvider %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <asp:multiview runat="server" id="mv1" activeviewindex="0">
        <asp:view runat="server">
            <uc:ProviderSettings runat="server" id="ProviderInfo" OnSaveClick="SaveClick" OnTestClick="TestClick"/>
        </asp:view>
        <asp:view runat=server>
        <asp:literal runat="server" text="<%$ Resources:Instructions %>"/>
            <%-- Membership settings dialog --%>
            <table height="100%" width="100%">
                <tr height="70%">
                    <td>
                        <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                               bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                            <tr class="callOutStyle">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <asp:literal runat="server" text="<%$ Resources:AddProvider %>"/>
                                </td>
                            </tr>
                            <tr class="bodyText" height="100%" valign="top">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <table cellpadding="0" cellspacing="3" border="0" style="position:relative; top:-15;" width="100%">
                                        <tr><td colspan="2">&nbsp;</td></tr>
                                        <tr><td colspan="2"></td></tr>
                                        <tr>
                                            <td class="bodyTextNoPadding">
                                                <asp:checkbox runat="server" id="RequiresUniqueEmail"/>
                                            </td>
                                            <td class="bodyTextNoPadding">
                                                <asp:label runat="server" associatedcontrolid="RequiresUniqueEmail" font-bold="true" text="<%$ Resources:RequireUnique %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:RequireUniqueExplanation %>"/><br/><br/>
                                            </td>
                                         </tr>
                                         <tr>
                                            <td class="bodyTextNoPadding">
                                                <asp:checkbox runat="server" id="supportsPasswordRetrieval" autopostback="true" checked="false" oncheckedchanged="SupportsPasswordRetrievalChanged"/>
                                            </td>
                                            <td class="bodyTextNoPadding">
                                                <asp:label runat="server" associatedcontrolid="supportsPasswordRetrieval" font-bold="true" text="<%$ Resources:SupportRetrieval %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:SupportRetrievalExplanation %>"/><br/>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <asp:checkbox runat="server" id="StorePasswordSecure" checked="true" enabled="false"/><asp:label runat="server" associatedcontrolid="StorePasswordSecure" font-bold="true" text="<%$ Resources:StoreSecure %>"/>
                                                <br/><br/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bodyTextNoPadding">
                                                <asp:checkbox runat="server" id="supportsPasswordReset"/>
                                            </td>
                                            <td class="bodyTextNoPadding">
                                                <asp:label runat="server" associatedcontrolid="supportsPasswordReset" font-bold="true" text="<%$ Resources:SupportReset %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:SupportResetExplanation %>"/><br/><br/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bodyTextNoPadding">
                                                <asp:checkbox runat="server" id="requiresQuestionAndAnswer"/>
                                             </td>
                                             <td class="bodyTextNoPadding"><asp:label runat="server" associatedcontrolid="requiresQuestionAndAnswer" font-bold="true" text="<%$ Resources:RequireQuestionAnswer %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:RequireQuestionAnswerExplanation %>"/><br/><br/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="userDetailsWithFontSize" valign="top" height="5%">
                                <td style="padding-left:10;padding-right:10;" align="left"></td>
                                <td style="padding-left:10;padding-right:10;" align="right" width="1%">
                                    <asp:button runat="server" id="saveMembership" text="<%$ Resources:Save %>" onClick="SaveMembership" width="100" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td/>
                </tr>
                <tr><td colspan="2"/></tr>
            </table>
        </asp:view>
        <asp:view runat=server>
            <%-- Provider specific settings for SiteCounters and PageCounters --%>
            <asp:literal runat="server" text="<%$ Resources:ProviderInstructions %>"/>
            <br/><br/>
            <table height="100%" width="100%">
                <tr height="70%">
                    <td>
                        <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                               bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                            <tr class="callOutStyle">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <asp:literal runat="server" text="<%$ Resources:CounterSettings %>"/>
                                </td>
                            </tr>
                            <tr class="bodyText" height="100%" valign="top">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <table cellpadding="0" cellspacing="3" border="0" style="position:relative; top:-15;" width="100%">
                                        <tr><td colspan="2">&nbsp;</td></tr>
                                        <tr>
                                            <td class="bodyTextNoPadding" colspan="2">
                                                <%-- An invisible textbox at the end of the line is to submit the page on enter, raising server side onclick --%>
                                                <asp:label runat="server" AssociatedControlID="CommitIntervalTextBox" Text="<%$ Resources:CommitInterval %>"/>&nbsp;<asp:TextBox runat="server" id="CommitIntervalTextBox" Text="90" width="50"/><input type="text" style="visibility:hidden;width:0px;"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="5%"/>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:SpecifyHowOften %>"/><br/><br/>
                                            </td>
                                         </tr>
                                         <tr>
                                            <td class="bodyTextNoPadding" colspan="2">
                                                <asp:label runat="server" AssociatedControlID="CommitTimeoutTextBox" Text="<%$ Resources:CommitTimeout %>"/>&nbsp;<asp:TextBox runat="server" id="CommitTimeoutTextBox" Text="60" width="50"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="5%"/>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:SpecifyHowLong %>"/><br/><br/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bodyTextNoPadding" colspan="2">
                                                <asp:ValidationSummary runat="server" HeaderText="<%$ Resources:GlobalResources,ErrorHeader %>"
                                                                       ValidationGroup="SiteCountersSettings"/>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="CommitIntervalTextBox"
                                                                            ErrorMessage="<%$ Resources:CommitIntervalNonempty %>" Display="none"
                                                                            ValidationGroup="SiteCountersSettings"/>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="CommitTimeoutTextBox"
                                                                            ErrorMessage="<%$ Resources:CommitTimeoutNonempty %>" Display="none"
                                                                            ValidationGroup="SiteCountersSettings"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="userDetailsWithFontSize" valign="top" height="5%">
                                <td style="padding-left:10;padding-right:10;" align="left"></td>
                                <td style="padding-left:10;padding-right:10;" align="right" width="1%">
                                    <asp:button runat="server" text="<%$ Resources:Save %>" onClick="SaveSiteCounters" width="100" ValidationGroup="SiteCountersSettings"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td/>
                </tr>
                <tr><td colspan="2"/></tr>
            </table>
        </asp:view>
        <asp:view runat=server>
            <%-- Provider specific settings for Role Manager --%>
            <asp:literal runat="server" text="<%$ Resources:RoleProviderInstructions %>"/>
            <br/><br/>
            <table height="100%" width="100%">
                <tr height="70%">
                    <td>
                        <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                               bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                            <tr class="callOutStyle">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <asp:literal runat="server" text="<%$ Resources:RoleProviderSettings %>"/>
                                </td>
                            </tr>
                            <tr class="bodyText" height="100%" valign="top">
                                <td style="padding-left:10;padding-right:10;" colspan="3">
                                    <table cellpadding="0" cellspacing="3" border="0" style="position:relative; top:-15;" width="100%">
                                        <tr><td colspan="2">&nbsp;</td></tr>
                                        <tr>
                                            <td class="bodyTextNoPadding" colspan="2">
                                                <%-- An invisible textbox at the end of the line is to submit the page on enter, raising server side onclick --%>
                                                <asp:label runat="server" AssociatedControlID="RoleDomainTextBox" Text="Cookie Domain:"/>&nbsp;<asp:TextBox runat="server" id="RoleDomainTextBox" Text="" width="170"/><input type="text" style="visibility:hidden;width:0px;"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="5%"/>
                                            <td class="bodyTextNoPadding">
                                                <asp:literal runat="server" text="<%$ Resources:RoleDomain %>"/><br/><br/>
                                            </td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="userDetailsWithFontSize" valign="top" height="5%">
                                <td style="padding-left:10;padding-right:10;" align="left"></td>
                                <td style="padding-left:10;padding-right:10;" align="right" width="1%">
                                    <asp:button runat="server" text="<%$ Resources:Save %>" onClick="SaveRole" width="100"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td/>
                </tr>
                <tr><td colspan="2"/></tr>
            </table>
        </asp:view>
    </asp:multiview>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:Back%>" id="BackButton" onclick="BackToPreviousPage" runat="server"/>
</asp:content>

<%-- Confirmation Dialog --%>
<asp:content runat="server" contentplaceholderid="dialogTitle">
<asp:literal runat="server" text="<%$ Resources:AddProvider %>" />        
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogContent">
    <asp:multiview runat="server" id="Mv0" activeviewindex="0" enableViewState="false">
        <asp:view runat="server" enableViewState=false>
            <%-- Literals are placeholders for storing their strings in viewstate. --%>
            <asp:Literal runat="server" id="actionLiteral" text="created" visible="false"/> <%-- {0} --%>
            <asp:Literal runat=server id="addProviderService" visible="false"/> <%-- <b>{1}</b> --%> 
            <asp:Literal runat=server id="addProviderLiteral" visible="false"/> <%-- "<b>{2}</b>" --%>

            <asp:literal runat="server" id="successLiteral"/>
        </asp:view>
        <asp:view runat="server">
            <asp:Literal runat="server" id="TestConnectionLiteral"/>
        </asp:view>
    </asp:multiview>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomLeftButton">
    <asp:Button runat="server" id="AddAnotherButton" enableViewState="false" OnClick="AddAnother_Click" Text="<%$ Resources:GlobalResources,AddAnotherButtonLabel %>" width="100"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="dialogBottomRightButton">
    <asp:Button runat="server" id="OKButton0" enableViewState="false" OnClick="OK_Click0" Text="OK" width="75"/>
    <asp:Button runat="server" id="OKButton1" enableViewState="false" OnClick="OK_Click1" Text="OK" width="75" visible="false"/>
</asp:content>
