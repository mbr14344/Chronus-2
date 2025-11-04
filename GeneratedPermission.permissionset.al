permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "Port of Loading" = RIMD,
        table "Port of Loading" = X,
        report "Custom Check (Check/Stub/Stub)" = X,
        report "Custom Purchase Order" = X,
        codeunit MyJobQueue = X,
        codeunit SalesOrderOnPostCheck = X,
        page "Port of Loading List" = X,
        tabledata TmpSalesLine = RIMD,
                tabledata TmpTable = RIMD,
        tabledata CalendarEvent = RIMD,
        table CalendarEvent = X,
        tabledata CalendarEventTypes = RIMD,
        table CalendarEventTypes = X,
        page "Calendar Page" = X,
        page "Calendar Event List" = X;
}