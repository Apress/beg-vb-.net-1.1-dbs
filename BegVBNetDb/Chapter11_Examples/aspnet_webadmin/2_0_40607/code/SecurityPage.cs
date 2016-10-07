//------------------------------------------------------------------------------
// <copyright file="SecurityPage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System;
    using System.Collections;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Security;
    
    public class SecurityPage : WebAdminPage {
        private const string CURRENT_PATH = "WebAdminCurrentPath";
        
        protected string CurrentPath {
            get {
                return (string)Session[CURRENT_PATH];
            }
            set {
                Session[CURRENT_PATH] = value;
            }
        }

        protected override void OnInit(EventArgs e) {
            if (!IsCategoryEnabled("Security")) {
                Exception ex = new SecurityException("The functionality you are trying to access is not available.");
                SetCurrentException(Context, ex);
                Server.Transfer("~/error.aspx");
            }
            NavigationBar.SetSelectedIndex(1);
            base.OnInit(e);
        }
    
        protected void SearchForUsers(object s, EventArgs e, Repeater repeater, GridView dataGrid, DropDownList dropDown, TextBox textBox) {
            ICollection coll = null;
            if (dropDown.SelectedIndex == 0 /* userID */) {
                string text = textBox.Text;
                text = text.Replace("*", "%");
                text = text.Replace("?", "_");
                int total;
                if (text.Trim().Length != 0) {
                    coll = MembershipHelperInstance.FindUsersByName(text, 0, Int32.MaxValue, out total);
                }
            }
            else {
                string text = textBox.Text;
                text = text.Replace("*", "%");
                text = text.Replace("?", "_");
                int total;
                if (text.Trim().Length != 0) {
                    coll = MembershipHelperInstance.FindUsersByEmail(text, 0, Int32.MaxValue, out total);
                }
            }

            dataGrid.PageIndex = 0;
            dataGrid.DataSource = coll;
            PopulateRepeaterDataSource(repeater);
            repeater.DataBind();
            dataGrid.DataBind();
        }

    }
}


