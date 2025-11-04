page 50022 "Master BOL List"
{
    // pr 1/24/24 created Master BOL list page
    ApplicationArea = All;
    Caption = 'Master Bill of Ladings';
    PageType = List;
    SourceTable = "Master BOL";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Master BOL No."; Rec."Master BOL No.")
                {
                    ApplicationArea = all;

                }
                field("Single BOL No."; Rec."Single BOL No.")
                {
                    ApplicationArea = all;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Ship to Code"; Rec."Ship to Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Ship to City"; Rec."Ship To City")
                {
                    ApplicationArea = all;
                }
                field("External Doc No."; Rec."External Doc No.")
                {
                    ApplicationArea = all;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = all;
                }
                field("Main Ship To Name"; Rec."Main Ship To Name")
                {
                    ApplicationArea = all;
                }
                field("Main Ship To Address"; Rec."Main Ship To Address")
                {
                    ApplicationArea = all;
                }
                field("Main Ship To City"; Rec."Main Ship To City")
                {
                    ApplicationArea = all;
                }
                field("Main Ship To State/County"; Rec."Main Ship To State/County")
                {
                    ApplicationArea = all;
                }
                field("Main Ship To Postal Code"; Rec."Main Ship To Postal Code")
                {
                    ApplicationArea = all;
                }
                field("Bill To Adress"; Rec."Bill To Adress")
                {
                    ApplicationArea = all;
                }
                field("Bill To City"; Rec."Bill To City")
                {
                    ApplicationArea = all;
                }
                field("Bill To Contact"; Rec."Bill To Contact")
                {
                    ApplicationArea = all;
                }
                field("Bill To Name"; Rec."Bill To Name")
                {
                    ApplicationArea = all;
                }
                field("Bill To Postal Code"; Rec."Bill To Postal Code")
                {
                    ApplicationArea = all;
                }
                field("Bill To State/County"; Rec."Bill To State/County")
                {
                    ApplicationArea = all;
                }
                field("Freight Charge Term"; Rec."Freight Charge Term")
                {

                }
                field("SCAC Code"; Rec."SCAC Code")
                {

                }
                field("Carrier Name"; Rec."Carrier Name")
                {

                }

            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Master Bill of Lading")
            {
                ApplicationArea = all;
                Image = Report;
                trigger OnAction()

                var
                    PSS: Record "Master BOL";

                begin
                    PSS.SetRange("Master BOL No.", rec."Master BOL No.");
                    IF PSS.FindFirst() then begin
                        Clear(myReport);
                        myReport.SetTableView(PSS);
                        myReport.Run;



                    end;
                end;


            }
        }
    }
    var
        myReport: Report "MasterBOLAndSingleBOL";


    trigger OnOpenPage()
    begin
        rec.SetRange(Posted, false);
    end;
}
