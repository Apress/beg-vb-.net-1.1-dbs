//------------------------------------------------------------------------------
// <copyright file="ApplicationConfigurationPage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System;
    using System.Configuration;
    using System.Globalization;
    using System.Security;
    public class ApplicationConfigurationPage : WebAdminPage {
        protected override void OnInit(EventArgs e) {
            if (!IsCategoryEnabled("Application")) {
                Exception ex = new SecurityException("The functionality you are trying to access is not available.");
                SetCurrentException(Context, ex);
                Server.Transfer("~/error.aspx");
            }
            NavigationBar.SetSelectedIndex(3);
            base.OnInit(e);
        }
    }
}


