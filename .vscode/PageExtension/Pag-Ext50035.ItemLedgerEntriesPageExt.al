pageextension 50035 ItemLedgerEntriesPageExt extends "Item Ledger Entries"
{
    layout
    {
        modify(Description)
        {
            Visible = false;
        }
        modify("Cost Amount (Actual)")
        {
            Visible = false;
        }
        modify("Cost Amount (Expected)")
        {
            Visible = false;
        }
        modify("Cost Amount (Non-Invtbl.)")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field("Sales Shipment Source No."; Rec."Sales Shipment Source No.")
            {
                ApplicationArea = All;
            }
            field("Sales Inv. No."; Rec."Sales Inv. No.")
            {
                ApplicationArea = All;
            }
            field("Purchase Receipt Source No."; Rec."Purchase Receipt Source No.")
            {
                ApplicationArea = ALL;
            }
            field("Item Description Cust"; Rec."Item Description Cust")
            {
                ApplicationArea = All;
            }
            field("Real Time Item Category Code"; Rec."Real Time Item Category Code")
            {
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("License Exist"; Rec."License Exist")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field("Sub-Brand"; Rec."Sub-Brand")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }
            field("Purch. Inv. No."; Rec."Purch. Inv. No.")
            {
                ApplicationArea = All;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
            }
            field("Posted By"; Rec."Posted By")
            {
                ApplicationArea = All;
            }
            //8/12/25 - start
            field("Item Type"; Rec."Item Type")
            {
                ApplicationArea = All;
            }
            //8/12/25 - end

        }
        addbefore("Item No.")
        {
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    postedContainerLine: Record "Posted Container Line";
                    postedContainerDel: page PostedContainerDeliveryPlan;
                    contianerLine: Record ContainerLine;
                    containerDel: page "Container Delivery Planning";
                begin
                    if (StrLen(rec."Container No.") > 0) then begin
                        contianerLine.Reset();
                        contianerLine.SetRange("Container No.", rec."Container No.");
                        contianerLine.SetRange("Item No.", rec."Item No.");
                        contianerLine.SetRange("Transfer Order No.", rec."Order No.");
                        if (contianerLine.FindSet()) then begin
                            Clear(containerDel);
                            containerDel.SetTableView(contianerLine);
                            containerDel.Run();
                        end
                        else begin
                            postedContainerLine.Reset();
                            postedContainerLine.SetRange("Container No.", rec."Container No.");
                            postedContainerLine.SetRange("Item No.", rec."Item No.");
                            postedContainerLine.SetRange("Transfer Order No.", rec."Order No.");
                            if (postedContainerLine.FindSet()) then begin
                                Clear(postedContainerDel);
                                postedContainerDel.SetTableView(postedContainerLine);
                                postedContainerDel.Run();
                            end;
                        end;
                    end;
                end;
            }
        }


        addafter("Sales Amount (Actual)")
        {
            field(SalesUnitPrice; SalesUnitPrice)
            {
                Caption = 'Sales Unit Price';
                ApplicationArea = All;
                ToolTip = 'Specifies the Sales Unit Price (Sales Amount (Actual) / Invoiced Quantity).';
            }
        }
        addafter("Cost Amount (Actual)")
        {
            field(UnitCost; UnitCost)
            {
                Caption = 'Unit Cost';
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the Unit Cost (Cost Amount (Actual) / Invoiced Quantity).';
            }
        }
        addafter("Document No.")
        {

        }
        //PR 2/11/25 make this “Order No.” column on Item Ledger Entry linkable to its related document - start
        modify("Order No.")
        {
            Visible = true;
            trigger OnDrillDown()
            var
                TransferRecieptPage: Page "Posted Transfer Receipt";
                transferRecieptHdr: Record "Transfer Receipt Header";
                TransferShipmentPage: Page "Posted Transfer Shipment";
                transferShipmentHdr: Record "Transfer Shipment Header";
                PostedAssemblyPage: Page "Posted Assembly Order";
                postedAssemblyHdr: Record "Posted Assembly Header";


            begin
                if (StrLen(rec."Order No.") > 0) then begin
                    case rec."Document Type" of
                        rec."Document Type"::"Transfer Receipt":
                            begin
                                transferRecieptHdr.Reset();
                                transferRecieptHdr.SetRange("No.", rec."Document No.");
                                transferRecieptHdr.SetRange("Transfer Order No.", rec."Order No.");
                                if (transferRecieptHdr.FindFirst()) then begin
                                    Clear(TransferRecieptPage);
                                    TransferRecieptPage.SetTableView(transferRecieptHdr);
                                    TransferRecieptPage.Run();
                                end;

                            end;
                        rec."Document Type"::"Transfer Shipment":
                            begin
                                transferShipmentHdr.Reset();
                                transferShipmentHdr.SetRange("No.", rec."Document No.");
                                transferShipmentHdr.SetRange("Transfer Order No.", rec."Order No.");
                                if (transferShipmentHdr.FindFirst()) then begin
                                    Clear(TransferShipmentPage);
                                    TransferShipmentPage.SetTableView(transferShipmentHdr);
                                    TransferShipmentPage.Run();
                                end
                            end;
                        rec."Document Type"::"Posted Assembly":
                            begin
                                postedAssemblyHdr.Reset();
                                postedAssemblyHdr.SetRange("No.", rec."Document No.");
                                postedAssemblyHdr.SetRange("Order No.", rec."Order No.");
                                if (postedAssemblyHdr.FindFirst()) then begin
                                    Clear(PostedAssemblyPage);
                                    PostedAssemblyPage.SetTableView(postedAssemblyHdr);
                                    PostedAssemblyPage.Run();
                                end;
                            end;

                    end;

                end;
            end;
            //PR 2/11/25 make this “Order No.” column on Item Ledger Entry linkable to its related document - end
        }




        addfirst(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Item Ledger Entry"), "Line No." = field("Entry No.");
            }
        }




    }
    trigger OnAfterGetRecord()
    var
        SalesInvLine: Record "Sales Invoice Line";
        bfound: Boolean;
    begin
        rec.CalcFields("Purch. Inv. No.", "Item Type");
        If Rec."Invoiced Quantity" <> 0 then begin
            Rec.CalcFields("Sales Amount (Actual)", "Cost Amount (Actual)");
            SalesUnitPrice := Rec."Sales Amount (Actual)" / abs(Rec."Invoiced Quantity");
            UnitCost := ABS(Rec."Cost Amount (Actual)" / abs(Rec."Invoiced Quantity"));
        end

        else begin
            SalesUnitPrice := 0;
            UnitCost := 0;
        end;

        //pr 4/8/25 - cacl "Sales Inv. No." - start
        bfound := false;
        Rec.CalcFields("Sales Shipment Source No.");
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Order No.", Rec."Sales Shipment Source No.");
        SalesInvLine.SetRange("No.", rec."Item No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetRange(Quantity, abs(rec.Quantity));
        SalesInvLine.SetRange("Line No.", rec."Document Line No.");
        SalesInvLine.SetRange("Sell-to Customer No.", rec."Source No.");
        if (SalesInvLine.FindSet()) then
            repeat
                rec."Sales Inv. No." := SalesInvLine."Document No.";
                bfound := true;
            until (SalesInvLine.Next() = 0) or (bfound = true);
        //pr 4/8/25 - cacl "Sales Inv. No." - end

    end;




    var
        myInt: Integer;
        SalesUnitPrice: Decimal;
        UnitCost: Decimal;

}
