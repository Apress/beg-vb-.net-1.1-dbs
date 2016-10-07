<%@ Page masterPageFile="~/WebAdminButtonRow.master" inherits="System.Web.Administration.ProvidersPage" %>
<%@ Register TagPrefix="uc" TagName="ProviderSettings" Src="ProviderSettings.ascx"%>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Administration" %>
<%@ Import Namespace="System.Web.Management" %>

<script runat="server" language="cs">

private static readonly char[] _sqlParamsSeparator = {';'};

//------------------------------------------------------------------------------
// For the old properties that keep track of any data changes, the set accessor
// directly populate the data to the user control as well.  Expecting that the
// old properties are set only once.
//------------------------------------------------------------------------------

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

private string ServiceName {
    get {
        string s = (string)ViewState["ServiceName"];
        return((s == null) ? string.Empty : s);
    }
    set {
        ViewState["ServiceName"] = value;
    }
}

void BackToPreviousPage(object s, EventArgs e) {
    ReturnToPreviousPage(s, e);
}

private void ChangeDescription(ConfigurationSection configSection,
                               string providerName,
                               string newDescription) {
    System.Configuration.ProviderSettings ps = null;

    if (configSection is MembershipSection) {
        MembershipSection membershipSection = (MembershipSection) configSection;
        ps = membershipSection.Providers[providerName];
    }
    else if (configSection is RoleManagerSection) {
        RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
        ps = roleManagerSection.Providers[providerName];
    }
    else {
        ProfileSection profileSection = (ProfileSection) configSection;
        ps = profileSection.Providers[providerName];
    }
    ps.Parameters["description"] = newDescription;
}

private void ChangeFriendlyName(ConfigurationSection configSection,
                                string oldFriendlyName,
                                string newFriendlyName) {
    System.Configuration.ProviderSettings ps = null;

    if (configSection is MembershipSection) {
        MembershipSection membershipSection = (MembershipSection) configSection;
        ps = membershipSection.Providers[oldFriendlyName];
        if (membershipSection.DefaultProvider == oldFriendlyName) {
            membershipSection.DefaultProvider = newFriendlyName;
            CurrentProvider = newFriendlyName;
        }
    }
    else if (configSection is RoleManagerSection) {
        RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
        ps = roleManagerSection.Providers[oldFriendlyName];
        if (roleManagerSection.DefaultProvider == oldFriendlyName) {
            roleManagerSection.DefaultProvider = newFriendlyName;
            CurrentProvider = newFriendlyName;
        }
    }
    else {
        ProfileSection profileSection = (ProfileSection) configSection;
        ps = profileSection.Providers[oldFriendlyName];
        if (profileSection.DefaultProvider == oldFriendlyName) {
            profileSection.DefaultProvider = newFriendlyName;
        }
    }
    ps.Name = newFriendlyName;
}

private void ChangeSqlConnectionString(Configuration config, string friendlyName) {
    ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + ServiceName);
    System.Configuration.ProviderSettings ps = null;
    string connectionStringName;

    if (configSection is MembershipSection) {
        MembershipSection membershipSection = (MembershipSection) configSection;
        ps = membershipSection.Providers[friendlyName];
        connectionStringName = ps.Parameters["connectionStringName"];
    }
    else if (configSection is RoleManagerSection) {
        RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
        ps = roleManagerSection.Providers[friendlyName];
        connectionStringName = ps.Parameters["connectionStringName"];
    }
    else {
        ProfileSection profileSection = (ProfileSection) configSection;
        ps = profileSection.Providers[friendlyName];
        connectionStringName = ps.Parameters["connectionStringName"];
    }

    // Review: Current Management API doesn't allow retrieve a connection string setting via direct name look up
    // Need to create an object with the name set for looking up instead.
    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    css = connectionStringSection.ConnectionStrings[connectionStringSection.ConnectionStrings.IndexOf(css)];
    css.ConnectionString = GetSqlConnectionString();
}

