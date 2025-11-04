report 50131 ContentLabelReport
{
    Caption = 'Content Label Report';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/ContentLabel.rdl';

    dataset
    {
        dataitem(CustomSalesLine; CartonInformation)
        {
            column(Document_No_; "Document No.")
            {
            }
            column(DocumentLine_No_; "DocumentLine No.")
            {
            }
            column(Line_No_; "Line No.")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(ShipToPostCode; ShipToPostCode)
            {
            }
            column(ShipTo_Add1; ShipTo_Add[1])
            {
            }
            column(ShipTo_Add2; ShipTo_Add[2])
            {
            }
            column(ShipTo_Add3; ShipTo_Add[3])
            {
            }
            column(ShipTo_Add4; ShipTo_Add[4])
            {
            }
            column(ShipTo_Add5; ShipTo_Add[5])
            {
            }
            column(ShipFrm_LocAdd5; ShipFrm_LocAdd[5])
            {
            }
            column(ShipFrm_LocAdd1; ShipFrm_LocAdd[1])
            {
            }
            column(ShipFrm_LocAdd2; ShipFrm_LocAdd[2])
            {
            }
            column(ShipFrm_LocAdd3; ShipFrm_LocAdd[3])
            {
            }
            column(ShipFrm_LocAdd4; ShipFrm_LocAdd[4])
            {
            }
            column(Type; Type)
            {
            }
            column(Dept; Dept)
            {
            }
            column(CasePackQty; CasePackQty)
            {
            }

            column(LineCount; LineFound)
            {
            }
            column(TOtalcount; TOtalcount)
            {
            }
            column(SKU; SKU)
            {

            }
            column(Style; Style)
            {

            }
            column(PrePack; PrePack)
            {

            }
            column(CustName; CustName)
            {

            }
            column(PONo; PONo)
            {

            }
            column(PrePackNo; PrePackNo)
            {

            }

            trigger OnPreDataItem()
            var
                CustomSalesLineRef: Record CartonInformation;
                total: Decimal;
                lineFound: Decimal;
                docNo: code[20];
            begin
                tmpCIRef.DeleteAll();
                tmpCIRef.Reset();
                tmpCI.DeleteAll();
                tmpCI.Reset();
                //copy all the package information from Carton information to tmpCI
                docNo := CustomSalesLine.GetFilter("Document No.");
                CustomSalesLine.SetRange(Posted, false);
                CustomSalesLine.SetFilter("Item No.", '<>%1', '');
                CustomSalesLineRef.Reset();
                CustomSalesLineRef.SetRange("Document No.", docNo);
                CustomSalesLineRef.SetRange(Posted, false);
                CustomSalesLineRef.SetFilter("Item No.", '<>%1', '');
                if CustomSalesLineRef.FindSet() then
                    repeat
                        tmpCI.Init();
                        tmpCI."Document No." := CustomSalesLineRef."Document No.";
                        tmpCI."Item No." := CustomSalesLineRef."Item No.";
                        tmpCI."Line No." := CustomSalesLineRef."Line No.";
                        tmpCI."LineCount" := CustomSalesLineRef.LineCount;
                        tmpCI."DocumentLine No." := CustomSalesLineRef."DocumentLine No.";
                        tmpCI."Document Type" := CustomSalesLineRef."Document Type";
                        tmpCI."Serial No." := CustomSalesLineRef."Serial No.";
                        tmpCI.Insert();

                        tmpCIRef.Init();
                        tmpCIRef."Document No." := CustomSalesLineRef."Document No.";
                        tmpCIRef."Item No." := CustomSalesLineRef."Item No.";
                        tmpCIRef."Line No." := CustomSalesLineRef."Line No.";
                        tmpCIRef."LineCount" := CustomSalesLineRef.LineCount;
                        tmpCIRef."DocumentLine No." := CustomSalesLineRef."DocumentLine No.";
                        tmpCIRef."Document Type" := CustomSalesLineRef."Document Type";
                        tmpCIRef."Serial No." := CustomSalesLineRef."Serial No.";
                        tmpCIRef.Insert();
                    until CustomSalesLineRef.Next() = 0;
                //Find totals of each item 
                tmpCI.Reset();
                tmpCI.SetCurrentKey(LineCount);
                tmpCI.SetAscending(LineCount, false);
                total := 0;
                if tmpCI.FindSet() then
                    repeat
                        total := 0;
                        lineFound := 1;
                        tmpCIRef.Reset();
                        tmpCIRef.SetCurrentKey(LineCount);
                        tmpCIRef.SetAscending(LineCount, false);
                        tmpCIRef.SetRange("Item No.", tmpCI."Item No.");
                        if tmpCIRef.FindSet() then
                            repeat
                                if (tmpCIRef."Item No." = tmpCI."Item No.") then begin
                                    total += 1;
                                end;
                                if (tmpCIRef."Item No." = tmpCI."Item No.") and (tmpCIRef."Line No." = tmpCI."Line No.") then begin
                                    lineFound := total;
                                end;
                            until tmpCIRef.Next() = 0;
                        tmpCI."M-Pack Qty" := total;
                        tmpCI."Package Quantity" := lineFound;
                        tmpCI.Modify();
                    until tmpCI.Next() = 0;
            end;

            trigger OnAfterGetRecord()
            var
                SalesHeader_LRec: Record "Sales Header";
                Location_LRec: Record Location;
                ItemUnitOfMeasure_LRec: Record "Item Unit of Measure";
                Item_LRec: Record Item;
                SalesLine: Record "Sales Line";
                Shipping_LRec: Record "Shipping Agent";
                item: Record Item;


            begin
                Type := '';
                Dept := '';
                // SpecRefValue := '';
                SKU := '';
                PONo := '';
                Style := '';
                PrePackNo := 0;
                PrePack := 0;
                // 7/7/25 - gets sku, syle, aand dept - start
                SKU := CustomSalesLine."Item No.";
                // 7/7/25 - gets sku, syle, aand dept - end

                SalesHeader_LRec.SetRange("No.", CustomSalesLine."Document No.");
                if SalesHeader_LRec.FindFirst() then begin
                    // 7/7/25 - PONo. and cust name - start
                    PONo := SalesHeader_LRec."External Document No.";
                    CustName := SalesHeader_LRec."Ship-to Name 2";
                    // 7/7/25 - PONo. and cust name - end
                    Type := SalesHeader_LRec.type;
                    Dept := SalesHeader_LRec.Dept;

                    ShipTo_Add[1] := SalesHeader_LRec."Ship-to Name";
                    ShipTo_Add[2] := SalesHeader_LRec."Ship-to Address";
                    ShipTo_Add[3] := SalesHeader_LRec."Ship-to Address 2";
                    ShipTo_Add[4] := SalesHeader_LRec."Ship-to City" + ', ' + SalesHeader_LRec."Ship-to County" + '  ' + SalesHeader_LRec."Ship-to Post Code";
                    CompressArray(ShipTo_Add);
                    // 7/7/25 - gets syle - start
                    ItemReference.SetRange("Item No.", CustomSalesLine."Item No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesHeader_LRec."Sell-to Customer No.");
                    IF ItemReference.FindFirst() then begin
                        Style := ItemReference."Reference No.";

                    end;
                    // 7/7/25 - - gets syle - end
                end;

                SalesHeader_LRec.Reset();
                SalesHeader_LRec.SetRange("No.", "Document No.");
                if SalesHeader_LRec.FindFirst() then begin
                    Location_LRec.SetRange(Code, SalesHeader_LRec."Location Code");
                    if Location_LRec.FindFirst() then begin
                        ShipFrm_LocAdd[1] := Location_LRec.Name;
                        ShipFrm_LocAdd[2] := Location_LRec.Address;
                        ShipFrm_LocAdd[3] := Location_LRec."Address 2";
                        ShipFrm_LocAdd[4] := Location_LRec.City + ', ' + Location_LRec.County + '  ' + Location_LRec."Post Code";

                    end;
                end;
                ShipToPostCode := SalesHeader_LRec."Ship-to Post Code";

                CasePackQty := 0;
                ItemUnitOfMeasure_LRec.Reset();
                ItemUnitOfMeasure_LRec.SetRange("Item No.", CustomSalesLine."Item No.");
                ItemUnitOfMeasure_LRec.SetRange(Code, 'M-PACK');
                if ItemUnitOfMeasure_LRec.FindFirst() then begin
                    CasePackQty := ItemUnitOfMeasure_LRec."Qty. per Unit of Measure";
                end;

                ItemUnitOfMeasure_LRec.Reset();
                ItemUnitOfMeasure_LRec.SetRange("Item No.", CustomSalesLine."Item No.");
                ItemUnitOfMeasure_LRec.SetRange(Code, 'INNER');
                if ItemUnitOfMeasure_LRec.FindFirst() then begin
                    PrePack := ItemUnitOfMeasure_LRec."Qty. per Unit of Measure";
                end;

                if (PrePack > 0) then
                    PrePackNo := CasePackQty / PrePack;

                // gets carton count and total
                tmpCI.Reset();
                tmpCI.SetRange("Item No.", CustomSalesLine."Item No.");
                tmpCI.SetRange("Line No.", CustomSalesLine."Line No.");
                if (tmpci.FindFirst()) then begin
                    LineFound := tmpci."Package Quantity";
                    TOtalcount := tmpCI."M-Pack Qty";
                end;
            end;
        }


    }
    trigger OnInitReport()
    begin

    end;



    var
        ShipFrm_LocAdd: array[8] of Text[100];
        ShipTo_Add: array[8] of Text[100];
        ItemReference: Record "Item Reference";
        CasePackQty: Decimal;
        ShipToPostCode: Text[30];
        TOtalcount: Integer;
        gtCartonInfo: record CartonInformation;
        Cust: Record Customer;
        Type: Text;
        Dept: Text;
        SKU: Code[20];
        Style: code[20];
        PrePack: Decimal;
        PrePackNo: Decimal;
        PONo: code[35];
        CustName: text[100];
        tmpCI: Record CartonInformation temporary;
        tmpCIRef: Record CartonInformation temporary;
        LineFound: Decimal;

}