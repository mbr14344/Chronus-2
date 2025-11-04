page 50025 SelectLocationToSplit
{
    ApplicationArea = All;
    Caption = 'Select Locations to Split';
    PageType = Card;
    SourceTable = "Sales Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Enabled = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the customer''s name.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the External Document No.';
                }
                field("Request Ship Date"; Rec."Request Ship Date")
                {
                    ToolTip = 'Specifies the value of the Request Ship Date field.';
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the city of the shipping address.';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ToolTip = 'Specifies the state that is used to calculate and post sales tax.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }

            }
            group(SelectLocation)
            {
                Caption = 'Select Locations';
                field(Loc1; Loc1)
                {
                    Caption = 'Location 1';
                    TableRelation = Location where("Use As In-Transit" = const(false));
                    trigger OnValidate()
                    begin
                        IF strlen(Loc1) = 0 then exit;
                        if not location.get(Loc1) then
                            Error(TextErr, Loc1);
                    end;


                }
                field(Loc2; Loc2)
                {
                    Caption = 'Location 2';
                    TableRelation = Location where("Use As In-Transit" = const(false));

                    trigger OnValidate()
                    begin
                        IF strlen(Loc2) = 0 then exit;
                        if not location.get(Loc2) then
                            Error(TextErr, Loc2);
                    end;
                }
                field(Loc3; Loc3)
                {
                    Caption = 'Location 3';
                    TableRelation = Location where("Use As In-Transit" = const(false));
                    trigger OnValidate()
                    begin
                        IF strlen(Loc3) = 0 then exit;
                        if not location.get(Loc3) then
                            Error(TextErr, Loc3);
                    end;
                }
                field(Loc4; Loc4)
                {
                    Caption = 'Location 4';
                    TableRelation = Location where("Use As In-Transit" = const(false));
                    trigger OnValidate()
                    begin
                        IF strlen(Loc4) = 0 then exit;
                        if not location.get(Loc4) then
                            Error(TextErr, Loc4);
                    end;
                }
                field(Loc5; Loc5)
                {
                    Caption = 'Location 5';
                    TableRelation = Location where("Use As In-Transit" = const(false));
                    trigger OnValidate()
                    begin
                        IF strlen(Loc5) = 0 then exit;
                        if not location.get(Loc5) then
                            Error(TextErr, Loc5);
                    end;
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
                ApplicationArea = all;
                Image = Continue;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    PgSplitSO: Page SplitSalesOrder;
                begin
                    Clear(PgSplitSO);
                    PgSplitSO.InitPage(Rec."No.", Loc1, Loc2, Loc3, Loc4, Loc5);
                    PgSplitSO.RunModal;
                end;

            }
        }
    }
    var
        Loc1: code[10];
        Loc2: Code[10];
        Loc3: Code[10];
        Loc4: Code[10];
        Loc5: Code[10];

        location: Record Location;
        TextErr: Label 'Location Code %1 is invalid.';

    trigger OnOpenPage()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetFilter("Location Code", '<>%1', '');
        IF SalesLine.FindFirst() then
            Loc1 := SalesLine."Location Code";
    end;
}
