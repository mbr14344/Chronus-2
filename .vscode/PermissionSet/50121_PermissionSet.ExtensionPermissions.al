permissionset 50121 ExtensionPermissions
{
    Assignable = true;
    Caption = 'ExtensionPermissions', MaxLength = 30;
    Permissions = tabledata "NAV App Installed App" = RIMD, page "O365 Activities" = X;
    IncludedPermissionSets = "D365 BASIC";
}
