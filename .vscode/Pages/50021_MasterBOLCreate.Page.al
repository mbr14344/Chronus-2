page 50021 "Master BOL Create Card"
{
    //mbr 1/31/24 - create Master BOL Create Card to ask user to enter Ship To Address
    Caption = 'Master BOL Create Card';
    PageType = Card;
    SourceTable = "Master BOL";

    layout
    {

        area(content)
        {
            group(General)
            {
                Caption = 'Customer Ship From Information';
                field("Master BOL No."; Rec."Master BOL No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Main Ship To Name"; Rec."Main Ship To Name")
                {
                    ToolTip = 'Specifies the Customer Ship To Name';
                    ApplicationArea = All;
                }
                field("Main Ship To Address"; Rec."Main Ship To Address")
                {
                    ToolTip = 'Specifies the Customer Main Ship To Address';
                    ApplicationArea = All;
                }
                field("Main Ship To City"; Rec."Main Ship To City")
                {
                    ToolTip = 'Specifies the Customer Main Ship To City';
                    ApplicationArea = All;
                }
                field("Main Ship To State/County"; Rec."Main Ship To State/County")
                {
                    ToolTip = 'Specifies the Customer Main Ship To State/County';
                    ApplicationArea = All;
                }
                field("Main Ship To Postal Code"; Rec."Main Ship To Postal Code")
                {
                    ToolTip = 'Specifies the Customer Main Ship To Postal Code';
                    ApplicationArea = All;
                }
                field("Main Ship To Contact"; Rec."Main Ship To Contact")
                {
                    ToolTip = 'Specifies the Customer Main Ship To Contact';
                    ApplicationArea = All;
                }
                field("Special Instsructions"; Rec."Special Instructions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies special instructions for Master BOL';
                }
                field("Bill To Name"; Rec."Bill To Name")
                {
                    ApplicationArea = All;
                }
                field("Bill To Adress"; Rec."Bill To Adress")
                {
                    ApplicationArea = All;
                }
                field("Bill To City"; Rec."Bill To City")
                {
                    ApplicationArea = All;
                }
                field("Bill To State/County"; Rec."Bill To State/County")
                {
                    ApplicationArea = All;
                }
                field("Bill To Postal Code"; Rec."Bill To Postal Code")
                {
                    ApplicationArea = All;
                }
                field("Bill To Contact"; Rec."Bill To Contact")
                {
                    ApplicationArea = All;
                }

            }

        }

    }
    actions
    {
        area(Processing)
        {

            action("Continue")
            {
                ApplicationArea = All;
                Caption = 'Continue';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Task;

                trigger OnAction()
                begin
                    if strlen(rec."Main Ship To Name") = 0 then
                        Error('Main Ship To Name is Mandatory.');
                    if strlen(rec."Main Ship To Address") = 0 then
                        Error('Main Ship To Address is Mandatory.');
                    if strlen(rec."Main Ship To City") = 0 then
                        Error('Main Ship To Name is Mandatory.');
                    if strlen(rec."Main Ship To State/County") = 0 then
                        Error('Main Ship To State/County is Mandatory.');
                    if strlen(rec."Main Ship To Postal Code") = 0 then
                        Error('Main Ship To Postal Code is Mandatory.');
                    if strlen(rec."Special Instructions") = 0 then
                        Error('Special Instructions - Mandatory. Please review.');

                    //otherwise, update all rows with ship from address provided
                    masterBOL.RESET;
                    masterBOL.SetRange("Master BOL No.", rec."Master BOL No.");
                    masterBOL.SetFilter("Main Ship To Address", '<>%1', rec."Main Ship To Address");
                    if masterBOL.FINDSET then
                        repeat
                            masterBOL."Main Ship To Name" := rec."Main Ship To Name";
                            masterbol."Main Ship To Address" := rec."Main Ship To Address";
                            masterbol."Main Ship To City" := rec."Main Ship To City";
                            masterbol."Main Ship To Postal Code" := rec."Main Ship To Postal Code";
                            masterbol."Main Ship To State/County" := rec."Main Ship To State/County";
                            masterbol."Main Ship To Contact" := rec."Main Ship To Contact";
                            masterBOL.modify;

                        UNTIL masterBOL.next = 0;
                    Message('Successfully assigned selected sales order(s) to Master BOL %1.', Rec."Master BOL No.");
                    CurrPage.close;
                end;
            }
            action("Cancel")
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Task;

                trigger OnAction()
                begin

                    masterBOL.RESET;
                    masterBOL.SetRange("Master BOL No.", rec."Master BOL No.");
                    if masterBOL.FINDSET then
                        masterBOL.DeleteAll();
                    Message('Master BOL %1 assignment CANCELLED.', Rec."Master BOL No.");
                    CurrPage.close;
                end;
            }

        }



    }

    trigger OnOpenPage()
    begin


    end;

    trigger OnClosePage()
    begin
        IF strlen(rec."Main Ship To Address") = 0 then begin
            masterBOL.RESET;
            masterBOL.SetRange("Master BOL No.", rec."Master BOL No.");
            if masterBOL.FINDSET then
                masterBOL.DeleteAll();
            Message('Main Ship To Address is Mandatory! Master BOL %1 assignment CANCELLED. Please try again.', Rec."Master BOL No.");
        end;
    end;

    var

        masterBOL: record "Master BOL";
    //mbr 1/31/24 - create Master BOL Create Card to ask user to enter Ship To Address
}