private void CreateAccessDB() {
    string fileText = ProviderInfo.AccessFileName.Trim();
    string connectionStringName = "webAdminConnection" + DateTime.Now.Ticks.ToString();
    string path = ApplicationPhysicalPath != null ? ApplicationPhysicalPath : Server.MapPath(ApplicationPath);
    string pathData = path + @"\DATA";
    Configuration config = GetWebConfiguration(ApplicationPath);
    ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + ServiceName);
    System.Configuration.ProviderSettings ps = new System.Configuration.ProviderSettings();

    string friendlyName = ProviderInfo.AccessFriendlyName;
    ps.Name = friendlyName;
    ps.Parameters["connectionStringName"] = connectionStringName;
    ps.Parameters["applicationName"] = ApplicationPath;
    ps.Parameters["description"] = ProviderInfo.AccessDescription;

    if (configSection is MembershipSection) {
        ps.Type = "System.Web.Security.AccessMembershipProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        MembershipSection membershipSection = (MembershipSection) configSection;
        if (membershipSection.Providers[friendlyName] != null) {
            membershipSection.Providers.Remove(friendlyName);
        }
        else if (membershipSection.Providers[OldAccessFriendlyName] != null) {
            membershipSection.Providers.Remove(OldAccessFriendlyName);
        }
        membershipSection.Providers.Add(ps); 
        membershipSection.DefaultProvider = friendlyName;
        CurrentProvider = friendlyName;
    }
    else if (configSection is RoleManagerSection) {
        ps.Type = "System.Web.Security.AccessRoleProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
        if (roleManagerSection.Providers[friendlyName] != null) {
            roleManagerSection.Providers.Remove(friendlyName);
        }
        else if (roleManagerSection.Providers[OldAccessFriendlyName] != null) {
            roleManagerSection.Providers.Remove(OldAccessFriendlyName);
        }
        roleManagerSection.Providers.Add(ps); 
        roleManagerSection.DefaultProvider = friendlyName;
        CurrentProvider = friendlyName;
    }
    else {
        ps.Type = "System.Web.Security.AccessProfileProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        ProfileSection profileSection = (ProfileSection) configSection;
        if (profileSection.Providers[friendlyName] != null) {
            profileSection.Providers.Remove(friendlyName);
        }
        else if (profileSection.Providers[OldAccessFriendlyName] != null) {
            profileSection.Providers.Remove(OldAccessFriendlyName);
        }
        profileSection.Providers.Add(ps); 
        profileSection.DefaultProvider = friendlyName;
    }

    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    css.ConnectionString = "DATA\\" + fileText + ".mdb";
    connectionStringSection.ConnectionStrings.Add(css);

    CreateAccessFile(pathData,fileText + ".mdb");
    UpdateConfig(config); 
}

public void CreateSQLDB() {
    string connectionStringName = "webAdminConnection" + DateTime.Now.Ticks.ToString();
    try {
        if (ProviderInfo.SqlMixedMode) {
            SqlServices.Install(ProviderInfo.SqlServerName, ProviderInfo.SqlLoginName,
                                ProviderInfo.SqlLoginPassword, ProviderInfo.SqlDatabaseName, SqlFeatures.All);
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

    Configuration config = GetWebConfiguration(ApplicationPath);
    ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + ServiceName);
    System.Configuration.ProviderSettings ps = new System.Configuration.ProviderSettings();

    string friendlyName = ProviderInfo.SqlFriendlyName;
    ps.Name = friendlyName;
    ps.Parameters["connectionStringName"] =  connectionStringName;
    ps.Parameters["applicationName"] = ApplicationPath;
    ps.Parameters["description"] = ProviderInfo.SqlDescription;

    if (configSection is MembershipSection) {
        ps.Type = "System.Web.Security.SqlMembershipProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        MembershipSection membershipSection = (MembershipSection) configSection;
        if (membershipSection.Providers[friendlyName] != null) {
            membershipSection.Providers.Remove(friendlyName);
        }
        else if (membershipSection.Providers[OldSqlFriendlyName] != null) {
            membershipSection.Providers.Remove(OldSqlFriendlyName);
        }
        membershipSection.Providers.Add(ps);
        membershipSection.DefaultProvider = friendlyName;
        CurrentProvider = friendlyName;
    }
    else if (configSection is RoleManagerSection) {
        ps.Type = "System.Web.Security.SqlRoleProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
        if (roleManagerSection.Providers[friendlyName] != null) {
            roleManagerSection.Providers.Remove(friendlyName);
        }
        else if (roleManagerSection.Providers[OldSqlFriendlyName] != null) {
            roleManagerSection.Providers.Remove(OldSqlFriendlyName);
        }
        roleManagerSection.Providers.Add(ps);
        roleManagerSection.DefaultProvider = friendlyName;
        CurrentProvider = friendlyName;
    }
    else {
        ps.Type = "System.Web.Security.SqlProfileProvider, System.Web, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a";
        ProfileSection profileSection = (ProfileSection) configSection;
        if (profileSection.Providers[friendlyName] != null) {
            profileSection.Providers.Remove(friendlyName);
        }
        else if (profileSection.Providers[OldSqlFriendlyName] != null) {
            profileSection.Providers.Remove(OldSqlFriendlyName);
        }
        profileSection.Providers.Add(ps);
        profileSection.DefaultProvider = friendlyName;
    }

    ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
    ConnectionStringSettings css = new ConnectionStringSettings();
    css.Name = connectionStringName;
    css.ConnectionString = GetSqlConnectionString();
    connectionStringSection.ConnectionStrings.Add(css);

    UpdateConfig(config);
}

private void EditAccessDBProvider(string serviceName) {
    if (OldDatabaseType != ProviderInfo.CurrentDatabaseType ||
        String.Compare(OldAccessFileName, ProviderInfo.AccessFileName, true, CultureInfo.InvariantCulture) != 0) {
        CreateAccessDB();
    }
    else {
        if (OldAccessFriendlyName != ProviderInfo.AccessFriendlyName) {
            Configuration config;
            config = GetWebConfiguration(ApplicationPath);
            ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + ServiceName);
            ChangeFriendlyName(configSection, OldAccessFriendlyName, ProviderInfo.AccessFriendlyName);
            UpdateConfig(config);
        }

        if (OldAccessDescription != ProviderInfo.AccessDescription) {
            Configuration config = GetWebConfiguration(ApplicationPath);
            ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + serviceName);
            ChangeDescription(configSection, ProviderInfo.AccessFriendlyName, ProviderInfo.AccessDescription);
            UpdateConfig(config);
        }
    }
}

