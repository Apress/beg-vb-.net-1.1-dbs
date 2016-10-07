//------------------------------------------------------------------------------
// <copyright file="ProfileUtil.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>                                                                
//------------------------------------------------------------------------------

namespace System.Web.Administration {
    using System.Collections;
    using System.Collections.Specialized;
    using System.Configuration;
    using System.Diagnostics;
    using System.Globalization;
    using System.Web.Compilation;
    using System.Web.Configuration;

    public class ProfileUtil {
        private static readonly Hashtable _resolvedFullTypeNames;
        private static readonly StringDictionary _resolvedFriendlyTypeNames;

        private ProfileUtil(){}

        static ProfileUtil() {
            _resolvedFullTypeNames = new Hashtable(24, CaseInsensitiveHashCodeProvider.Default, CaseInsensitiveComparer.Default);
            _resolvedFullTypeNames["Bool"] = "System.Boolean";
            _resolvedFullTypeNames["Boolean"] = "System.Boolean";
            _resolvedFullTypeNames["Char"] = "System.Char";
            _resolvedFullTypeNames["Date"] = "System.DateTime";
            _resolvedFullTypeNames["DateTime"] = "System.DateTime";
            _resolvedFullTypeNames["Decimal"] = "System.Decimal";
            _resolvedFullTypeNames["Double"] = "System.Double";
            _resolvedFullTypeNames["Float64"] = "System.Double";
            _resolvedFullTypeNames["Int"] = "System.Int32";
            _resolvedFullTypeNames["Int32"] = "System.Int32";
            _resolvedFullTypeNames["Integer"] = "System.Int32";
            _resolvedFullTypeNames["Int64"] = "System.Int64";
            _resolvedFullTypeNames["Long"] = "System.Int64";
            _resolvedFullTypeNames["Single"] = "System.Single";
            _resolvedFullTypeNames["String"] = "System.String";
            _resolvedFullTypeNames["System.Boolean"] = "System.Boolean";
            _resolvedFullTypeNames["System.Char"] = "System.Char";
            _resolvedFullTypeNames["System.DateTime"] = "System.DateTime";
            _resolvedFullTypeNames["System.Decimal"] = "System.Decimal";
            _resolvedFullTypeNames["System.Double"] = "System.Double";
            _resolvedFullTypeNames["System.Int32"] = "System.Int32";
            _resolvedFullTypeNames["System.Int64"] = "System.Int64";
            _resolvedFullTypeNames["System.Single"] = "System.Single";
            _resolvedFullTypeNames["System.String"] = "System.String";

            _resolvedFriendlyTypeNames = new StringDictionary();
            _resolvedFriendlyTypeNames["System.Boolean"] = "Boolean";
            _resolvedFriendlyTypeNames["System.Char"] = "Char";
            _resolvedFriendlyTypeNames["System.DateTime"] = "DateTime";
            _resolvedFriendlyTypeNames["System.Decimal"] = "Decimal";
            _resolvedFriendlyTypeNames["System.Double"] = "Double";
            _resolvedFriendlyTypeNames["System.Int32"] = "Int32";
            _resolvedFriendlyTypeNames["System.Int64"] = "Int64";
            _resolvedFriendlyTypeNames["System.Single"] = "Single";
            _resolvedFriendlyTypeNames["System.String"] = "String";
        }

        public static object ConvertStringValueForType(string typeName, string value) {
            Type type = BuildManager.GetType(typeName, true);
            SettingsProperty property = new SettingsProperty("temp", type, null, false, value, SettingsSerializeAs.String, null);
            SettingsPropertyValue propertyValue = new SettingsPropertyValue(property);
            return propertyValue.PropertyValue;
        }

        public static bool CheckNameForValidity(string name) {
            if (name == null) {
                return false;
            }

            int len = name.Length;
            if (len < 1) {
                return false;
            }

            if (!char.IsLetter(name[0])) {
                return false;
            }

            for (int iter = 1; iter < len; iter++) {
                if (!char.IsLetterOrDigit(name[iter])) {
                    return false;
                }
            }
            return true;
        }

        public static void CreateGroup(RootProfilePropertySettingsCollection profile, string group) {
            ProfileGroupSettings groupSettings = new ProfileGroupSettings();
            groupSettings.Name = group;
            profile.GroupSettings.Add(groupSettings);
        }

