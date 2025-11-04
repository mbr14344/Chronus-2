tableextension 50030 InventorySetupExt extends "Inventory Setup"
{
    fields
    {
        field(50000; InventoryPlanEmailBody; Text[500])
        {
            Caption = 'Inventory Plan Email Body';
        }
        field(50001; InventoryPlanEmailSubject; Text[200])
        {
            Caption = 'Inventory Plan Email Subject';
        }
        field(50002; "FDA Hold Location Code"; code[10])
        {
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50003; "FDA Release Location Code"; code[10])
        {
            TableRelation = Location where("Use As In-Transit" = const(false));
        }

        field(50005; MondayColumnName; Text[100])
        {
            Caption = 'Monday.com Column Name';
        }
        field(50006; MondayAPI; Text[500])
        {
            Caption = 'Monday.com API Token';
        }

    }
}
