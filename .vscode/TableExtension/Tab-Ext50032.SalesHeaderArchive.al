tableextension 50032 SalesHeaderArchive extends "Sales Header Archive"
{
    fields
    {
        field(50000; "Cancel Date"; Date)
        {
            Caption = 'Cancel Date';

        }
        field(50001; "Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';

        }
        field(50002; "Split"; Boolean)
        {
            Caption = 'Split';
        }
        field(50003; "FOB"; Text[20])
        {
            Caption = 'FOB';

        }
        field(50004; "Flag"; Option)
        {
            Caption = 'Flag';
            OptionMembers = " ","0","Allocated","China Drop Ship","Extension Pending","Issue with PO","Master PO","PO SPLIT","Portal Routed","Pre-Scheduled","Ready for Billing","Routed and Waiting for Product","Scheduled","Scheduled and Waiting for Product","Transfer Pending","Waiting Product","Waiting Sales","Warehouse Processing","Order Canceled","Tendered to BC","Reschedule Pending","Need to schedule","Future Ship Date";
            OptionCaption = ' ,0,Allocated,China Drop Ship,Extension Pending,Issue with PO,Master PO,PO SPLIT,Portal Routed,Pre-Scheduled,Ready for Billing,Routed and Waiting for Product,Scheduled,Scheduled and Waiting for Product,Transfer Pending,Waiting Product,Waiting Sales,Warehouse Processing,Order Canceled,Tendered to BC,Reschedule Pending,Need to schedule,Future Ship Date';

        }
        field(50005; "Start Ship Date"; Date)
        {
            Caption = 'Start Ship Date';

        }
        //pr 1/24/24 added fields for bol 
        field(50006; "Single BOL No."; Code[20])
        {
            Caption = 'Single BOL No.';
        }

        field(50014; "FreightChargeTerm"; Option)
        {
            OptionMembers = " ","Prepaid","Collect","3rd Party";
            Caption = 'Freight Charge Terms';

        }
        field(50015; "BOL Comments"; Text[250])
        {
        }
        field(50016; Type; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(50017; Dept; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Dept';
        }

        field(50019; "APT Date"; Date)
        {
            Caption = 'APT Date';

        }
        field(50020; "APT Time"; Text[20])
        {
            Caption = 'APT Time';

        }
        field(50021; "Total Package Count"; Decimal)
        {
            Caption = 'Total Package Count';
        }
        field(50022; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight';
        }
        field(50023; "Total Pallet Count"; Decimal)
        {
            Caption = 'Total Pallet Count';
        }
        field(50024; CreatedUserID; Code[20])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50025; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50031; Internal; Boolean)
        {

        }
        //pr 6/19/25 - start
        field(50045; "Freight Charge Name"; Text[100])
        {
        }
        field(50046; "Freight Charge Address"; Text[100])
        {
        }
        field(50047; "Freight Charge City"; Text[30])
        {
        }
        field(50048; "Freight Charge State"; Text[100])
        {
        }
        field(50049; "Freight Charge Zip"; Text[20])
        {
        }
        field(50050; "Freight Charge Contact"; Text[100])
        {
        }
        //pr 6/19/25 - end
    }
}