        public static void CreateProperty(RootProfilePropertySettingsCollection profile,
                                          string name,
                                          string group,
                                          string type,
                                          string defaultValue,
                                          bool allowAnonymous) {
            ProfilePropertySettings property = new ProfilePropertySettings();

            SetPropertyData(property, name, type, defaultValue, allowAnonymous);

            if (group != null && group.Length > 0) {
                ProfileGroupSettings groupSettings = profile.GroupSettings.Get(group);
                groupSettings.PropertySettings.Add(property);
            }
            else {
                profile.Add(property);
            }
        }

        public static void DeleteGroup(RootProfilePropertySettingsCollection profile, string group) {
            profile.GroupSettings.Remove(group);
        }

        public static void DeleteProperty(RootProfilePropertySettingsCollection profile, string name, string group) {
            if (group != null && group.Length > 0) {
                ProfileGroupSettings groupSettings = profile.GroupSettings.Get(group);
                groupSettings.PropertySettings.Remove(name);
            }
            else {
                profile.Remove(name);
            }
        }

        public static ProfileGroupSettings GetGroup(RootProfilePropertySettingsCollection profile,
                                                                   string group) {
            // Case-insensitive
            foreach (ProfileGroupSettings groupSettings in profile.GroupSettings) {
                if (string.Compare(groupSettings.Name, group, true, CultureInfo.InvariantCulture) == 0) {
                    return groupSettings;
                }
            }
            return null;
        }

        public static ProfilePropertySettings GetProperty(RootProfilePropertySettingsCollection profile,
                                                                         string name,
                                                                         string group) {
            if (group != null && group.Length > 0) {
                ProfileGroupSettings groupSettings = GetGroup(profile, group);
                if (groupSettings == null) {
                    return null;
                }
                return GetPropertyInternal(groupSettings.PropertySettings, name);
            }
            else {
                return GetPropertyInternal(profile, name);
            }
        }

        private static ProfilePropertySettings GetPropertyInternal(
                                ProfilePropertySettingsCollection properties,
                                string name) {
            // Case-insensitive
            foreach (ProfilePropertySettings propertySettings in properties) {
                if (string.Compare(propertySettings.Name, name, true, CultureInfo.InvariantCulture) == 0) {
                    return propertySettings;
                }
            }
            return null;
        }

        public static StringCollection GetPropertyNamesFromGroup(ProfileGroupSettingsCollection groups, string group) {
            Debug.Assert(groups != null);
            Debug.Assert(group != null && group.Length > 0);

            // TODO: We should use a collection that does culture independent string comparison
            StringCollection propertyNames = new StringCollection();

            ProfileGroupSettings groupSettings = groups[group];
            if (groupSettings != null) {
                foreach (ProfilePropertySettings property in groupSettings.PropertySettings) {
                    propertyNames.Add(property.Name);
                }
            }

            return propertyNames;
        }

        public static StringCollection GetPropertyNamesWithNoGroup(ProfilePropertySettingsCollection parentProperties,
                                                                   ProfilePropertySettingsCollection properties) {
            Debug.Assert(parentProperties != null);
            Debug.Assert(properties != null);

            // TODO: We should use a collection that does culture independent string comparison
            StringCollection propertyNames = new StringCollection();

            foreach (ProfilePropertySettings property in properties) {
                if (parentProperties[property.Name] == null) {
                    propertyNames.Add(property.Name);
                }
            }

            return propertyNames;
        }

        public static bool HasGroup(RootProfilePropertySettingsCollection profile, string group) {
            return (GetGroup(profile, group) != null);
        }

        public static bool HasProperty(RootProfilePropertySettingsCollection profile, string name, string group) {
            return (GetProperty(profile, name, group) != null);
        }

        public static string ResolveFullTypeName(string typeName) {
            return (string) _resolvedFullTypeNames[typeName];
        }

        public static string ResolveFriendlyTypeName(string fullTypeName) {
            return _resolvedFriendlyTypeNames[fullTypeName];
        }

        public static void SetPropertyData(ProfilePropertySettings property,
                                           string name,
                                           string type,
                                           string defaultValue,
                                           bool allowAnonymous) {
            property.Name = name;
            property.Type = type;

            if (property.DefaultValue != defaultValue) {
                property.DefaultValue = defaultValue;
            }

            if (property.AllowAnonymous != allowAnonymous) {
                property.AllowAnonymous = allowAnonymous;
            }
        }

        public static void UpdateProperty(RootProfilePropertySettingsCollection profile,
                                          string originalName,
                                          string newName,
                                          string group,
                                          string type,
                                          string defaultValue,
                                          bool allowAnonymous) {
            // Assumption: the group name hasn't been changed
            ProfilePropertySettings property = GetProperty(profile, originalName, group);
            SetPropertyData(property, newName, type, defaultValue, allowAnonymous);
        }
    }
}
