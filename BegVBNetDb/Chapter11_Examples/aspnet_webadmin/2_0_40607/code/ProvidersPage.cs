//------------------------------------------------------------------------------
// <copyright file="ProvidersPage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System;
    using System.Configuration;
    using System.Globalization;
    using System.Security;
    
    public class ProvidersPage : WebAdminPage {
        
        protected string GetConnectionString(string connectionStringName) {
            Configuration config = GetWebConfiguration(ApplicationPath);
            ConnectionStringsSection connectionStringSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
        
            // Review: Current Management API doesn't allow retrieve a connection string setting via direct name look up
            // Need to create an object with the name set for looking up instead.
            ConnectionStringSettings css = new ConnectionStringSettings();
            css.Name = connectionStringName;
            css = connectionStringSection.ConnectionStrings[connectionStringSection.ConnectionStrings.IndexOf(css)];
            return css.ConnectionString;               
        }
        
        protected override void OnInit(EventArgs e) {
            if (!IsCategoryEnabled("Provider")) {
                Exception ex = new SecurityException("The functionality you are trying to access is not available.");
                SetCurrentException(Context, ex);
                Server.Transfer("~/error.aspx");
            }
            NavigationBar.SetSelectedIndex(4);
            base.OnInit(e);
        }
        
        protected string ParseAccessConnectionString(string connectionString) {
            int lastDataDirIndex = connectionString.LastIndexOf(@"DATA\");
            if (lastDataDirIndex == -1) {
                        // Unexpected connection string, cannot parse.
                return String.Empty;
            }
        
            return connectionString.Substring(lastDataDirIndex + @"DATA\".Length);
        }
        
        protected void ParseSqlConnectionString(string connectionString, out string serverName, out string databaseName) {
            string[] parameters = connectionString.Split(';');
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
        
        protected void ParseSqlConnectionString(string connectionString,
                                              out string serverName, out string databaseName,
                                              out string loginName, out string loginPassword) {
            string[] parameters = connectionString.Split(';');
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

        protected string TestConnectionText(bool connectionWorks, bool isSql, string dataBase) {
            if (dataBase == null || dataBase.Length == 0) {
                return connectionWorks ? 
                    (string)GetAppResourceObject("GlobalResources", "GenericSuccess") :
                    (string)GetAppResourceObject("GlobalResources", "GenericFailure");
            }

            if (connectionWorks) {
                return String.Format((string)GetAppResourceObject("GlobalResources", "SpecificSuccess"), dataBase);  
                // Successfully established a connection to the database " + dataBase + ".";
            }
            if (!IsConfigLocalOnly()) {
                return String.Format((string)GetAppResourceObject("GlobalResources", "SpecificFailureContactAdmin"), dataBase);
                // "Could not establish a connection to the database: " + dataBase +". Please contact your administrator.";
            }
            if (!isSql) {
                return String.Format((string)GetAppResourceObject("GlobalResources", "SpecificFailure"), dataBase);
                // "Could not establish a connection to the database: " + dataBase;
            }

            return String.Format((string)GetAppResourceObject("GlobalResources", "SpecificFailureCreateDB"), dataBase);
            // "Could not establish a connection to the database: " + dataBase + ".<br/> If you have not yet created the SQL Server database, exit the Web Site Administration tool, use the aspnet_regsql command-line utility to create and configure the database, and then return to this tool to set the provider.";
        }
    }
}


