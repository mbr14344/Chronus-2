tableextension 50002 UserSetupExtenstion extends "User Setup"
{
    // pr 12/1/23 added table extension for user setup from Nutraza to make job queue work
    fields
    {
        field(50000; "Select Pack. Station on Login"; Boolean)
        {
            Caption = 'Select Pack. Station on Login';
            DataClassification = CustomerContent;
        }
        field(50001; AutoUpdate; Boolean)
        {
            Caption = 'AutoUpdate';
            DataClassification = CustomerContent;
        }
        field(50002; "Auto Update Posting To"; Boolean)
        {
            Caption = 'Auto Update Posting To';
            DataClassification = CustomerContent;
        }
        field(50003; Admin; Boolean)
        {
            Caption = 'Admin';
            DataClassification = CustomerContent;
        }
        field(50004; "InventoryPlanRecipient"; boolean)
        {
            Caption = 'Inventory Plan Recipient';
            DataClassification = CustomerContent;
        }
        field(50005; "APRecipient"; boolean)
        {
            Caption = 'AP Recipient';
            DataClassification = CustomerContent;
        }
        field(50006; InventoryPlanRecipientExcl; boolean)
        {
            Caption = 'Inventory Plan Recipient Exclusive';
            DataClassification = CustomerContent;
        }
        field(50007; SOAdmin; boolean)
        {
            Caption = 'SO Admin';
            DataClassification = CustomerContent;
        }
        field(50008; POAdmin; boolean)
        {
            Caption = 'PO Admin';
            DataClassification = CustomerContent;
        }
        field(50009; SODCBreakdownRecipient; boolean)
        {
            Caption = 'SO DC Breakdown Recipient';
            DataClassification = CustomerContent;
        }
        field(50010; FinanceAdmin; boolean)
        {
            Caption = 'Finance Admin';
            DataClassification = CustomerContent;
        }
        field(50011; "Item Admin"; boolean)
        {
            Caption = 'Item Admin';
            DataClassification = CustomerContent;
        }
    }
}