private void EditSQLDBProvider(string serviceName) {
    if (OldDatabaseType != ProviderInfo.CurrentDatabaseType ||
        String.Compare(OldSqlServerName, ProviderInfo.SqlServerName, true, CultureInfo.InvariantCulture) != 0 ||
        String.Compare(OldSqlDatabaseName, ProviderInfo.SqlDatabaseName, true, CultureInfo.InvariantCulture) != 0) {
        CreateSQLDB();
    }
    else {
        bool currentMixedMode = ProviderInfo.SqlMixedMode;
        if (OldSqlMixedMode != currentMixedMode ||
            (currentMixedMode && String.Compare(OldSqlLoginName, ProviderInfo.SqlLoginName, true, CultureInfo.InvariantCulture) != 0) ||
            (currentMixedMode && String.Compare(OldSqlLoginPassword, ProviderInfo.SqlLoginPassword, true, CultureInfo.InvariantCulture) != 0)) {

            Configuration config = GetWebConfiguration(ApplicationPath);
            ChangeSqlConnectionString(config, ProviderInfo.SqlFriendlyName);
            UpdateConfig(config);
        }

        if (OldSqlFriendlyName != ProviderInfo.SqlFriendlyName) {
            Configuration config = GetWebConfiguration(ApplicationPath);
            ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + serviceName);
            ChangeFriendlyName(configSection, OldSqlFriendlyName, ProviderInfo.SqlFriendlyName);
            UpdateConfig(config);
        }

        if (OldSqlDescription != ProviderInfo.SqlDescription) {
            Configuration config = GetWebConfiguration(ApplicationPath);
            ConfigurationSection configSection = (ConfigurationSection)config.GetSection("system.web/" + ServiceName);
            ChangeDescription(configSection, ProviderInfo.SqlFriendlyName, ProviderInfo.SqlDescription);
            UpdateConfig(config);
        }
    }
}

private string GetSqlConnectionString() {
    if (ProviderInfo.SqlMixedMode) {
        return ("server=" + ProviderInfo.SqlServerName +
                ";user ID=" + ProviderInfo.SqlLoginName +
                ";password=" + ProviderInfo.SqlLoginPassword +
                ";database=" + ProviderInfo.SqlDatabaseName);
    }
    else {
        return ("server=" + ProviderInfo.SqlServerName +
                ";Integrated Security=SSPI;database=" + ProviderInfo.SqlDatabaseName);
    }
}

