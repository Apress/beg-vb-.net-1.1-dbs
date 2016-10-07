//------------------------------------------------------------------------------
// <copyright file="WebAdminPage.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System.Web.UI;
    // Base class for use elsewhere in the code directory
    public class NavigationBar : UserControl {
        public virtual void SetSelectedIndex(int index) {
            // Overridden in user control
        }
    }
}

