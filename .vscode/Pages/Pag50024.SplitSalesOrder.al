page 50024 SplitSalesOrder
{
    ApplicationArea = All;
    Caption = 'Split Sales Order';
    PageType = List;
    SourceTable = TmpSalesLine;
    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {

        area(content)
        {
            group(SalesOrder)
            {
                Caption = 'Sales Order';
                field(DocumentNo; Rec.DocumentNo)
                {
                    Caption = 'Sales Order No.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(General)
            {

                field("No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies a description of the item or service on the line.';
                    Editable = false;
                    Style = StandardAccent;
                }
                field(OrigQuantity; Rec.OrigQuantity)
                {
                    ToolTip = 'Specifies the original quantity of the sales order line.';
                    Caption = 'Original Quantity';
                    Editable = false;
                    Style = Favorable;
                }
                field(RemainingQtyToAssign; CalcRemainingQty())
                {
                    Caption = 'Remaining Quantity to Assign';
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    Style = Unfavorable;
                }
                field("Unit of Measure Code";
                Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Editable = false;
                    Style = StandardAccent;
                }
                Field(Loc1Quantity; Rec.Loc1Quantity)
                {
                    CaptionClass = txtLoc1;
                    trigger OnValidate()
                    begin
                        CheckQtyBalance
                    end;

                }
                field(Loc2Quantity; Rec.Loc2Quantity)
                {
                    CaptionClass = txtLoc2;
                    trigger OnValidate()
                    begin
                        CheckQtyBalance
                    end;
                }
                field(Loc3Quantity; Rec.Loc3Quantity)
                {
                    CaptionClass = txtLoc3;
                    trigger OnValidate()
                    begin
                        CheckQtyBalance
                    end;
                }
                field(Loc4Quantity; Rec.Loc4Quantity)
                {
                    CaptionClass = txtLoc4;
                    trigger OnValidate()
                    begin
                        CheckQtyBalance
                    end;
                }
                field(Loc5Quantity; Rec.Loc5Quantity)
                {
                    CaptionClass = txtLoc5;
                    trigger OnValidate()
                    begin
                        CheckQtyBalance
                    end;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {

            action("SplitNow")
            {
                ApplicationArea = all;
                Caption = 'Split Now';
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    GetOrigSalesHeader: Record "Sales Header";
                    GetOrigSalesLine: Record "Sales Line";
                    NewSalesHeader: Record "Sales Header";
                    NewSalesLine: Record "Sales Line";
                    DocNo1: Code[20];
                    DocNo2: Code[20];
                    DocNo3: Code[20];
                    DocNo4: Code[20];
                    DocNo5: Code[20];
                    ExtDocNo1: Code[35];
                    ExtDocNo2: Code[35];
                    ExtDocNo3: Code[35];
                    ExtDocNo4: Code[35];
                    ExtDocNo5: Code[35];
                    Loc1: Code[10];
                    Loc2: Code[10];
                    Loc3: Code[10];
                    Loc4: Code[10];
                    Loc5: Code[10];
                    glQty: Decimal;
                    bCont: Boolean;
                begin
                    if (SalesNRecieveable.FindFirst()) then;

                    IF STRLEN(SalesNRecieveable."Order Nos.") = 0 then
                        Error('No. Series for Order Nos. is NOT set up.  Please review.');

                    CheckRemainingQty();  //check to make sure Remaining Qty for all lines = 0;
                    bCont := true;
                    Clear(popupConfirm);
                    popupConfirm.setMessage(StrSubstNo(TxtConfirmSplit, Rec.DocumentNo));
                    Commit;
                    if popupConfirm.RunModal() = Action::No then
                        bCont := false;
                    if bCont = true then begin
                        If Rec.FindFirst() then
                            repeat
                                If (Rec.Loc1Quantity > 0) and (StrLen(Rec.Loc1) > 0) then begin
                                    If strlen(DocNo1) = 0 then begin
                                        GetOrigSalesHeader.Reset();
                                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                                        IF GetOrigSalesHeader.FindFirst() then begin
                                            NewSalesHeader.Reset();
                                            NewSalesHeader.Init;
                                            NewSalesHeader.Copy(GetOrigSalesHeader);
                                            DocNo1 := NoSeriesMgt.GetNextNo(SalesNRecieveable."Order Nos.", Today, true);
                                            NewSalesHeader."No." := DocNo1;

                                            NewSalesHeader."External Document No." := NewSalesHeader."External Document No." + '-S1';
                                            ExtDocNo1 := NewSalesHeader."External Document No.";
                                            NewSalesHeader."Location Code" := Rec.Loc1;
                                            Loc1 := Rec.Loc1;
                                            NewSalesHeader.Insert();
                                            //10/15/25 
                                            genCU.AssignBOLForSO(NewSalesHeader);
                                        end;
                                    end;
                                    GetOrigSalesLine.Reset();
                                    GetOrigSalesLine.SetRange("Document No.", Rec.DocumentNo);
                                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::Item);
                                    GetOrigSalesLine.SetRange("Line No.", rec.LineNo);
                                    GetOrigSalesLine.SetRange("No.", Rec."Item No.");
                                    GetOrigSalesLine.SetRange(Quantity, Rec.OrigQuantity);
                                    GetOrigSalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                                    If GetOrigSalesLine.FindFirst() then begin
                                        NewSalesLine.Reset();
                                        NewSalesLine.Init();
                                        NewSalesLine.Copy(GetOrigSalesLine);
                                        NewSalesLine."Document No." := DocNo1;
                                        NewSalesLine."External Document No." := ExtDocNo1;
                                        NewSalesLine.Validate(Quantity, Rec.Loc1Quantity);
                                        NewSalesLine."Location Code" := Rec.Loc1;
                                        NewSalesLine.Insert;
                                    end;
                                end;
                                If (Rec.Loc2Quantity > 0) and (StrLen(Rec.Loc2) > 0) then begin
                                    If strlen(DocNo2) = 0 then begin
                                        GetOrigSalesHeader.Reset();
                                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                                        IF GetOrigSalesHeader.FindFirst() then begin
                                            NewSalesHeader.Reset();
                                            NewSalesHeader.Init;
                                            NewSalesHeader.Copy(GetOrigSalesHeader);
                                            DocNo2 := NoSeriesMgt.GetNextNo(SalesNRecieveable."Order Nos.", Today, true);
                                            NewSalesHeader."No." := DocNo2;

                                            NewSalesHeader."External Document No." := NewSalesHeader."External Document No." + '-S2';
                                            ExtDocNo2 := NewSalesHeader."External Document No.";
                                            NewSalesHeader."Location Code" := Rec.Loc2;
                                            Loc2 := Rec.Loc2;
                                            NewSalesHeader.Insert();
                                            //10/15/25 
                                            genCU.AssignBOLForSO(NewSalesHeader);
                                        end;
                                    end;
                                    GetOrigSalesLine.Reset();
                                    GetOrigSalesLine.SetRange("Document No.", Rec.DocumentNo);
                                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::Item);
                                    GetOrigSalesLine.SetRange("Line No.", rec.LineNo);
                                    GetOrigSalesLine.SetRange("No.", Rec."Item No.");
                                    GetOrigSalesLine.SetRange(Quantity, Rec.OrigQuantity);
                                    GetOrigSalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                                    If GetOrigSalesLine.FindFirst() then begin
                                        NewSalesLine.Reset();
                                        NewSalesLine.Init();
                                        NewSalesLine.Copy(GetOrigSalesLine);
                                        NewSalesLine."Document No." := DocNo2;
                                        NewSalesLine."External Document No." := ExtDocNo2;
                                        NewSalesLine.Validate(Quantity, Rec.Loc2Quantity);
                                        NewSalesLine."Location Code" := Rec.Loc2;
                                        NewSalesLine.Insert;
                                    end;
                                end;
                                If (Rec.Loc3Quantity > 0) and (StrLen(Rec.Loc3) > 0) then begin
                                    If strlen(DocNo3) = 0 then begin
                                        GetOrigSalesHeader.Reset();
                                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                                        IF GetOrigSalesHeader.FindFirst() then begin
                                            NewSalesHeader.Reset();
                                            NewSalesHeader.Init;
                                            NewSalesHeader.Copy(GetOrigSalesHeader);
                                            DocNo3 := NoSeriesMgt.GetNextNo(SalesNRecieveable."Order Nos.", Today, true);
                                            NewSalesHeader."No." := DocNo3;

                                            NewSalesHeader."External Document No." := NewSalesHeader."External Document No." + '-S3';
                                            ExtDocNo3 := NewSalesHeader."External Document No.";
                                            NewSalesHeader."Location Code" := Rec.Loc3;
                                            Loc3 := Rec.Loc3;
                                            NewSalesHeader.Insert();
                                            //10/15/25 
                                            genCU.AssignBOLForSO(NewSalesHeader);
                                        end;
                                    end;
                                    GetOrigSalesLine.Reset();
                                    GetOrigSalesLine.SetRange("Document No.", Rec.DocumentNo);
                                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::Item);
                                    GetOrigSalesLine.SetRange("Line No.", rec.LineNo);
                                    GetOrigSalesLine.SetRange("No.", Rec."Item No.");
                                    GetOrigSalesLine.SetRange(Quantity, Rec.OrigQuantity);
                                    GetOrigSalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                                    If GetOrigSalesLine.FindFirst() then begin
                                        NewSalesLine.Reset();
                                        NewSalesLine.Init();
                                        NewSalesLine.Copy(GetOrigSalesLine);
                                        NewSalesLine."Document No." := DocNo3;
                                        NewSalesLine."External Document No." := ExtDocNo3;
                                        NewSalesLine.Validate(Quantity, Rec.Loc3Quantity);
                                        NewSalesLine."Location Code" := Rec.Loc3;
                                        NewSalesLine.Insert;
                                    end;
                                end;
                                If (Rec.Loc4Quantity > 0) and (StrLen(Rec.Loc4) > 0) then begin
                                    If strlen(DocNo4) = 0 then begin
                                        GetOrigSalesHeader.Reset();
                                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                                        IF GetOrigSalesHeader.FindFirst() then begin
                                            NewSalesHeader.Reset();
                                            NewSalesHeader.Init;
                                            NewSalesHeader.Copy(GetOrigSalesHeader);
                                            DocNo4 := NoSeriesMgt.GetNextNo(SalesNRecieveable."Order Nos.", Today, true);
                                            NewSalesHeader."No." := DocNo4;

                                            NewSalesHeader."External Document No." := NewSalesHeader."External Document No." + '-S4';
                                            ExtDocNo4 := NewSalesHeader."External Document No.";
                                            NewSalesHeader."Location Code" := Rec.Loc4;
                                            Loc4 := Rec.Loc4;
                                            NewSalesHeader.Insert();
                                            //10/15/25 
                                            genCU.AssignBOLForSO(NewSalesHeader);
                                        end;
                                    end;
                                    GetOrigSalesLine.Reset();
                                    GetOrigSalesLine.SetRange("Document No.", Rec.DocumentNo);
                                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::Item);
                                    GetOrigSalesLine.SetRange("Line No.", rec.LineNo);
                                    GetOrigSalesLine.SetRange("No.", Rec."Item No.");
                                    GetOrigSalesLine.SetRange(Quantity, Rec.OrigQuantity);
                                    GetOrigSalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                                    If GetOrigSalesLine.FindFirst() then begin
                                        NewSalesLine.Reset();
                                        NewSalesLine.Init();
                                        NewSalesLine.Copy(GetOrigSalesLine);
                                        NewSalesLine."Document No." := DocNo4;
                                        NewSalesLine."External Document No." := ExtDocNo4;
                                        NewSalesLine.Validate(Quantity, Rec.Loc4Quantity);
                                        NewSalesLine."Location Code" := Rec.Loc4;
                                        NewSalesLine.Insert;
                                    end;
                                end;
                                If (Rec.Loc5Quantity > 0) and (StrLen(Rec.Loc5) > 0) then begin
                                    If strlen(DocNo5) = 0 then begin
                                        GetOrigSalesHeader.Reset();
                                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                                        IF GetOrigSalesHeader.FindFirst() then begin
                                            NewSalesHeader.Reset();
                                            NewSalesHeader.Init;
                                            NewSalesHeader.Copy(GetOrigSalesHeader);
                                            DocNo5 := NoSeriesMgt.GetNextNo(SalesNRecieveable."Order Nos.", Today, true);
                                            NewSalesHeader."No." := DocNo5;

                                            NewSalesHeader."External Document No." := NewSalesHeader."External Document No." + '-S5';
                                            ExtDocNo5 := NewSalesHeader."External Document No.";
                                            NewSalesHeader."Location Code" := Rec.Loc5;
                                            Loc5 := Rec.Loc5;
                                            NewSalesHeader.Insert();
                                            //10/15/25 
                                            genCU.AssignBOLForSO(NewSalesHeader);
                                        end;
                                    end;
                                    GetOrigSalesLine.Reset();
                                    GetOrigSalesLine.SetRange("Document No.", Rec.DocumentNo);
                                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::Item);
                                    GetOrigSalesLine.SetRange("Line No.", rec.LineNo);
                                    GetOrigSalesLine.SetRange("No.", Rec."Item No.");
                                    GetOrigSalesLine.SetRange(Quantity, Rec.OrigQuantity);
                                    GetOrigSalesLine.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                                    If GetOrigSalesLine.FindFirst() then begin
                                        NewSalesLine.Reset();
                                        NewSalesLine.Init();
                                        NewSalesLine.Copy(GetOrigSalesLine);
                                        NewSalesLine."Document No." := DocNo5;
                                        NewSalesLine."External Document No." := ExtDocNo5;
                                        NewSalesLine.Validate(Quantity, Rec.Loc5Quantity);
                                        NewSalesLine."Location Code" := Rec.Loc5;
                                        NewSalesLine.Insert;
                                    end;
                                end;

                            until Rec.Next() = 0;
                        If Rec.FindFirst() then;
                        // adds all g/l account lines to each new sales order - 10/25/25 - start
                        AddGLAccountLines(NewSalesHeader, DocNo1, ExtDocNo1, Loc1);
                        AddGLAccountLines(NewSalesHeader, DocNo2, ExtDocNo2, Loc2);
                        AddGLAccountLines(NewSalesHeader, DocNo3, ExtDocNo3, Loc3);
                        AddGLAccountLines(NewSalesHeader, DocNo4, ExtDocNo4, Loc4);
                        AddGLAccountLines(NewSalesHeader, DocNo5, ExtDocNo5, Loc5);
                        // adds all g/l account lines to each new sales order - 10/25/25 - end
                        GetOrigSalesHeader.Reset();
                        GetOrigSalesHeader.SetRange("Document Type", GetOrigSalesHeader."Document Type"::Order);
                        GetOrigSalesHeader.SetRange("No.", Rec.DocumentNo);
                        IF GetOrigSalesHeader.FindFirst() then begin
                            GetOrigSalesHeader.Split := true;
                            GetOrigSalesHeader.Modify();
                            Commit();
                            GetOrigSalesHeader.Delete(true);
                            Commit();
                        end;

                        //10/15/25 recalcs edi for g/l account lines - start
                        ReCalcEDI(NewSalesHeader, DocNo1);
                        ReCalcEDI(NewSalesHeader, DocNo2);
                        ReCalcEDI(NewSalesHeader, DocNo3);
                        ReCalcEDI(NewSalesHeader, DocNo4);
                        ReCalcEDI(NewSalesHeader, DocNo5);
                        //10/15/25 recalcs edi for g/l account lines - end
                        Message(TxtSOCreated);
                    end;

                end;

            }
        }
    }

    procedure ReCalcEDI(NewSalesHeader: Record "Sales Header"; DocNo: Code[20])
    begin
        if (DocNo = '') then
            exit;
        NewSalesHeader.Reset();
        NewSalesHeader.SetRange("Document Type", NewSalesHeader."Document Type"::Order);
        NewSalesHeader.SetRange("No.", DocNo);
        if NewSalesHeader.FindFirst() then
            genCU.ReCalcEDI(NewSalesHeader, false);
    end;

    procedure AddGLAccountLines(NewSalesHeader: Record "Sales Header"; DocNo: Code[20];
    ExtDocNo: Code[35]; Loc: Code[10])
    var
        GetOrigSalesLine: Record "Sales Line";
        NewSalesLine: Record "Sales Line";
    begin
        NewSalesHeader.Reset();
        NewSalesHeader.SetRange("Document Type", NewSalesHeader."Document Type"::Order);
        NewSalesHeader.SetRange("No.", DocNo);
        if NewSalesHeader.FindFirst() then begin
            If glLines.FindFirst() then
                repeat
                    GetOrigSalesLine.Reset();
                    GetOrigSalesLine.SetRange("Document No.", glLines.DocumentNo);
                    GetOrigSalesLine.SetRange("Document Type", GetOrigSalesLine."Document Type"::Order);
                    GetOrigSalesLine.SetRange(Type, GetOrigSalesLine.Type::"G/L Account");
                    GetOrigSalesLine.SetRange("Line No.", glLines.LineNo);
                    GetOrigSalesLine.SetRange("No.", glLines."Item No.");
                    GetOrigSalesLine.SetRange(Quantity, glLines.OrigQuantity);
                    GetOrigSalesLine.SetRange("Unit of Measure Code", glLines."Unit of Measure Code");
                    If GetOrigSalesLine.FindFirst() then begin
                        NewSalesLine.Reset();
                        NewSalesLine.Init();
                        NewSalesLine.Copy(GetOrigSalesLine);
                        NewSalesLine."Document No." := DocNo;
                        NewSalesLine."External Document No." := ExtDocNo;
                        NewSalesLine.Validate(Quantity, GetOrigSalesLine.Quantity);
                        NewSalesLine."Location Code" := Loc;
                        NewSalesLine.Insert;
                    end;
                until glLines.Next() = 0;
            // Add code to add G/L account lines here
        end;
    end;

    var
        genCU: Codeunit GeneralCU;
        SalesLine: Record "Sales Line";
        txtLoc1: text[20];
        txtLoc2: text[20];
        txtLoc3: text[20];
        txtLoc4: text[20];
        txtLoc5: text[20];
        TextQtyErr: Label 'The sum of the Location breakdown of %1 CANNOT BE More than the Original Quantity %2.';
        TxtSOCreated: Label 'Split of Sales Order successfully created.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesNRecieveable: Record "Sales & Receivables Setup";

        TxtRemainingqtyErr: Label 'You cannot have Remaining Qty to Apply GREATER THAN 0! Please review and correct.';

        TxtConfirmSplit: Label 'Original Sales Order will be deleted after the split. Proceed?';
        popupConfirm: Page "Confirmation Dialog";
        glLines: Record TmpSalesLine temporary;

    procedure InitPage(InNo: Code[20]; InLoc1: Code[10]; InLoc2: Code[10]; InLoc3: Code[10]; InLoc4: Code[10]; InLoc5: Code[10])
    var
        i: Integer;
        SalesHeader: Record "Sales Header";
    begin
        /* 10/14/25 recalcs edi for g/l account lines - start
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", InNo);
        if (SalesHeader.FindFirst()) then begin
            // SalesHeader.ReCalcEDI(false);
            // genCU.ReCalcEDI(SalesHeader, false);
            //  Commit(); // Commit changes to avoid record lock issues with parent page
        end;
        // 10/14/25 recalcs edi for g/l account lines - end*/
        //  If SalesHeader.FindFirst() then;
        Rec.DeleteAll();
        i := 0;
        SalesLine.RESET;
        SalesLine.SetRange("Document No.", InNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        // 10/25/25 - includes g/l acoount lines
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat

                Rec.Init();
                i += 1;
                Rec.EntryNo := i;
                Rec.DocumentNo := InNo;
                // 10/15/25 - start
                rec.LineNo := SalesLine."Line No.";
                // 10/15/25 - end
                Rec."Item No." := SalesLine."No.";
                Rec."Item Description" := SalesLine.Description;
                Rec."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                Rec.OrigQuantity := SalesLine.Quantity;
                Rec.Loc1 := InLoc1;
                Rec.Loc1Quantity := SalesLine.Quantity;
                Rec.Loc2 := InLoc2;
                Rec.Loc3 := InLoc3;
                Rec.Loc4 := Inloc4;
                Rec.Loc5 := InLoc5;
                Rec.Insert();
            until SalesLine.next = 0;
        // 10/25/25 - includes g/l acoount lines
        glLines.DeleteAll();
        i := 0;
        SalesLine.RESET;
        SalesLine.SetRange("Document No.", InNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        if SalesLine.FindSet() then
            repeat

                glLines.Init();
                i += 1;
                glLines.EntryNo := i;
                glLines.DocumentNo := InNo;
                // 10/15/25 - start
                glLines.LineNo := SalesLine."Line No.";
                // 10/15/25 - end
                glLines."Item No." := SalesLine."No.";
                glLines."Item Description" := SalesLine.Description;
                glLines."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                glLines.OrigQuantity := SalesLine.Quantity;
                glLines.Loc1 := InLoc1;
                glLines.Loc1Quantity := SalesLine.Quantity;
                glLines.Loc2 := InLoc2;
                glLines.Loc3 := InLoc3;
                glLines.Loc4 := InLoc4;
                glLines.Loc5 := InLoc5;
                glLines.Insert();
            until SalesLine.next = 0;




    end;

    trigger OnOpenPage()
    begin
        txtLoc1 := Rec.loc1 + ' Quantity';
        txtLoc2 := Rec.Loc2 + ' Quantity';
        txtLoc3 := Rec.Loc3 + ' Quantity';
        txtLoc4 := Rec.Loc4 + ' Quantity';
        txtLoc5 := Rec.Loc5 + ' Quantity';



    end;

    procedure CheckQtyBalance()
    var
        qtyBal: Decimal;
    begin
        qtyBal := 0;
        If StrLen(Rec.Loc1) > 0 then
            qtyBal += Rec.Loc1Quantity;
        If StrLen(Rec.Loc2) > 0 then
            qtyBal += Rec.Loc2Quantity;
        If StrLen(Rec.Loc3) > 0 then
            qtyBal += Rec.Loc3Quantity;
        If StrLen(Rec.Loc4) > 0 then
            qtyBal += Rec.Loc4Quantity;
        If StrLen(Rec.Loc5) > 0 then
            qtyBal += Rec.Loc5Quantity;

        If Rec.OrigQuantity < qtyBal then
            Error(TextQtyErr, Format(qtyBal), Format(Rec.OrigQuantity));

        CurrPage.Update(true);
    end;

    local procedure CalcRemainingQty(): Decimal
    var
        GetRemainingQty: Decimal;
    begin
        GetRemainingQty := Rec.OrigQuantity;
        If StrLen(Rec.Loc1) > 0 then
            GetRemainingQty -= Rec.Loc1Quantity;
        If StrLen(Rec.Loc2) > 0 then
            GetRemainingQty -= Rec.Loc2Quantity;
        If StrLen(Rec.Loc3) > 0 then
            GetRemainingQty -= Rec.Loc3Quantity;
        If StrLen(Rec.Loc4) > 0 then
            GetRemainingQty -= Rec.Loc4Quantity;
        If StrLen(Rec.Loc5) > 0 then
            GetRemainingQty -= Rec.Loc5Quantity;
        exit(GetRemainingQty);
    end;

    local procedure CheckRemainingQty()
    begin
        If Rec.FindFirst() then
            repeat
                If CalcRemainingQty() <> 0 then
                    Error(TxtRemainingqtyErr);
            until Rec.Next = 0;
    end;
}
