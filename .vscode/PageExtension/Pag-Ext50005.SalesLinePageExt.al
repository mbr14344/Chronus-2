pageextension 50005 SalesLinePageExt extends "Sales Lines"
{

    layout
    {

        moveafter("Sell-to Customer No."; "No.", "Description", "Type")
        modify("No.")
        {
            Caption = 'item';
        }
        //PR 3/19/25 - start
        //modify()
        //PR 3/19/25 - end
        addafter("Unit of Measure Code")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 0;
            }
            field("Package Count"; rec.GetPackageCount())
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 1;

            }
            field("Cubage per M-Pack"; rec.CubagMPack)
            {
                ToolTip = 'Cubage per M-Pack';
                ApplicationArea = All;
            }
            field(CBF; rec.GetCBF())
            {
                ToolTip = 'CBF = Cubage per M-Pack x package Count (ft)';
                ApplicationArea = All;
                DecimalPlaces = 2 : 5;
            }
            field("GW(lbs)"; rec.GetGW())
            {
                ToolTip = 'GW(lbs) = M-pack weight (lbs) x package count';
                ApplicationArea = All;
                DecimalPlaces = 2 : 5;
            }
            field("EDI Inv Line Discount"; Rec."EDI Inv Line Discount")
            {
                ApplicationArea = all;

            }
            field("SPS EDI Unit Price"; Rec."SPS EDI Unit Price")
            {
                ApplicationArea = All;
            }
            field(ediUnitPriceSPSVis; Rec.GetEdiUnitPriceSPS())
            {
                Caption = 'EDI Unit Price SPS';
                ApplicationArea = All;
            }
            field("Unit Price Exclu. Tax"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }

        }
        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = all;
            }
            //PR 12/19/24
            field("Item Purchasing Code"; Rec."Item Purchasing Code")
            {
                Caption = 'Purchasing Code';
                ToolTip = 'Purchasing Code: This is maintained in the Item Card.';
                ApplicationArea = all;
            }
            //PR 12/19/24
            //PR 3/17/25 - start
            field("Customer Salesperson Code"; Rec."Customer Salesperson Code")
            {
                ApplicationArea = All;
            }
            //PR 3/17/35 - end
            field("Customer Responsibility Center"; Rec."Customer Responsibility Center")
            {
                ToolTip = 'Customer Responsibility Center: This is maintained in the Customer Card.';
                ApplicationArea = all;
            }
        }
        addafter("Type")
        {
            field("Document date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
            field(Master; Rec.Master)
            {
                ApplicationArea = all;
            }
            field("Order Reference"; Rec."Order Reference")
            {
                ApplicationArea = all;
            }
            field("Start Ship Date"; Rec."Start Ship Date")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
                // customer name
                Caption = 'Name';
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            // pr 6/13/24 added modified fields to sales line
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = all;
            }
            field("Modified Date"; Rec."Modified Date")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Created Date"; Rec."Created Date")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Name"; "Quantity")
        addafter(Quantity)
        {
            field("Shipped"; Rec."Qty. Shipped (Base)")
            {
                ApplicationArea = all;
                Caption = 'Shipped';
            }
            field("Invoiced"; Rec."Qty. Invoiced (Base)")
            {
                ApplicationArea = all;
                Caption = 'Invoiced';
            }
            field("Backorder"; Rec."Outstanding Qty. (Base)")
            {
                ApplicationArea = all;
                Caption = 'Backorder';
            }
            field("Amount"; Rec.Amount)
            {
                ApplicationArea = all;
                Caption = 'Amount';
            }
            field("Open Balance"; Rec."Outstanding Amount")
            {
                ApplicationArea = all;
                Caption = 'Open Balance';
            }
            field("Start Ship"; Rec."Shipment Date")
            {
                ApplicationArea = all;
                Caption = 'Start Ship';
            }
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
                Caption = 'Requested Delivery Date';
            }
            field("Cancel Ship"; Rec."Cancel Date")
            {
                ApplicationArea = all;

                Caption = 'Cancel Ship';
            }
            field("Ship From"; Rec."Location Code")
            {
                ApplicationArea = all;
                Caption = 'Ship From';
            }
            field("Ship To City"; Rec."Ship-to City")
            {
                ApplicationArea = all;
                //
                Caption = 'Ship To City';
            }
            field("Ship To State"; Rec."Ship-to State")
            {
                ApplicationArea = all;
                //
                Caption = 'Ship To State';
            }
            field("Flag"; Rec."Flag")
            {
                ApplicationArea = all;
                Caption = 'Flag';
            }
            field("In the Month"; Rec."In the Month")
            {
                ApplicationArea = all;
                Caption = 'In the Month';
            }
            field("APPT"; Rec."APT Date")
            {
                ApplicationArea = all;
                Caption = 'APPT';
            }
            field("Appt Time"; Rec."APT Time")
            {
                ApplicationArea = all;
                Caption = 'Appt Time';
            }
            field("Carrier"; Rec."Shipping Agent Code")
            {
                ApplicationArea = all;
                // agent code
                Caption = 'Carrier';
            }
            field("Split"; Rec."Split")
            {
                ApplicationArea = all;
                // is split
                Caption = 'Split ';
            }
            field(ItemNotes; Rec.ItemNotes)
            {
                ApplicationArea = All;
            }

        }

        modify("Location Code")
        {
            Visible = false;
        }
        modify(Reserve)
        {
            Visible = false;
        }
        modify("Reserved Qty. (Base)")
        {
            Visible = false;
        }
        modify("Line Amount")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Outstanding Quantity")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        addafter(Control1)
        {
            group(SummaryTotals)
            {
                ShowCaption = false;
                field(TotalCBF; totalCBF)
                {
                    ApplicationArea = All;
                    Caption = 'Total CBF';
                    Editable = false;
                }
                field(TotalWeight; totalWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Total Weight';
                    Editable = False;
                }
                field(LinesCount; LinesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Records Selected';
                    Editable = false;
                }

            }

        }
        addafter(Description)
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Visible = false;
        }

    }
    actions
    {
        addafter("Show Document")
        {
            action("Calculate Totals")
            {
                Caption = 'Calculate Totals';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Calculate;

                trigger OnAction()
                var
                    SelectedPurchaseLines: Record "Sales Line";

                begin
                    SelectedPurchaseLines.Reset();
                    totalCBF := 0;
                    totalWeight := 0;
                    LinesCount := 0;
                    CurrPage.SetSelectionFilter(SelectedPurchaseLines);
                    IF SelectedPurchaseLines.FindSet() then
                        repeat
                            LinesCount += 1;
                            SelectedPurchaseLines.CalcFields("M-Pack Qty", "M-Pack Weight");

                            totalCBF += SelectedPurchaseLines.GetCBF();

                            totalWeight += SelectedPurchaseLines.GetPackageCount() * SelectedPurchaseLines."M-Pack Weight";

                        until SelectedPurchaseLines.Next() = 0;
                    if LinesCount > 0 then begin
                        CurrPage.Update();
                    end;
                end;

            }
            action("Clear Totals")
            {
                Caption = 'Clear Totals';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ClearLog;

                trigger OnAction()
                begin
                    LinesCount := 0;
                    totalCBF := 0;
                    totalWeight := 0;
                    CurrPage.Update();
                end;
            }
            //10/17/25 - end
            action("Item Availability by Location")
            {
                Caption = 'Item Availability by Location';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ItemAvailability;

                trigger OnAction()
                var
                    Item: Record Item;
                    ItemAvailabilityByLocation: Page "Item Availability by Location";
                begin
                    if Rec.Type <> Rec.Type::Item then
                        Error('Please select an item line.');

                    if Rec."No." = '' then
                        Error('No item selected.');

                    Item.Get(Rec."No.");
                    Item.SetRange("No.", Rec."No.");
                    ItemAvailabilityByLocation.SetTableView(Item);
                    ItemAvailabilityByLocation.Run();
                end;
            }
            //10/17/25 - end
        }
    }

    var
        // PackageCount: Decimal;
        Item: Record Item;

        totalCBF: Decimal;
        totalWeight: Decimal;
        LinesCount: Integer;

    trigger OnOpenPage()
    begin
        CurrPage.Editable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        // UpdatePackageCnt();
        rec.CalcFields("Item Purchasing Code", "Customer Responsibility Center", "Customer Salesperson Code", "M-Pack Weight", CubagMPack, "Start Ship Date", "In the Month");
        // rec.RunEDIDiscountCalc();

    end;

    /*procedure UpdatePackageCnt()
    begin
        If Rec.Type = Rec.Type::Item then begin
            If Item.Get(Rec."No.") then
                if Item.Type = Item.Type::Inventory then begin
                    Rec.CalcFields("M-Pack Qty");
                    PackageCount := 0;
                    IF Rec."M-Pack Qty" > 0 then
                        PackageCount := Rec."Quantity (Base)" / Rec."M-Pack Qty";

                end;
        end;



    end;*/


}