private void Page_Load() {
    if (!IsPostBack) {
        ServiceName = HttpUtility.HtmlDecode(Request["service"]);
        string serviceName = ServiceName;
        string friendlyName = HttpUtility.HtmlDecode(Request["name"]);

        // Determine which database type
        Configuration config = GetWebConfiguration(ApplicationPath);
        ConfigurationSection configSection;
        if (serviceName == "all") {
            configSection = (ConfigurationSection)config.GetSection("system.web/membership");
        }
        else {
            configSection = (ConfigurationSection)config.GetSection("system.web/" + serviceName);
        }

        System.Configuration.ProviderSettings ps = null;

        if (configSection is MembershipSection) {
            MembershipSection membershipSection = (MembershipSection) configSection;
            ps = membershipSection.Providers[friendlyName];
            string type = ps.Type;

            // TODO: Culture dependent string lookup
            if (type.IndexOf("SqlMembershipProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Sql;
            }
            else if (type.IndexOf("AccessMembershipProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Access;
            }
            else {
                throw new HttpException((string) GetPageResourceObject("OnlySQLAccess"));
            }
        }
        else if (configSection is RoleManagerSection) {
            RoleManagerSection roleManagerSection = (RoleManagerSection) configSection;
            ps = roleManagerSection.Providers[friendlyName];
            string type = ps.Type;

            // TODO: Culture dependent string lookup
            if (type.IndexOf("SqlRoleProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Sql;
            }
            else if (type.IndexOf("AccessRoleProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Access;
            }
            else {
                throw new HttpException((string) GetPageResourceObject("OnlySQLAccess"));
                // throw new HttpException("Currently only SQL and Access database providers can be edited.");
            }
        }
        else if (configSection is ProfileSection) {
            ProfileSection profileSection = (ProfileSection) configSection;
            ps = profileSection.Providers[friendlyName];
            string type = ps.Type;

            // TODO: Culture dependent string lookup
            if (type.IndexOf("SqlProfileProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Sql;
            }
            else if (type.IndexOf("AccessProfileProvider") != -1) {
                OldDatabaseType = ProviderSettings.DatabaseType.Access;
            }
            else {
                throw new HttpException((string) GetPageResourceObject("OnlySQLAccess"));
            }
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

            // Track data form comparison later and populate data to the user control
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
}

private string ParseAccessConnectionString(string connectionString) {
    int lastDataDirIndex = connectionString.LastIndexOf(@"\DATA\");
    if (lastDataDirIndex == -1) {
        throw new HttpException("Unexpected connection string for Access database provider");
    }

    return connectionString.Substring(lastDataDirIndex + 6);
}

private void ParseSqlConnectionString(string connectionString, out string serverName, out string databaseName) {
    string[] parameters = connectionString.Split(_sqlParamsSeparator);
    serverName = null;
    databaseName = null;

    foreach (string param in parameters) {
        if (String.Compare(param, 0, "server=", 0, 7, true, CultureInfo.InvariantCulture) == 0 ||
            String.Compare(param, 0, "data source=", 0, 12, true, CultureInfo.InvariantCulture) == 0) {
            serverName = param.Substring(param.IndexOf('=') + 1);
        }
        else if (String.Compare(param, 0, "database=", 0, 9, true, CultureInfo.InvariantCulture) == 0) {
            databaseName = param.Substring(param.IndexOf('=') + 1);
        }
    }
}

private void ParseSqlConnectionString(string connectionString,
                                      out string serverName, out string databaseName,
                                      out string loginName, out string loginPassword) {
    string[] parameters = connectionString.Split(_sqlParamsSeparator);
    serverName = null;
    databaseName = null;
    loginName = null;
    loginPassword = null;

    foreach (string param in parameters) {
        if (String.Compare(param, 0, "server=", 0, 7, true, CultureInfo.InvariantCulture) == 0 ||
            String.Compare(param, 0, "data source=", 0, 12, true, CultureInfo.InvariantCulture) == 0) {
            serverName = param.Substring(param.IndexOf('=') + 1);
        }
        else if (String.Compare(param, 0, "database=", 0, 9, true, CultureInfo.InvariantCulture) == 0) {
            databaseName = param.Substring(param.IndexOf('=') + 1);
        }
        else if (String.Compare(param, 0, "user ID=", 0, 8, true, CultureInfo.InvariantCulture) == 0) {
            loginName = param.Substring(param.IndexOf('=') + 1);
        }
        else if (String.Compare(param, 0, "password=", 0, 9, true, CultureInfo.InvariantCulture) == 0) {
            loginPassword = param.Substring(param.IndexOf('=') + 1);
        }
    }
}

private void SaveClick(object s, EventArgs e) {
    Response.Write("Save");
    string serviceName = ServiceName;
    if (ProviderInfo.CurrentDatabaseType == ProviderSettings.DatabaseType.Access) {
        if (serviceName == "all") {
            EditAccessDBProvider("membership");
            EditAccessDBProvider("roleManager");
            EditAccessDBProvider("profile");
        }
        else {
            EditAccessDBProvider(serviceName);
        }
    }
    else {
        if (serviceName == "all") {
            EditSQLDBProvider("membership");
            EditSQLDBProvider("roleManager");
            EditSQLDBProvider("profile");
        }
        else {
            EditSQLDBProvider(ServiceName);
        }
    }
    ReturnToPreviousPage(s, e);
}

</script>

<asp:content runat="server" contentplaceholderid="titleBar">
    <asp:literal runat="server" text="<%$ Resources:EditProvider %>"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="content">
    <uc:ProviderSettings runat="server" id="ProviderInfo" OnSaveClick="SaveClick"/>
</asp:content>

<asp:content runat="server" contentplaceholderid="buttons">
    <asp:button text="<%$ Resources:Back %>" id="BackButton" onclick="BackToPreviousPage" runat="server"/>
</asp:content>
