//------------------------------------------------------------------------------
// <copyright file="WebAdminPage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System.Collections;
    using System.Configuration;
    using System.Diagnostics;
    using System.Globalization;
    using System.Security;
    using System.Text;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.Management;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public class WebAdminPage : WebAdminBasePage {
        private const string CURRENT_PROVIDER = "WebAdminCurrentProvider";
        private const string CURRENT_ROLE = "WebAdminCurrentRoleName";
        private const string CURRENT_USER = "WebAdminCurrentUser";
        private const string CURRENT_USER_COLLECTION = "WebAdminUserCollection";
        private const string URL_STACK = "WebAdminUrlStack";

        // CategoryEnabledHash is used to determine whether given categories are enabled in machine.config.
        // We only need one instance per application.
        private static Hashtable _categoryEnabledHash = new Hashtable();
        private NavigationBar _navigationBar = null;

        protected virtual bool CanSetApplicationPath {
            get {
                return false;
            }
        }

        protected string CurrentProvider {
            get {
                return (string)Session[CURRENT_PROVIDER];
            }
            set {
                Session[CURRENT_PROVIDER] = value;
            }
        }

        protected string CurrentRequestUrl {
            get {
                Stack stack = (Stack) Session[URL_STACK];
                if (stack != null && stack.Count > 0) {
                    return(string)stack.Peek();
                }
                return string.Empty;
            }
        }

        protected string CurrentRole {
            get {
                return (string)Session[CURRENT_ROLE];
            }
            set {
                Session[CURRENT_ROLE] = value;
            }
        }

        protected string CurrentUser {
            get {
                return (string)Session[CURRENT_USER];
            }
            set {
                Session[CURRENT_USER] = value;
            }
        }

        public Hashtable UserCollection {
            get {
                Hashtable table = (Hashtable) Session[CURRENT_USER_COLLECTION];
                if (table == null) {
                    Session[CURRENT_USER_COLLECTION] = table = new Hashtable();
                }
                return table;
            }
        }

        public NavigationBar NavigationBar {
            get {
                return _navigationBar;
            }
            set {
                _navigationBar = value;
            }
        }

        protected void ClearBadStackPage() {
            Stack stack = (Stack) Session[URL_STACK];
            if (stack == null || stack.Count < 2) {
                return;
            }
            stack.Pop(); // current url
            stack.Pop(); // prev url
            // push current url back on stack.
            if (string.Compare(CurrentRequestUrl, Request.CurrentExecutionFilePath) != 0) {
                PushRequestUrl(Request.CurrentExecutionFilePath);
            }
        }

        public void ClearUserCollection() {
            Session[CURRENT_USER_COLLECTION] = null;
        }

        public static string GetParentPath(string path) {
            Debug.Assert(path != null);
            int trailingSlash = path.LastIndexOf("/");
            string parentPath = path.Substring(0, trailingSlash);

            if (parentPath.Length == 0) {
                parentPath = null;
            }
            return parentPath;
        }

        protected string GetQueryStringAppPath() {
            return Request.QueryString["applicationUrl"];
        }

        protected string GetQueryStringPhysicalAppPath() {
            return Request.QueryString["applicationPhysicalPath"];
        }

        public bool IsCategoryEnabled(string category) {
            object ret = _categoryEnabledHash[category];
            if (ret != null) {
                return (bool) ret;
            }
            WebSiteAdministrationToolSection config = (WebSiteAdministrationToolSection)Context.GetConfig("system.web/webSiteAdministrationTool");
            foreach(WebSiteAdministrationCategorySettings settings in config.CategorySettings) {
                if (settings.Title == category) {
                    _categoryEnabledHash[category] = true;
                    return true;
                }
            }
            _categoryEnabledHash[category] = false;
            return false;
        }

        public bool IsRoleManagerEnabled() {
            RoleManagerSection roleSection = null;
            Configuration config = GetWebConfiguration(ApplicationPath);
            roleSection = (RoleManagerSection)config.GetSection("system.web/roleManager");
            return roleSection.Enabled;
        }

        public bool IsPageCounterEnabled() {
            Configuration config = GetWebConfiguration(ApplicationPath);
            SiteCountersSection siteCountersSection = (SiteCountersSection) config.GetSection("system.web/siteCounters");
            PageCountersElement pageCountersElement = siteCountersSection.PageCounters;
            return pageCountersElement.Enabled;
        }

        public bool IsRuleValid(BaseValidator placeHolderValidator, RadioButton userRadio, TextBox userName, RadioButton roleRadio, DropDownList roles) {
            if (userRadio.Checked && userName.Text.Trim().Length == 0) {
                placeHolderValidator.ErrorMessage = ((string)GetAppResourceObject("GlobalResources", "NonemptyUser"));
                placeHolderValidator.IsValid = false;
                return false;
            }
            if (roleRadio.Checked && roles.SelectedItem == null) {
                placeHolderValidator.ErrorMessage = ((string)GetAppResourceObject("GlobalResources", "NonemptyRole"));
                placeHolderValidator.IsValid = false;
                return false;
            }
            return true;
        }

        public bool IsWindowsAuth() {
            Configuration config = GetWebConfiguration(ApplicationPath);
            AuthenticationSection auth = (AuthenticationSection)config.GetSection("system.web/authentication");
            return auth.Mode == AuthenticationMode.Windows;
        }

        protected void ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e) {
            ListItemType itemType = e.Item.ItemType;
            if ((itemType == ListItemType.Pager) ||
                (itemType == ListItemType.Header) ||
                (itemType == ListItemType.Footer)) {
                return;
            }
            foreach (Control c in e.Item.Cells[0].Controls) {
                LinkButton button = c as LinkButton;
                if (button == null) {
                    continue;
                }
                e.Item.Attributes["onclick"] = GetPostBackClientHyperlink(button, "");
           }
        }

        protected override void OnInit(EventArgs e) {
            string applicationPath = ApplicationPath;
            string queryStringAppPath = GetQueryStringAppPath();
            string applicationPhysicalPath = GetQueryStringPhysicalAppPath();
            string requestAppPath = HttpContext.Current.Request.ApplicationPath;
            string currExFilePath = Request.CurrentExecutionFilePath;

            if (!Request.IsSecureConnection &&
                IsSecureConnectionRequired()){
                Server.Transfer("~/errorNoSSL.aspx");
                return;
            }

            if (queryStringAppPath == "/" ||
                applicationPath == "/" ||
                applicationPath == "#" ||                    // special symbol representing any illegal app path
                queryStringAppPath == requestAppPath ||
                applicationPath == requestAppPath
                ) {
                Server.Transfer("~/home0.aspx", false);
                // Gives informative error for illegal app path.
                return;
            }

            // Two pages can set the application path (login.aspx and default.aspx), and
            // If we are not requesting either of those pages and the ApplicationPath is null,
            // the session has timed out, so redirect to the home2.aspx timeout page.

            // Note: request is not for home0.aspx, error.aspx, errorNoSSL.aspx due to OnInit override in those pages.
            if (ApplicationPath == null &&
                !CanSetApplicationPath) {
                Session.Clear();
                Server.Transfer("~/home2.aspx"); // Will display a timeout message.
            }

            if (string.Compare(CurrentRequestUrl, Request.CurrentExecutionFilePath) != 0) {
                PushRequestUrl(Request.CurrentExecutionFilePath);
            }

            base.OnInit(e);
        }

        protected void PopulateRepeaterDataSource(Repeater repeater) {
            ArrayList arr = new ArrayList();
            String chars = ((string)GetAppResourceObject("GlobalResources", "Alphabet"));
            foreach (String s in chars.Split(';')) {
                arr.Add(s);
            }
            arr.Add((string)GetAppResourceObject("GlobalResources", "All"));
            repeater.DataSource = arr;
        }

        protected string PopPrevRequestUrl() {
            Stack stack = (Stack) Session[URL_STACK];
            if (stack == null || stack.Count < 2) {
                return string.Empty;
            }
            stack.Pop(); // discard current url
            return(string) stack.Pop();
        }

        protected void PushRequestUrl(string s) {
            Stack stack = (Stack) Session[URL_STACK];
            if (stack == null) {
                Session[URL_STACK] = stack = new Stack();
            }
            stack.Push(s);
        }

        protected void ReturnToPreviousPage(object s, EventArgs e) {
            string prevRequest = PopPrevRequestUrl();
            Response.Redirect(prevRequest, false);  // note: string.Empty ok here.
        }

        protected void RetrieveLetter(object s, RepeaterCommandEventArgs e, GridView dataGrid) {
            RetrieveLetter(s, e, dataGrid, (string)GetAppResourceObject("GlobalResources", "All"));
        }

        protected void RetrieveLetter(object s, RepeaterCommandEventArgs e, GridView dataGrid, string all) {
            RetrieveLetter(s, e, dataGrid, all, null);
        }

        protected void RetrieveLetter(object s, RepeaterCommandEventArgs e, GridView dataGrid, string all, WebAdminMembershipUserHelperCollection users) {
            dataGrid.PageIndex = 0;
            int total;
            string arg = e.CommandArgument.ToString();

            if (arg == all) {
                dataGrid.DataSource = (users == null) ? MembershipHelperInstance.GetAllUsers(0, Int32.MaxValue, out total) : users;
            }
            else {
                dataGrid.DataSource = MembershipHelperInstance.FindUsersByName(arg + "%", 0, Int32.MaxValue, out total);
            }
            dataGrid.DataBind();
        }

        protected void SetApplicationPath(string user) { // throws SecurityException if access denied.
            string applicationPath = ApplicationPath;
            string queryStringAppPath = GetQueryStringAppPath();
            string applicationPhysicalPath = GetQueryStringPhysicalAppPath();

            if (((queryStringAppPath == null || queryStringAppPath.Length == 0) && applicationPath == null)) {
                Server.Transfer("home0.aspx", false); // Gives informative error for illegal app path.
                return;
            }

            if (queryStringAppPath != null && queryStringAppPath.Length > 0) {
                SetApplicationPath(user, queryStringAppPath);
            }
            else if (applicationPath != null && applicationPath.Length > 0) {
                SetApplicationPath(user, applicationPath); // Reset app path to verify user is authorized
            }
            if (applicationPhysicalPath != null &&
                applicationPhysicalPath.Length > 0) {
                    ApplicationPhysicalPath = applicationPhysicalPath;
            }
            if (!VerifyAppValid()) {
                Server.Transfer("~/home0.aspx"); // gives informative error for illegal app path.
            }
        }

        // At point when app is set, verify it is valid (i.e., permissions are proper and app exists).  To do this for when app is
        // running under IIS and when app is running under Cassini, update config.
        private bool VerifyAppValid() {
            Configuration config = GetWebConfiguration(ApplicationPath);
            try {
                UpdateConfig(config);
            }
            catch {
                return false;
            }
            return true;
        }

        //  Helper to encode the non-ASCII url characters only
        public static String UrlEncodeNonAscii(string str, Encoding e) {
            if (str == null || str.Length == 0)
                return str;
            if (e == null)
                e = Encoding.UTF8;
            byte[] bytes = e.GetBytes(str);
            bytes = UrlEncodeBytesToBytesInternalNonAscii(bytes, 0, bytes.Length, false);
            return Encoding.ASCII.GetString(bytes);
        }

        private static byte[] UrlEncodeBytesToBytesInternalNonAscii(byte[] bytes, int offset, int count, bool alwaysCreateReturnValue) {
            int cNonAscii = 0;

            // count them first
            for (int i = 0; i < count; i++) {
                if ((bytes[offset+i] & 0x80) != 0)
                    cNonAscii++;
            }

            // nothing to expand?
            if (!alwaysCreateReturnValue && cNonAscii == 0)
                return bytes;

            // expand not 'safe' characters into %XX, spaces to +s
            byte[] expandedBytes = new byte[count + cNonAscii*2];
            int pos = 0;

            for (int i = 0; i < count; i++) {
                byte b = bytes[offset+i];

                if ((bytes[offset+i] & 0x80) == 0) {
                    expandedBytes[pos++] = b;
                }
                else {
                    expandedBytes[pos++] = (byte)'%';
                    expandedBytes[pos++] = (byte)IntToHex((b >> 4) & 0xf);
                    expandedBytes[pos++] = (byte)IntToHex(b & 0x0f);
                }
            }

            return expandedBytes;
        }

        private static char IntToHex(int n) {
            if (n <= 9)
                return(char)(n + (int)'0');
            else
                return(char)(n - 10 + (int)'a');
        }
    }
}


