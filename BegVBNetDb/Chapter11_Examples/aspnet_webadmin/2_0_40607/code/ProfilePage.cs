//------------------------------------------------------------------------------
// <copyright file="ProfilePage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System;
    using System.Security;
    public class ProfilePage : WebAdminPage {
        protected override void OnInit(EventArgs e) {
            if (!IsCategoryEnabled("Profile")) {
                Exception ex = new SecurityException("The functionality you are trying to access is not available.");
                SetCurrentException(Context, ex);
                Server.Transfer("~/error.aspx");
            }
            NavigationBar.SetSelectedIndex(2);
            base.OnInit(e);
        }
    }
}


