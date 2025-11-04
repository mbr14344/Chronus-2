pageextension 50036 InventorySetupPageExt extends "Inventory Setup"
{
    layout
    {
        addafter("Allow Inventory Adjustment")
        {
            field(MondayColumnName; Rec.MondayColumnName)
            {
                ApplicationArea = All;
            }

            field(MondayAPI; Rec.MondayAPI)
            {
                ApplicationArea = All;
            }
        }
        addafter(Location)
        {
            group(Email)
            {
                Caption = 'E-mail';
                group(Inventory)
                {
                    field(InventoryPlanEmailSubject; Rec.InventoryPlanEmailSubject)
                    {
                        ApplicationArea = All;
                    }
                    field(InventoryPlanEmailBody; Rec.InventoryPlanEmailBody)
                    {

                        ApplicationArea = All;
                        MultiLine = true;
                    }

                }
            }
        }
        addafter("Location Mandatory")
        {
            field("FDA Hold Location Code"; Rec."FDA Hold Location Code")
            {
                ApplicationArea = All;
            }
            field("FDA Release Location Code"; Rec."FDA Release Location Code")
            {
                ApplicationArea = All;
            }
        }


    }
}
