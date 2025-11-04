codeunit 50005 AdminCU
{
    // pr 12/1/23 code for job queue from Nutraza
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Cust. Ledger Entry" = RIMD, tabledata "Vendor Ledger Entry" = RIMD,
    tabledata "G/L Entry" = RIMD, tabledata "Bank Account Ledger Entry" = RIMD,
    tabledata "Detailed Cust. Ledg. Entry" = RIMD, tabledata "Detailed Vendor Ledg. Entry" = RIMD,
    tabledata "Posted Gen. Journal Line" = RIMD, tabledata "Value Entry" = RIMD, tabledata "Sales Invoice Header" = RIMD,
    tabledata "Purch. Rcpt. Header" = RIMD, tabledata "Purch. Inv. Header" = RIMD,
    tabledata "Purch. Cr. Memo Line" = RIMD, tabledata "Purch. Inv. Line" = RIMD, tabledata "Posted Whse. Receipt Line" = RIMD,
    tabledata "Tracking Specification" = RIMD, tabledata "Purch. Rcpt. Line" = RIMD, tabledata "Item Ledger Entry" = RIMD,
    tabledata "Tenant Media" = RIMD,
    tabledata "Warehouse Entry" = RIMD;


    trigger OnRun()
    begin
        If Rec."Parameter String" = 'UpdPostingPeriod' then
            UpdPostingPeriod()
        else
            if rec."Parameter String" = 'AdjCostItems' then
                AdjCostItems()
            else if
             rec."Parameter String" = 'UpdIRS1099' then
                UpdIRS1099()
            else if
              rec."Parameter String" = 'UpdatePurchProdStatAndPOFinalizedDT' then
                UpdatePurchProdStatAndPOFinalizedDT()
            else if
                rec."Parameter String" = 'UpdateCustomerSupplierAlias' then
                UpdateCustomerSupplierAlias()
            else if
                rec."Parameter String" = 'UpdateItemUOMWtKg' then
                UpdateItemUOMWtKg()
            else if
                rec."Parameter String" = 'UpdateSupplierAlias' then
                UpdateSupplierAlias()
            else if
                rec."Parameter String" = 'FixSingleBOL' then
                FixSingleBOL()
            else if
                rec."Parameter String" = 'RefreshPurchLines' then
                RefreshPurchLines()
            else if
                rec."Parameter String" = 'TransToContainer' then
                TransToContainer()
            else if
                rec."Parameter String" = 'CleanupContainerLines' then
                CleanupContainerLines()
            else if
                rec."Parameter String" = 'CleanupContainerorderstat' then
                CleanupContainerorderstat()
            else if
                rec."Parameter String" = 'UpdateTransferLineCustCode' then
                UpdateTransferLineCustCode()
            else if
                rec."Parameter String" = 'fixTypeDeptSO' then
                fixTypeDeptSO()
            else if
                rec."Parameter String" = 'fixContainerLine' then
                fixContainerLine()
            else if
                rec."Parameter String" = 'CleanupAttachments' then
                CleanupAttachments()
            else if
            rec."Parameter String" = 'UpdateTransferLineDimCode1' then
                UpdateTransferLineDimCode1()
            else if
            rec."Parameter String" = 'GetShipLabelFromCustForSO' then
                GetShipLabelFromCustForSO()
            else if
            rec."Parameter String" = 'RefreshTOTelexReleased' then
                RefreshTOTelexReleased()
            else if
            rec."Parameter String" = 'BackFillEarliestStartShipDatePurchaseLines' then
                BackFillEarliestStartShipDatePurchaseLines()
            else if
            rec."Parameter String" = 'BackFillEarliestStartShipDateContainerLines' then
                BackFillEarliestStartShipDateContainerLines()
            else if
            rec."Parameter String" = 'UpdatePurchLinesAndContainerLines' then
                UpdatePurchLinesAndContainerLines()
            else if
            rec."Parameter String" = 'UpdateSpecificContainerLine' then
                UpdateSpecificContainerLine()
            else if
            rec."Parameter String" = 'FixPurchaseLineQuantityMismatches' then
                FixPurchaseLineQuantityMismatches()
            else if
            rec."Parameter String" = 'FixOpenCustomerLedgerEntries' then
                FixOpenCustomerLedgerEntries()
            else if
            rec."Parameter String" = 'FixSalesLineEDILineDiscount' then
                FixSalesLineEDILineDiscount()
            else if rec."Parameter String" = 'ManualFixWhseItemJournals' then
                ManualFixWhseItemJournals();

    end;

    procedure UpdPostingPeriod()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.SetCurrentKey(AutoUpdate);
        UserSetup.SetFilter(AutoUpdate, '=%1', true);
        IF UserSetup.FindSet then
            repeat
                IF UserSetup."Auto Update Posting To" = false then
                    UserSetup."Allow Posting From" := TODAY;
                UserSetup."Allow Posting To" := TODAY;
                UserSetup.Modify;
            until UserSetup.Next = 0;
    end;

    procedure AdjCostItems()
    var
        AdjItemEntry_Rpt: report "Adjust Cost - Item Entries";
        InvSetup_Rec: record "Inventory Setup";
    begin
        Clear(AdjItemEntry_Rpt);
        AdjItemEntry_Rpt.UseRequestPage := false;
        InvSetup_Rec.Get;
        AdjItemEntry_Rpt.SetPostToGL(true);
        AdjItemEntry_Rpt.RUN;
    end;

    procedure CleanupBCARAndAP()
    var
        DetailedCLE: record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        BLE: Record "Bank Account Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        DetailedVLE: Record "Detailed Vendor Ledg. Entry";
        PostedGenLn: Record "Posted Gen. Journal Line";

        DtCutoff: Date;
    begin

        // DtCutoff := DMY2Date(1, 1, 2024);
        // message('DtCutoff is ' + FORMAT(DtCutoff));
        // DetailedCLE.Reset();
        // DetailedCLE.SetFilter("Posting Date", '<%1', DtCutoff);
        // If DetailedCLE.FindSet() then
        //     DetailedCLE.DeleteAll();

        // CLE.Reset();
        // CLE.SetFilter("Posting Date", '<%1', DtCutoff);
        // If CLE.FindSet() then
        //     CLE.DeleteAll();

        // GLE.Reset();
        // GLE.SetFilter("Posting Date", '<%1', DtCutoff);
        // If GLE.FindSet() then
        //     GLE.DeleteAll();

        // BLE.Reset();
        // BLE.SetFilter("Document No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12|%13|%14|%15|%16|%17', 'G02015', 'G02014', 'G02007', '2131339', 'G02012', 'G02011', 'G02010', 'G02009', 'G02005', 'G02002', 'G02006', 'G00353', 'G02001', 'G02003', 'G02021', 'INV-9425', 'INV-10359');
        // If BLE.FindSet() then
        //     BLE.DeleteAll();

        // VLE.Reset();
        // VLE.SetFilter("Posting Date", '<%1', DtCutoff);
        // If VLE.FindSet() then
        //     VLE.DeleteAll();

        // DetailedVLE.Reset();
        // DetailedVLE.SetFilter("Posting Date", '<%1', DtCutoff);
        // If DetailedVLE.FindSet() then
        //     DetailedVLE.DeleteAll();

        // PostedGenLn.RESET;
        // PostedGenLn.SetFilter("Posting Date", '<%1', DtCutoff);
        // If PostedGenLn.FindSet() then
        //     PostedGenLn.DeleteAll();

        // Message('CleanupBC AR and AP done.');
    end;

    procedure CleanupBCARAndAP2023()
    var
        DetailedCLE: record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        BLE: Record "Bank Account Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        DetailedVLE: Record "Detailed Vendor Ledg. Entry";
        PostedGenLn: Record "Posted Gen. Journal Line";

        DtCutoff: Date;
        DtStartDt: Date;
    begin
        // DtCutoff := DMY2Date(1, 1, 2024);
        // DtStartDt := DMY2Date(1, 1, 2023);
        // message('DtCutoff is ' + FORMAT(DtCutoff) + 'DtStart is ' + FORMAT(DtStartDt));

        // DetailedCLE.Reset();
        // DetailedCLE.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If DetailedCLE.FindSet() then
        //     DetailedCLE.DeleteAll();

        // CLE.Reset();
        // CLE.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If CLE.FindSet() then
        //     CLE.DeleteAll();

        // GLE.Reset();
        // GLE.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If GLE.FindSet() then
        //     GLE.DeleteAll();

        // VLE.Reset();
        // VLE.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If VLE.FindSet() then
        //     VLE.DeleteAll();

        // DetailedVLE.Reset();
        // DetailedVLE.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If DetailedVLE.FindSet() then
        //     DetailedVLE.DeleteAll();

        // PostedGenLn.RESET;
        // PostedGenLn.SetFilter("Posting Date", '<%1&>%2', DtCutoff, DtStartDt);
        // If PostedGenLn.FindSet() then
        //     PostedGenLn.DeleteAll();

        // Message('CleanupBC AR and AP done.');
    end;


    procedure UpdateSalesInv_April_11()
    var
        PSI: record "Sales Invoice Header";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        DetailedCLE: Record "Detailed Cust. Ledg. Entry";
        VE: Record "Value Entry";


        NewDt: Date;
    begin

        NewDt := DMY2Date(11, 4, 2024);
        message('NewDt is ' + FORMAT(NewDt));
        PSI.Reset();
        PSI.SetFilter(PSI."No.", '%1|%2|%3|%4|%5|%6', 'PS-INV1001961', 'PS-INV1001960', 'PS-INV1001959', 'PS-INV1001958', 'PS-INV1001804', 'PS-INV1001796');
        repeat
            PSI."Posting Date" := NewDt;
            PSI."Document Date" := NewDt;
            PSI."Pmt. Discount Date" := NewDt;
            PSI.Modify(false);
        Until PSI.Next() = 0;

        GLE.Reset();
        GLE.SetFilter(GLE."Document No.", '%1|%2|%3|%4|%5|%6', 'PS-INV1001961', 'PS-INV1001960', 'PS-INV1001959', 'PS-INV1001958', 'PS-INV1001804', 'PS-INV1001796');
        IF GLE.FindSet() then
            repeat
                GLE."Posting Date" := NewDt;
                GLE."Document Date" := NewDt;
                GLE.Modify(false);
            Until GLE.Next() = 0;

        CLE.Reset();
        CLE.SetFilter(CLE."Document No.", '%1|%2|%3|%4|%5|%6', 'PS-INV1001961', 'PS-INV1001960', 'PS-INV1001959', 'PS-INV1001958', 'PS-INV1001804', 'PS-INV1001796');
        IF CLE.FindSet() then
            repeat
                CLE."Posting Date" := NewDt;
                CLE."Document Date" := NewDt;
                CLE."Pmt. Discount Date" := NewDt;
                CLE.Modify(false);
            Until CLE.Next() = 0;

        DetailedCLE.Reset();
        DetailedCLE.SetFilter(DetailedCLE."Document No.", '%1|%2|%3|%4|%5|%6', 'PS-INV1001961', 'PS-INV1001960', 'PS-INV1001959', 'PS-INV1001958', 'PS-INV1001804', 'PS-INV1001796');
        IF DetailedCLE.FindSet() then
            repeat
                DetailedCLE."Posting Date" := NewDt;
                DetailedCLE.Modify(false);
            Until DetailedCLE.Next() = 0;

        VE.Reset();
        VE.SetFilter(VE."Document No.", '%1|%2|%3|%4|%5|%6', 'PS-INV1001961', 'PS-INV1001960', 'PS-INV1001959', 'PS-INV1001958', 'PS-INV1001804', 'PS-INV1001796');
        IF VE.FindSet() then
            repeat
                VE."Posting Date" := NewDt;
                VE."Document Date" := NewDt;
                VE."Valuation Date" := NewDt;
                VE.Modify(false);
            Until VE.Next() = 0;
        Message('Posted Sales Invoices Date Update Done.');
    end;

    procedure FixCOGS()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
    begin

        FromDt := DMY2Date(1, 1, 2024);
        message('FromDt is ' + FORMAT(FromDt));

        GLE.Reset();
        GLE.SetRange("Posting Date", FromDt, Today);
        GLE.SetRange("Document Type", GLE."Document Type"::Invoice);
        GLE.SetRange("G/L Account No.", '20100');
        GLE.SetFilter(Description, 'Order*');
        // GLE.SetFilter(GLE."Document No.", '%1|%2', '110577', '110583');
        IF GLE.FindSet() then
            repeat
                GLEChk.Reset();
                GLEChk.SetRange("Document No.", GLE."Document No.");
                GLEChk.SetRange("Posting Date", GLE."Posting Date");
                GLEChk.SetRange("Document Type", GLE."Document Type");
                GLEChk.SetRange("G/L Account No.", '50100');
                IF GLEChk.FindSet() then
                    repeat
                        if GLEChk.Amount = Abs(GLE.Amount) then begin
                            GLEChk.Validate("G/L Account No.", '20100');
                            GLEChk.Modify(false);
                        end;
                    until GLEChk.Next = 0;
            Until GLE.Next() = 0;


        Message('COGS Fix Done.');
    end;

    procedure FixCOGSInvInterim()
    var
        PurchInvHdr: Record "Purch. Inv. Header";
        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
    begin

        FromDt := DMY2Date(1, 1, 2024);
        message('FromDt is ' + FORMAT(FromDt));

        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Posting Date", FromDt, Today);
        IF PurchInvHdr.FindSet() then
            repeat
                GLE.Reset();
                GLE.SetRange("Posting Date", FromDt, Today);
                GLE.SetRange("Document No.", PurchInvHdr."No.");
                GLE.SetRange("G/L Account No.", '10700');

                IF GLE.FindSet() then
                    repeat
                        GLEChk.Reset();
                        GLEChk.SetRange("Document No.", GLE."Document No.");
                        GLEChk.SetRange("Posting Date", GLE."Posting Date");
                        GLEChk.SetRange("G/L Account No.", '50410');
                        IF GLEChk.FindSet() then
                            repeat
                                if GLEChk.Amount = Abs(GLE.Amount) then begin
                                    GLEChk.Validate("G/L Account No.", '20500');
                                    GLEChk.Modify(false);
                                end;
                            until GLEChk.Next() = 0;
                    Until GLE.Next() = 0;
            until PurchInvHdr.Next() = 0;



        Message('COGS Inv Interim Fix Done.');
    end;


    procedure FixCOGSRcptInterim()
    var
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
    begin

        FromDt := DMY2Date(1, 1, 2024);
        message('FromDt is ' + FORMAT(FromDt));
        PurchRcptHdr.Reset();
        PurchRcptHdr.SetRange("Posting Date", FromDt, Today);
        IF PurchRcptHdr.FindSet() then
            repeat
                GLE.Reset();
                GLE.SetRange("Posting Date", FromDt, Today);
                GLE.SetRange("Document No.", PurchRcptHdr."No.");
                GLE.SetRange("G/L Account No.", '10700');

                IF GLE.FindSet() then
                    repeat
                        GLEChk.Reset();
                        GLEChk.SetRange("Document No.", GLE."Document No.");
                        GLEChk.SetRange("Posting Date", GLE."Posting Date");
                        GLEChk.SetRange("G/L Account No.", '50410');
                        IF GLEChk.FindFirst() then begin
                            if abs(GLEChk.Amount) = GLE.Amount then begin
                                GLEChk.Validate("G/L Account No.", '20500');
                                GLEChk.Modify(false);
                            end;
                        end;
                    Until GLE.Next() = 0;
            until PurchRcptHdr.Next() = 0;




        Message('COGS Rcpt Interim Fix Done.');
    end;

    procedure FixCOGSOpening()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        FromDt := DMY2Date(1, 1, 2024);
        ToDt := DMY2Date(16, 1, 2024);
        message('Daterange is %1-%2 ' + FORMAT(FromDt), Format(ToDt));

        GLE.Reset();
        GLE.SetRange("Posting Date", FromDt, ToDt);
        GLE.SetRange("User ID", 'ANISH');
        GLE.SetRange("G/L Account No.", '50100');
        GLE.SetFilter("Document No.", 'IJ*');
        // GLE.SetFilter(GLE."Document No.", '%1|%2', '110577', '110583');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '99999');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('COGS Opening Fix Done.');
    end;

    procedure FixCOGS_ItemJournal()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        ToDt := DMY2Date(16, 1, 2024);
        message('Daterange is > %1 ', Format(ToDt));

        GLE.Reset();
        GLE.SetFilter("Posting Date", '>%1', ToDt);
        GLE.SetRange("G/L Account No.", '50100');
        GLE.SetFilter("Document No.", 'IJ*');

        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '50410');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('COGS Item Journal Adj Opening Fix Done.');
    end;

    procedure FixCOGS_AssemblyORders()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        ToDt := DMY2Date(1, 1, 2024);
        message('Daterange is > %1 ', Format(ToDt));

        GLE.Reset();
        GLE.SetFilter("Posting Date", '>%1', ToDt);
        GLE.SetRange("G/L Account No.", '50100');
        GLE.SetFilter("Document No.", 'A*');

        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '50410');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('COGS Assembly ORders Fix Done.');
    end;

    procedure FixCOGS_Revaluation()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        ToDt := DMY2Date(1, 1, 2024);
        message('Daterange is > %1 ', Format(ToDt));

        GLE.Reset();
        GLE.SetFilter("Posting Date", '>%1', ToDt);
        GLE.SetRange("G/L Account No.", '50100');
        GLE.SetFilter("Document No.", 'REV*');

        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '50410');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('COGS Revaluation Fix Done.');
    end;

    procedure FixCOGSPurchases()
    var

        GLE: Record "G/L Entry";
        PurchInvLn: Record "Purch. Inv. Line";
        PurchCrLn: Record "Purch. Cr. Memo Line";
        FromDt: Date;
        ToDt: Date;
        bUpdate: Boolean;
    begin
        FromDt := DMY2Date(1, 1, 2024);
        ToDt := DMY2Date(31, 3, 2024);
        message('DateStart is  %1 ', Format(FromDt));

        GLE.Reset();
        GLE.SetFilter("Posting Date", '>%1', FromDt);
        GLE.SetRange("G/L Account No.", '50100');
        GLE.SetFilter("Source Code", 'PURCHASES');
        GLE.SetFilter("Document Type", '%1|%2', GLE."Document Type"::Invoice, GLE."Document Type"::"Credit Memo");

        IF GLE.FindSet() then
            repeat
                bUpdate := true;
                IF GLE."Document Type" = GLE."Document Type"::Invoice then begin
                    PurchInvLn.Reset();
                    PurchInvLn.SetRange("Document No.", GLE."Document No.");
                    PurchInvLn.SetRange(Type, PurchInvLn.Type::"G/L Account");
                    PurchInvLn.SetRange(Amount, GLE.Amount);
                    PurchInvLn.SetRange("No.", GLE."G/L Account No.");
                    IF PurchInvLn.findfirst then
                        bUpdate := false;
                end
                else IF GLE."Document Type" = GLE."Document Type"::"Credit Memo" then begin
                    PurchCrLn.Reset();
                    PurchCrLn.SetRange("Document No.", GLE."Document No.");
                    PurchCrLn.SetRange(Type, PurchCrLn.Type::"G/L Account");
                    PurchCrLn.SetRange(Amount, abs(GLE.Amount));
                    PurchCrLn.SetRange("No.", GLE."G/L Account No.");
                    IF PurchCrLn.findfirst then
                        bUpdate := false;
                end;
                if bUpdate = true then begin
                    GLE.Validate("G/L Account No.", '20100');
                    GLE.Modify(false);
                end;
            Until GLE.Next() = 0;


        Message('COGS Invoice/CM Fix Done.');
    end;

    procedure FixJanFebAdj()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        FromDt := DMY2Date(17, 1, 2024);
        ToDt := DMY2Date(29, 2, 2024);
        message('Daterange is %1-%2 ' + FORMAT(FromDt), Format(ToDt));

        GLE.Reset();
        GLE.SetRange("Posting Date", FromDt, ToDt);
        GLE.SetRange("G/L Account No.", '50410');
        GLE.SetFilter("Document No.", 'IJ*');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '99999');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('Adj for Jan-Feb Done.');
    end;

    procedure FixADJEXP022024()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        FromDt := DMY2Date(17, 1, 2024);
        ToDt := DMY2Date(29, 2, 2024);
        message('Daterange is %1-%2 ' + FORMAT(FromDt), Format(ToDt));

        GLE.Reset();
        GLE.SetRange("G/L Account No.", '50410');
        GLE.SetFilter("Document No.", 'ADJEXP022024');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '99999');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('Adj ADJEXP022024 Done.');
    end;

    procedure FixPostedWhseRecptLine()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        FromDt := DMY2Date(17, 1, 2024);
        ToDt := DMY2Date(29, 2, 2024);

        GLE.Reset();
        GLE.SetRange("G/L Account No.", '50410');
        GLE.SetFilter("Document No.", '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7', 'REV*', 'IJ*', 'TS*', 'TR*', 'A0*', '109029', 'ADJEXP022024');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '20500');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('Adj FixPostedWhseRecptLine Done.');
    end;

    procedure GlEntry59820()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        FromDt := DMY2Date(17, 1, 2024);
        ToDt := DMY2Date(29, 2, 2024);

        GLE.Reset();
        GLE.SetRange("Entry No.", 59820);
        //  GLE.SetFilter("Document No.", '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7', 'REV*', 'IJ*', 'TS*', 'TR*', 'A0*', '109029', 'ADJEXP022024');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '50410');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('Adj 59820 Done.');
    end;

    procedure MarkPaymentDiscountAsCM()
    var
        DetailedCLE: record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        PostedGenLn: Record "Posted Gen. Journal Line";

    begin

        CLE.Reset();
        CLE.SetRange("Document Type", CLE."Document Type"::" ");
        CLE.SetRange(Description, 'Payment Term Discount');
        If CLE.FindSet() then
            repeat
                CLE."Document Type" := CLE."Document Type"::"Credit Memo";
                CLE.Modify(false);

                DetailedCLE.Reset();
                DetailedCLE.SetRange("Document No.", CLE."Document No.");
                DetailedCLE.SetRange("Posting Date", cle."Posting Date");
                if DetailedCLE.FindSet() then
                    repeat
                        DetailedCLE."Document Type" := DetailedCLE."Document Type"::"Credit Memo";
                        DetailedCLE.Modify(false);
                    until DetailedCLE.Next() = 0;

                GLE.Reset();
                GLE.SetRange("Document No.", CLE."Document No.");
                GLE.SetRange("Posting Date", CLE."Posting Date");
                if GLE.FindSet() then
                    repeat
                        GLE."Document Type" := GLE."Document Type"::"Credit Memo";
                        GLE.Modify(false);
                    until GLE.Next() = 0;

                PostedGenLn.Reset();
                PostedGenLn.SetRange("Document No.", CLE."Document No.");
                PostedGenLn.SetRange("Posting Date", CLE."Posting Date");
                if PostedGenLn.FindSet() then
                    repeat
                        PostedGenLn."Document Type" := PostedGenLn."Document Type"::"Credit Memo";
                        PostedGenLn.Modify(false);
                    until PostedGenLn.Next() = 0;

            until CLE.Next = 0;


        Message('Update of Payment Discount in CLE done.');
    end;


    procedure MarkCLEBlankNegAsPayment()
    var
        DetailedCLE: record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        PostedGenLn: Record "Posted Gen. Journal Line";

    begin

        CLE.Reset();
        CLE.SetRange("Document Type", CLE."Document Type"::" ");
        CLE.SetFilter(Amount, '<%1', 0);
        If CLE.FindSet() then
            repeat
                CLE."Document Type" := CLE."Document Type"::Payment;
                CLE.Modify(false);

                DetailedCLE.Reset();
                DetailedCLE.SetRange("Document No.", CLE."Document No.");
                DetailedCLE.SetRange("Posting Date", cle."Posting Date");
                if DetailedCLE.FindSet() then
                    repeat
                        DetailedCLE."Document Type" := DetailedCLE."Document Type"::Payment;
                        DetailedCLE.Modify(false);
                    until DetailedCLE.Next() = 0;

                GLE.Reset();
                GLE.SetRange("Document No.", CLE."Document No.");
                GLE.SetRange("Posting Date", CLE."Posting Date");
                if GLE.FindSet() then
                    repeat
                        GLE."Document Type" := GLE."Document Type"::Payment;
                        GLE.Modify(false);
                    until GLE.Next() = 0;

                PostedGenLn.Reset();
                PostedGenLn.SetRange("Document No.", CLE."Document No.");
                PostedGenLn.SetRange("Posting Date", CLE."Posting Date");
                if PostedGenLn.FindSet() then
                    repeat
                        PostedGenLn."Document Type" := PostedGenLn."Document Type"::Payment;
                        PostedGenLn.Modify(false);
                    until PostedGenLn.Next() = 0;

            until CLE.Next = 0;


        Message('Update of Payment in CLE done.');
    end;



    procedure MarkCLEBlankPosAsRefund()
    var
        DetailedCLE: record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        GLE: Record "G/L Entry";
        PostedGenLn: Record "Posted Gen. Journal Line";

    begin

        CLE.Reset();
        CLE.SetRange("Document Type", CLE."Document Type"::" ");
        CLE.SetFilter(Amount, '>%1', 0);
        If CLE.FindSet() then
            repeat
                CLE."Document Type" := CLE."Document Type"::Refund;
                CLE.Modify(false);

                DetailedCLE.Reset();
                DetailedCLE.SetRange("Document No.", CLE."Document No.");
                DetailedCLE.SetRange("Posting Date", cle."Posting Date");
                if DetailedCLE.FindSet() then
                    repeat
                        DetailedCLE."Document Type" := DetailedCLE."Document Type"::Refund;
                        DetailedCLE.Modify(false);
                    until DetailedCLE.Next() = 0;

                GLE.Reset();
                GLE.SetRange("Document No.", CLE."Document No.");
                GLE.SetRange("Posting Date", CLE."Posting Date");
                if GLE.FindSet() then
                    repeat
                        GLE."Document Type" := GLE."Document Type"::Refund;
                        GLE.Modify(false);
                    until GLE.Next() = 0;

                PostedGenLn.Reset();
                PostedGenLn.SetRange("Document No.", CLE."Document No.");
                PostedGenLn.SetRange("Posting Date", CLE."Posting Date");
                if PostedGenLn.FindSet() then
                    repeat
                        PostedGenLn."Document Type" := PostedGenLn."Document Type"::Refund;
                        PostedGenLn.Modify(false);
                    until PostedGenLn.Next() = 0;

            until CLE.Next = 0;


        Message('Update of Refund in CLE done.');
    end;

    procedure ExportItemAttribute()
    var
        itemsRec: Record Item;
        str: Text;
        attributeName: Text;
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValue2: Record "Item Attribute Value";
        itemAttributeBuffer: Record "Item Attribute Line";
        itemAttribute: Record "Item Attribute";
        itemAttributeList: Page itemAttributeList;
    begin

        itemsRec.Reset();
        itemAttributeBuffer.DeleteAll();
        itemAttributeBuffer.Reset();
        if itemsRec.FindSet() then
            repeat
                //ItemAttributeValue.Reset();
                ItemAttributeValueMapping.Reset();
                ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
                ItemAttributeValueMapping.SetRange("No.", itemsRec."No.");

                if ItemAttributeValueMapping.FindSet() then
                    repeat
                        ItemAttributeValue.Reset();
                        ItemAttributeValue.SetRange("Attribute ID", ItemAttributeValueMapping."Item Attribute ID");
                        ItemAttributeValue.SetRange(ID, ItemAttributeValueMapping."Item Attribute Value ID");
                        if ItemAttributeValue.FindFirst() then begin

                            itemAttribute.Reset();
                            itemAttribute.SetRange(id, ItemAttributeValue."Attribute ID");
                            if (itemAttribute.FindFirst()) then begin
                                attributeName := itemAttribute.Name;
                            end;
                            itemAttributeBuffer.Init();
                            itemAttributeBuffer."Attribute ID" := ItemAttributeValue."Attribute ID";
                            itemAttributeBuffer.ID := ItemAttributeValue.ID;
                            itemAttributeBuffer."Item No." := itemsRec."No.";
                            itemAttributeBuffer."Attribute Name" := attributeName;
                            itemAttributeBuffer.Value := ItemAttributeValue.Value;
                            itemAttributeBuffer.Blocked := ItemAttributeValue.Blocked;
                            itemAttributeBuffer."Date Value" := ItemAttributeValue."Date Value";
                            itemAttributeBuffer."Numeric Value" := ItemAttributeValue."Numeric Value";
                            itemAttributeBuffer.Insert();
                        end
                    until ItemAttributeValueMapping.Next() = 0;

            until itemsRec.Next() = 0;
    end;

    procedure UpdateItemLicense()
    var
        GetItemLicense: Record ItemLicense;
    begin
        GetItemLicense.Reset();
        If GetItemLicense.FindSet() then
            repeat
                if GetItemLicense."License Percentage" = 0 then begin
                    GetItemLicense."License Percentage" := 1;
                    GetItemLicense.Modify();
                end;
            until GetItemLicense.Next() = 0;
    end;

    ////MBR 8/1/2024 - start
    //FixPO001274_55800 - This function is created to fix the item tracking issue for PO PO001274.  This should be ran once only
    //                    This function can be deleted in the future;
    procedure FixPO001274_55800()
    var
        TrackingSpec: Record "Tracking Specification";
        ToDt: Date;
    begin
        ToDt := DMY2Date(15, 4, 2024);
        TrackingSpec.Reset();
        TrackingSpec.Init();
        Trackingspec."Entry No." := 28807;
        TrackingSpec."Item No." := '32787';
        TrackingSpec."Location Code" := 'G_H';
        TrackingSpec."Quantity (Base)" := 55800;
        TrackingSpec."Creation Date" := ToDt;
        TrackingSpec."Source Type" := 39;
        TrackingSpec."Source Subtype" := 1;
        TrackingSpec."Source ID" := 'PO001274';
        TrackingSpec."Source Ref. No." := 20000;
        TrackingSpec."Item Ledger Entry No." := 28807;
        TrackingSpec.Positive := true;
        TrackingSpec."Qty. per Unit of Measure" := 1;
        TrackingSpec."Quantity Handled (Base)" := 55800;
        TrackingSpec."Quantity Invoiced (Base)" := 55800;
        TrackingSpec."Buffer Value1" := 55800;
        TrackingSpec."Lot No." := 'BSG240012741504B';
        TrackingSpec.Insert();

    end;
    //MBR 8/1/2024 - end

    //MBR 8/1/2024 - start
    //FixPO001274_55788 - This function is created to fix the item tracking issue for PO PO001274.  This should be ran once only
    //                    This function can be deleted in the future;
    procedure FixPO001274_55788()
    var
        TrackingSpec: Record "Tracking Specification";
        ToDt: Date;
        entryNo: Integer;
        LotNo: Text;
        qty: Decimal;
        LocCode: code[10];
    begin
        ToDt := DMY2Date(15, 4, 2024);
        entryNo := 28806;
        LotNo := 'BSG240012741504B';
        qty := 55788;
        LocCode := 'SANTA FE';

        TrackingSpec.Reset();
        TrackingSpec.Init();
        Trackingspec."Entry No." := entryNo;
        TrackingSpec."Item No." := '32787';
        TrackingSpec."Location Code" := LocCode;
        TrackingSpec."Quantity (Base)" := qty;
        TrackingSpec."Creation Date" := ToDt;
        TrackingSpec."Source Type" := 39;
        TrackingSpec."Source Subtype" := 1;
        TrackingSpec."Source ID" := 'PO001274';
        TrackingSpec."Source Ref. No." := 20000;
        TrackingSpec."Item Ledger Entry No." := entryNo;
        TrackingSpec.Positive := true;
        TrackingSpec."Qty. per Unit of Measure" := 1;
        TrackingSpec."Quantity Handled (Base)" := qty;
        TrackingSpec."Quantity Invoiced (Base)" := qty;
        TrackingSpec."Buffer Value1" := qty;
        TrackingSpec."Lot No." := LotNo;
        TrackingSpec.Insert();

    end;
    //MBR 8/1/2024 - end

    //MBR 8/1/2024 - start
    //FixPO001274_25800 - This function is created to fix the item tracking issue for PO PO001274.  This should be ran once only
    // 
    procedure FixPO001274_25800()
    var
        TrackingSpec: Record "Tracking Specification";
        ToDt: Date;
        entryNo: Integer;
        LotNo: Text;
        qty: Decimal;
        LocCode: code[10];
    begin
        ToDt := DMY2Date(15, 4, 2024);
        entryNo := 28805;
        LotNo := 'BSG240012741504B';
        qty := 25800;
        LocCode := 'G_H';

        TrackingSpec.Reset();
        TrackingSpec.Init();
        Trackingspec."Entry No." := entryNo;
        TrackingSpec."Item No." := '32787';
        TrackingSpec."Location Code" := LocCode;
        TrackingSpec."Quantity (Base)" := qty;
        TrackingSpec."Creation Date" := ToDt;
        TrackingSpec."Source Type" := 39;
        TrackingSpec."Source Subtype" := 1;
        TrackingSpec."Source ID" := 'PO001274';
        TrackingSpec."Source Ref. No." := 20000;
        TrackingSpec."Item Ledger Entry No." := entryNo;
        TrackingSpec.Positive := true;
        TrackingSpec."Qty. per Unit of Measure" := 1;
        TrackingSpec."Quantity Handled (Base)" := qty;
        TrackingSpec."Quantity Invoiced (Base)" := qty;
        TrackingSpec."Buffer Value1" := qty;
        TrackingSpec."Lot No." := LotNo;
        TrackingSpec.Insert();

    end;
    //MBR 8/1/2024 - end


    //MBR 10/8/24 - start
    //This procedure will update the IRS 1099 Amount and IRS 1099 Code in the Vendor Ledger Entries which is necessary as we didn't update
    //the IRS 1099 Code in the vendor cards until now.  Adjustments need to be done in Vendor Ledger Entries
    procedure UpdIRS1099()
    var
        VLE: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetFilter("IRS 1099 Code", '<>%1', '');
        IF Vendor.FindSet() then
            repeat
                VLE.Reset();
                VLE.SetRange("Vendor No.", Vendor."No.");
                VLE.SetRange("Document Type", VLE."Document Type"::Invoice);
                VLE.SetFilter("IRS 1099 Code", '=%1', '');
                VLE.SetRange("IRS 1099 Amount", 0);
                IF VLE.FindSet() then
                    repeat
                        VLE.CalcFields(Amount, "Remaining Amount");
                        IF VLE."Remaining Amount" = 0 then begin
                            VLE."IRS 1099 Code" := Vendor."IRS 1099 Code";
                            VLE."IRS 1099 Amount" := VLE.Amount - VLE."Remaining Amount";
                            VLE.Modify();
                        end;
                    until VLE.Next() = 0;
            until Vendor.Next() = 0;
    end;

    procedure UpdatePurchProdStatAndPOFinalizedDT()
    var
        POHdr: Record "Purchase Header";
        POLn: Record "Purchase Line";
    begin
        POHdr.RESET;

        IF POHdr.FindSet() then
            repeat
                POLn.Reset();
                POLn.SETRANGE("Document No.", POHdr."No.");
                POLn.SETRANGE("Document Type", POHdr."Document Type");
                IF POLn.FindSet() then
                    repeat
                        POLn."Production Status" := POHdr."Production Status";
                        POLn.POFinalizeDate := POHdr.POFinalizeDate;
                        POLn.MODIFY;
                    UNTIL POLn.Next() = 0;
            Until POHdr.Next() = 0;
    end;

    procedure UpdateCustomerSupplierAlias()
    var
        customer: Record Customer;
    begin
        customer.reset;
        if (customer.FindSet()) then
            repeat
                customer."Supplier Alias" := '22210';
                customer.Modify();
            until customer.Next = 0;
    end;

    Procedure UpdateItemUOMWtKg()
    var
        UOM: Record "Unit of Measure";
        ItemUOM: Record "Item Unit of Measure";
    begin
        ItemUOM.RESET;
        ItemUOM.SetRange(Code, 'M-PACK');
        ItemUOM.SetFilter(Weight, '>%1', 0);
        If ItemUOM.FindSet() then
            repeat
                UOM.Reset();
                if UOM.get('LB') then;
                if UOM."Convert Up Unit" > 0 then begin
                    ItemUOM."Weight kgs" := ItemUOM.Weight * UOM."Convert Up Unit";
                    ItemUOM.Modify();
                end;
            until ItemUOM.Next() = 0;
    end;




    Procedure UpdateSupplierAlias()
    var
        Cust: Record Customer;
    begin
        Cust.Reset();
        If Cust.FindSet() then
            repeat
                Cust."Supplier Alias" := '22210';
                Cust.Modify(false);
            Until Cust.Next() = 0;
    end;

    Procedure FixSingleBOL()

    var
        NewBOLNo: code[20];
        SalesHdr: record "Sales Header";
        MainSalesHdr: Record "Sales Header";
        //NoSeriesMgt: Codeunit NoSeriesManagement;  //old code
        NoSeries: Codeunit "No. Series";
        SalesNRecieveable: Record "Sales & Receivables Setup";
        MasterBol: Record "Master BOL";
        ToDt: Date;

    begin
        ToDt := DMY2Date(19, 11, 2024);
        if (SalesNRecieveable.FindFirst()) then;

        IF STRLEN(SalesNRecieveable."Single BOL Nos.") = 0 then
            Error('No. Series for Single BOL Nos. is NOT set up.  Please review.');

        MainSalesHdr.Reset();
        //MainSalesHdr.SetRange("Sell-to Customer No.", 'WAL-MART SAMS-1587');
        MainSalesHdr.SetRange("Document Type", MainSalesHdr."Document Type"::Order);
        //MainSalesHdr.SetRange(Flag, MainSalesHdr.Flag::Scheduled);
        //   MainSalesHdr.SetRange("APT Date", ToDt);
        IF MainSalesHdr.FindSet() then
            repeat
                //Check to ensure we have unique BOL for the same customer
                SalesHdr.Reset();
                SalesHdr.SetRange("Document Type", MainSalesHdr."Document Type");
                SalesHdr.SetRange("Sell-to Customer No.", MainSalesHdr."Sell-to Customer No.");
                SalesHdr.SetFilter("No.", '<>%1', MainSalesHdr."No.");
                SalesHdr.SetFilter("Single BOL No.", '=%1', MainSalesHdr."Single BOL No.");
                IF SalesHdr.FindFirst() then begin
                    MasterBol.Reset();
                    MasterBol.SetRange("Single BOL No.", SalesHdr."Single BOL No.");
                    if (MasterBol.FindSet() = false) then begin
                        //NewBOLNo := NoSeriesMgt.DoGetNextNo(SalesNRecieveable."Single BOL Nos.", WorkDate(), true, true);  //old code
                        NewBOLNo := NoSeries.GetNextNo(SalesNRecieveable."Single BOL Nos.");
                        SalesHdr."Single BOL No." := NewBOLNo;
                        SalesHdr.Modify();
                    end;
                end;

            until MainSalesHdr.Next() = 0;


    end;

    procedure TransToContainer()
    var
        TransferHeader: Record "Transfer Header";
        ContainerHeader: Record "Container Header";
    begin
        TransferHeader.Reset();
        if (TransferHeader.FindSet()) then
            repeat
                ContainerHeader.Reset();
                ContainerHeader.SetRange("Container No.", TransferHeader."Container No.");
                if (ContainerHeader.FindSet()) THEN begin
                    ContainerHeader."Actual Pull Time" := TransferHeader."Actual Pull Time";
                    ContainerHeader."Actual Pull Date" := TransferHeader."Actual Pull Date";
                    ContainerHeader."Container Status Notes" := TransferHeader."Container Status Notes";
                    ContainerHeader."Port of Discharge" := TransferHeader."Port of Discharge";
                    ContainerHeader."Port of Loading" := TransferHeader."Port of Loading";
                    ContainerHeader.Terminal := TransferHeader.Terminal;
                    ContainerHeader.Carrier := TransferHeader.Carrier;
                    ContainerHeader.Forwarder := TransferHeader.Forwarder;
                    ContainerHeader.LFD := TransferHeader.LFD;
                    ContainerHeader."Container Size" := TransferHeader.ContainerSize;
                    ContainerHeader.ActualETD := TransferHeader.ActualETD;
                    ContainerHeader.ActualETA := TransferHeader.ActualETA;
                    ContainerHeader."Actual Delivery Date" := TransferHeader.ActualDeliveryDate;
                    ContainerHeader.Modify();

                end;
            until TransferHeader.next = 0;
    end;

    procedure RefreshPurchLines()
    var
        ContainerLine: Record ContainerLine;
        item: Record Item;
        PurchLines: Record "Purchase Line";
    begin
        ContainerLine.Reset();
        if (ContainerLine.FindSet()) then
            repeat
                PurchLines.Reset();
                PurchLines.SetRange("Document No.", ContainerLine."Document No.");
                PurchLines.SetRange("No.", ContainerLine."Item No.");
                if (PurchLines.FindSet()) then
                    repeat
                        if ((PurchLines.bUpdate = false) and (PurchLines.AssignedToContainer = false)) then begin
                            PurchLines."Qty Assigned to Container" := ContainerLine.Quantity;
                            PurchLines."Container No." := ContainerLine."Container No.";
                            PurchLines.AssignedToContainer := true;
                            PurchLines.bUpdate := true;
                            PurchLines.Modify();
                        end
                        else if ((PurchLines.bUpdate = true) and (PurchLines.AssignedToContainer = true)) then begin
                            PurchLines."Qty Assigned to Container" := PurchLines."Qty Assigned to Container" + ContainerLine.Quantity;
                            PurchLines."Container No." := ContainerLine."Container No.";
                            PurchLines.Modify();
                        end;

                    until PurchLines.Next() = 0;

            until ContainerLine.Next() = 0;
    end;

    procedure CleanupContainerLines()
    var
        ContainerLn: record "ContainerLine";
        ContainerHdr: record "Container Header";
        PostedContainerHdr: record "Posted Container Header";
    begin
        ContainerLn.Reset();
        If ContainerLn.FindSet() then
            repeat
                ContainerHdr.Reset();
                ContainerHdr.SetRange("Container No.", ContainerLn."Container No.");
                IF NOT ContainerHdr.FindFirst() then begin
                    ContainerLn.Delete(false);
                end;
            until ContainerLn.Next = 0;
    end;

    procedure CleanupContainerorderstat()
    var
        ContainerHdr: record "Container Header";
        TransferHdr: Record "Transfer Header";
    begin
        ContainerHdr.Reset();
        ContainerHdr.SetFilter("Transfer Order No.", '<>%1', '');
        ContainerHdr.SetFilter(Status, '<>%1', ContainerHdr.Status::Completed);
        If ContainerHdr.FindSet() then
            repeat
                If ContainerHdr.Status = ContainerHdr.Status::Assigned then begin
                    TransferHdr.SetRange("No.", ContainerHdr."Transfer Order No.");
                    IF NOT TransferHdr.FindFirst() then begin
                        ContainerHdr.Status := ContainerHdr.Status::Completed;
                        ContainerHdr.Modify();
                    end;
                end;
            until ContainerHdr.Next() = 0;
    end;
    //PR 12/31/24 
    procedure UpdateTransferLineCustCode()
    var
        TransferLine: Record "Transfer Line";
        PostedTransferShipLines: Record "Transfer Shipment Line";
        PostedTransferReciptLines: Record "Transfer Receipt Line";
        custCode: code[20];
        PurLin: Record "Purchase Line";
        PRLine: Record "Purch. Rcpt. Line";
        PRLine2: Record "Purch. Rcpt. Line";

    //Posted
    begin
        TransferLine.Reset();
        //TransferLine.SetRange(CustCode, 'DOLLAR GENERAL -4785');
        if (TransferLine.FindSet()) then
            repeat
                //TransferLine.CustCode := 'DOLLAR GENERAL -DI';
                //  TransferLine."Shortcut Dimension 1 Code" := 'DOLLAR GENERAL -DI';
                // TransferLine.Modify();
                custCode := '';  //initialize
                                 //get Custcode
                PurLin.Reset();
                PurLin.SetRange("Document No.", TransferLine."PO No.");
                PurLin.SetRange(Type, PurLin.Type::Item);
                PurLin.SetRange("No.", TransferLine."Item No.");
                If PurLin.FindFirst() then begin

                    CustCode := PurLin."Shortcut Dimension 1 Code";
                end

                else begin
                    PRLine.Reset();
                    PRLine.SetRange("Order No.", TransferLine."PO No.");
                    PRLine.SetRange(Type, PRLine.Type::Item);
                    PRLine.SetRange("No.", TransferLine."Item No.");
                    IF PRLine.FindFirst() then begin

                        CustCode := PRLine."Shortcut Dimension 1 Code";
                        if CustCode = 'DOLLAR GENERAL -4785' then begin
                            //update the PRLine2
                            PRLine2.Reset();
                            PRLine2.SetRange("Order No.", TransferLine."PO No.");
                            PRLine2.SetRange("Shortcut Dimension 1 Code", custCode);
                            if PRLine2.FindSet() then
                                repeat
                                    PRLine2."Shortcut Dimension 1 Code" := 'DOLLAR GENERAL_DI';
                                    PRLine2.Modify();
                                until PRLine2.Next() = 0;
                        end
                    end;

                end;



            until TransferLine.Next() = 0;
        updateILEDimensionCode();
    end;

    procedure updateILEDimensionCode()
    var
        ILE: Record "Item Ledger Entry";
        PRLine: Record "Purch. Rcpt. Line";
    begin
        PRLine.Reset();
        PRLine.SetRange("Shortcut Dimension 1 Code", 'DOLLAR GENERAL_DI');
        PRLine.SetRange(Type, PRLine.Type::Item);
        IF PRLine.FindSet() then
            repeat
                ILE.Reset();
                ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                ILE.SetRange("Document Type", ILE."Document Type"::"Purchase Receipt");
                ILE.SetRange("Item No.", PRLine."No.");
                ILE.SetRange("Global Dimension 1 Code", 'DOLLAR GENERAL -4785');
                if (ILE.FindSet()) then
                    repeat
                        ILE."Global Dimension 1 Code" := 'DOLLAR GENERAL_DI';
                        ILE.Modify();
                    until ILE.Next() = 0;

            until PRLine.Next() = 0;
    end;

    procedure fixTypeDeptSO()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter(Dept, 'DP-*');
        SalesHeader.SetFilter(Type, 'MR-*');
        if SalesHeader.FindSet() then
            repeat
                Salesheader.Dept := CopyStr(Salesheader.Dept, 4, STRLEN(Salesheader.Dept) - 3);
                Salesheader.Type := CopyStr(Salesheader.Type, 4, STRLEN(Salesheader.Type) - 3);
                Salesheader.Modify(false);
            until SalesHeader.Next() = 0;
    end;

    procedure fixContainerLine()
    var
        ContainerLine: Record ContainerLine;
    begin
        ContainerLine.Reset();
        ContainerLine.SetRange("Container No.", 'CSNU7485140');
        ContainerLine.SetRange("Item No.", '901605');
        ContainerLine.SetRange("Document Line No.", 10000);
        ContainerLine.SetRange("Document No.", 'PO002612');

        if ContainerLine.FindFirst() then
            ContainerLine.Rename(ContainerLine."Container No.", ContainerLine.SourceNo, ContainerLine."Document No.", 20000, ContainerLine."Item No.", ContainerLine."Unit of Measure Code", ContainerLine."Buy-From Vendor No.");
        message('Update of Container Done');
    end;

    procedure CleanupAttachments()
    var
        DocumentAttachment: Record "Document Attachment";
        TenantMedia: Record "Tenant Media";
    begin

        DocumentAttachment.Reset();
        if DocumentAttachment.FindSet() then
            repeat
                DocumentAttachment.Delete(true);
            Until DocumentAttachment.Next() = 0;

        TenantMedia.Reset();
        If TenantMedia.Findset() then
            repeat
                TenantMedia.Delete(true);
            until TenantMedia.Next() = 0;
    end;

    procedure UpdateTransferLineDimCode1()
    var
        TransferLine: Record "Transfer Line";
        PurLin: Record "Purchase Line";
        PRLine: Record "Purch. Rcpt. Line";
    begin
        TransferLine.Reset();
        If TransferLine.FindSet() then
            repeat
                IF STRLEN(TransferLine.ZDELCustCode) > 0 then begin
                    TransferLine."Shortcut Dimension 1 Code" := TransferLine.ZDELCustCode;
                    TransferLine.Modify();
                end

                else begin
                    if strlen(TransferLine."PO No.") > 0 then begin
                        PurLin.Reset();
                        PurLin.SetRange("Document No.", TransferLine."PO No.");
                        PurLin.SetRange(Type, PurLin.Type::Item);
                        PurLin.SetRange("No.", TransferLine."Item No.");
                        If PurLin.FindFirst() then begin
                            TransferLine."Shortcut Dimension 1 Code" := PurLin."Shortcut Dimension 1 Code";
                            TransferLine.Modify();
                        end
                        else begin
                            PRLine.Reset();
                            PRLine.SetRange("Order No.", TransferLine."PO No.");
                            PRLine.SetRange(Type, PRLine.Type::Item);
                            PRLine.SetRange("No.", TransferLine."Item No.");
                            IF PRLine.FindFirst() then begin
                                TransferLine."Shortcut Dimension 1 Code" := PRLine."Shortcut Dimension 1 Code";
                                TransferLine.Modify();
                            end;

                        end;
                    end;
                end;
            until TransferLine.Next() = 0;

        //get Custcode


    end;

    //PR 4/16/25 - start
    procedure GetShipLabelFromCustForSO()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        Customer.Reset();
        Customer.SetFilter(ShippingLabelStyle, '<>%1', '');
        if (customer.FindSet()) then
            repeat
                SalesHeader.Reset();
                SalesHeader.SetRange("Sell-to Customer No.", Customer."No.");
                if (SalesHeader.FindSet()) then
                    repeat
                        SalesHeader.Validate(ShippingLabelStyle, Customer.ShippingLabelStyle);
                        SalesHeader.modify();
                    until SalesHeader.Next() = 0;
            until customer.Next() = 0;
    end;
    //PR 4/16/25 - end

    //mbr 4/12/25 - start
    procedure RefreshSalesByItemCashBasis()
    var
        ILE: Record "Item Ledger Entry";
        CBGLE: Record "SIMC Cash G/L Entry";
        GetCBGLE: Record "SIMC Cash G/L Entry";
        GetAmount: Decimal;
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLn: Record "Sales Invoice Line";
        // InsTmpRoyalty: Record TmpRoyalty;
        CLE: Record "Cust. Ledger Entry";
        GetDescrip: Text;
        ChkTmpRoyalty: Record TmpRoyalty;
        GetTotal: Decimal;
        totalCashPaid: Decimal;
        DetCLE: Record "Detailed Cust. Ledg. Entry";
        GetQty: Decimal;
        ChkQty: Decimal;
        Cust: Record Customer;
        chkItemCount: Integer;
        ValueEntry: Record "Value Entry";
        SalesShipmentLn: Record "Sales Shipment Line";
        bFound: Boolean;
        TmpRoyalty: Record "Cash Basis Item Sales";
        StartDate: Date;
        EndDate: Date;
        GetRoyaltySum: Record TmpRoyaltySum;
        // ChkCBGLE: Record TmpCashLE;
        TmpCashLE: Record TmpCashLE;
        EntryNo: BigInteger;
        ChkItemLicense: Record ItemLicense;
        ChkItem: Record Item;
        Item: Record Item;
        SalesNRecieve: Record "Sales & Receivables Setup";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        discountApplied: Boolean;
    begin
        TmpRoyalty.DeleteAll(); //refresh the Cash Basis Item Sales table
        GetRoyaltySum.DeleteAll();
        TmpCashLE.DeleteAll();
        //  ChkCBGLE.DeleteAll();  //not needed...to be deleted after further testing

        if SalesNRecieve.Get() then
            StartDate := SalesNRecieve.SalesByItemSummaryStartDate;

        CBGLE.Reset();
        CBGLE.SetCurrentKey("Posting Date");
        CBGLE.SetFilter("Posting Date", '>=%1', StartDate);
        CBGLE.SetRange("Applied Document Type", CBGLE."Applied Document Type"::Payment);
        CBGLE.SetRange("Document Type", CBGLE."Document Type"::"Sales Invoice");
        CBGLE.SetRange("Source Type", CBGLE."Source Type"::Customer);
        CBGLE.SetRange("G/L Account No.", '40200');
        //CBGLE.SetRange("Document No.", 'PS-INV110742');  //mbr test   
        //CBGLE.SetRange("Source No.", 'WAL-MART SAMS-1587');  //mbr test

        IF CBGLE.FindSet() then
            repeat
                TmpCashLE.Reset();
                TmpCashLE.SetRange("Posting Date", CBGLE."Posting Date");
                TmpCashLE.SetRange("Applied Document Type", TmpCashLE."Applied Document Type"::Payment);
                TmpCashLE.SetRange("Source Type", TmpCashLE."Source Type"::Customer);
                TmpCashLE.SetRange("Document Type", TmpCashLE."Document Type"::"Sales Invoice");
                TmpCashLE.SetRange("Source No.", CBGLE."Source No.");
                TmpCashLE.SetRange("Document No.", CBGLE."Document No.");
                if TmpCashLE.FindFirst() then begin
                    TmpCashLE.Amount += CBGLE.Amount;
                    TmpCashLE.Modify();
                end

                else begin
                    EntryNo += 1;
                    TmpCashLE.Init();
                    TmpCashLE."Entry No." := EntryNo;
                    TmpCashLE."Posting Date" := CBGLE."Posting Date";
                    TmpCashLE."Applied Document Type" := CBGLE."Applied Document Type";
                    TmpCashLE."Source Type" := CBGLE."Source Type";
                    TmpCashLE."Source No." := CBGLE."Source No.";
                    TmpCashLE."Document Type" := CBGLE."Document Type";
                    TmpCashLE."Document No." := CBGLE."Document No.";
                    TmpCashLE.Amount := CBGLE.Amount;
                    TmpCashLE.Insert();

                    // ChkCBGLE.Init();
                    // ChkCBGLE."Entry No." := EntryNo;
                    // ChkCBGLE."Posting Date" := CBGLE."Posting Date";
                    // ChkCBGLE."Applied Document Type" := CBGLE."Applied Document Type";
                    // ChkCBGLE."Source Type" := CBGLE."Source Type";
                    // ChkCBGLE."Source No." := CBGLE."Source No.";
                    // ChkCBGLE."Document Type" := CBGLE."Document Type";
                    // ChkCBGLE."Document No." := CBGLE."Document No.";
                    // ChkCBGLE.Amount := CBGLE.Amount;
                    // ChkCBGLE.Insert();

                end;





            until CBGLE.Next() = 0;


        TmpCashLE.Reset();
        TmpCashLE.SetCurrentKey("Posting Date", "Applied Document Type", "Source Type", "Document Type");
        TmpCashLE.SetFilter("Posting Date", '>=%1', StartDate);
        TmpCashLE.SetRange("Applied Document Type", TmpCashLE."Applied Document Type"::Payment);
        TmpCashLE.SetRange("Source Type", TmpCashLE."Source Type"::Customer);
        TmpCashLE.SetRange("Document Type", TmpCashLE."Document Type"::"Sales Invoice");



        IF TmpCashLE.FindSet() then
            repeat
                GetAmount := 0;

                GetCBGLE.Reset();
                GetCBGLE.SetCurrentKey("Posting Date", "Applied Document Type", "Source Type", "Source No.", "Document Type", "Document No.");
                GetCBGLE.SetRange("Posting Date", TmpCashLE."Posting Date");
                GetCBGLE.SetRange("Applied Document Type", GetCBGLE."Applied Document Type"::Payment);
                GetCBGLE.SetRange("Source Type", TmpCashLE."Source Type");
                GetCBGLE.SetRange("Source No.", TmpCashLE."Source No.");
                GetCBGLE.SetRange("Document Type", TmpCashLE."Document Type");
                GetCBGLE.SetRange("Document No.", TmpCashLE."Document No.");



                if GetCBGLE.FindSet() then
                    repeat
                        If GetCBGLE."Credit Amount" > 0 then
                            GetAmount := GetAmount + GetCBGLE."Credit Amount"
                        else
                            GetAmount := GetAmount - GetCBGLE."Debit Amount";
                    until GetCBGLE.Next() = 0;

                //now, let's add any early payment discount amounts which is in the CLE.  In Cash Basis LE, this is recorded in the G/L 40300 account
                //for now, add on first payment; eventually we want actual discount payment date
                //GetRoyaltySum.Reset();
                //GetRoyaltySum.SetCurrentKey(Type, CustNo, InvoiceNo);
                //GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
                //GetRoyaltySum.SetRange(CustNo, TmpCashLE."Source No.");
                //GetRoyaltySum.SetRange(InvoiceNo, TmpCashLE."Document No.");
                //if not GetRoyaltySum.FindFirst() then begin
                //7/23/25 - we will now check against DCLE to ensure Pmt Disocunt given is tied to the correct document where Entry Type = Application
                discountApplied := false;
                CLE.Reset();
                CLE.SetRange("Document No.", TmpCashLE."Document No.");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", TmpCashLE."Source No.");
                CLE.SetFilter("Pmt. Disc. Given (LCY)", '>%1', 0);
                IF CLE.FindFirst() then begin
                    DCLE.RESET;
                    DCLE.SETRANGE("Cust. Ledger Entry No.", CLE."Entry No.");
                    DCLE.SetRange("Entry Type", DCLE."Entry Type"::Application);
                    DCLE.SetRange("Customer No.", CLE."Customer No.");
                    DCLE.SetRange("Posting Date", TmpCashLE."Posting Date");
                    IF DCLE.FindSet() then
                        repeat
                            If DCLE."Remaining Pmt. Disc. Possible" = CLE."Pmt. Disc. Given (LCY)" then begin
                                GetAmount := GetAmount - CLE."Pmt. Disc. Given (LCY)";
                                discountApplied := true;  //mbr test
                            end;
                        until (DCLE.Next() = 0) or (discountApplied = true);
                end;
                //7/23/25 end - we will now check against DCLE to ensure Pmt Disocunt given is tied to the correct document where Entry Type = Application

                GetRoyaltySum.Reset();
                GetRoyaltySum.SetCurrentKey(Type, CustNo, InvoiceNo);
                GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
                GetRoyaltySum.SetRange(CustNo, TmpCashLE."Source No.");
                GetRoyaltySum.SetRange(InvoiceNo, TmpCashLE."Document No.");
                GetRoyaltySum.SetRange(DatePaid, TmpCashLE."Posting Date");    //mbr fix


                //Calculate total Invoice Amounts and store for later use
                If NOT GetRoyaltySum.FindFirst() then begin
                    GetRoyaltySum.Init();
                    GetRoyaltySum.CustNo := TmpCashLE."Source No.";
                    GetRoyaltySum.Type := 'InvoiceTotal';
                    GetRoyaltySum.CashPaidAmount := GetAmount;
                    GetRoyaltySum.InvoiceNo := TmpCashLE."Document No.";
                    GetRoyaltySum.DatePaid := TmpCashLE."Posting Date";
                    IF Cust.Get(TmpCashLE."Source No.") then begin
                        GetRoyaltySum.CustName := Cust.Name;
                        SalesInvHdr.Reset();
                        SalesInvHdr.SetCurrentKey("No.", "Sell-to Customer No.", "Order No.");
                        SalesInvHdr.SetRange("No.", GetRoyaltySum.InvoiceNo);
                        SalesInvHdr.SetRange("Sell-to Customer No.", TmpCashLE."Source No.");
                        If SalesInvHdr.FindFirst() then begin
                            GetRoyaltySum.OrderNo := SalesInvHdr."Order No.";
                            //Calculate Total Invoice amount - adjusted or not
                            if GetRoyaltySum.OrderNo <> '' then begin
                                //Now, sum up Item line total by going to Value Entries as some items may have been adjusted
                                SalesInvLn.Reset();
                                SalesInvLn.SetRange("Document No.", SalesInvHdr."No.");
                                SalesInvLn.SetFilter(Type, '=%1', SalesInvLn.Type::Item);
                                SalesInvLn.SetFilter(Quantity, '>%1', 0);
                                If SalesInvLn.FindSet() then
                                    repeat
                                        SalesShipmentLn.Reset();
                                        SalesShipmentLn.SetRange("Order No.", GetRoyaltySum.OrderNo);
                                        SalesShipmentLn.SetRange(Type, SalesShipmentLn.Type::Item);
                                        SalesShipmentLn.SetRange("No.", SalesInvLn."No.");
                                        SalesShipmentLn.SetRange("Order Line No.", SalesInvLn."Order Line No.");
                                        IF SalesShipmentLn.FindSet() then
                                            repeat
                                                ILE.Reset();
                                                ILE.SetCurrentKey("Entry No.", "Source Type", "Source No.");
                                                ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
                                                ILE.SetRange("Source Type", ILE."Source Type"::Customer);
                                                ILE.SetRange("Source No.", GetRoyaltySum.CustNo);
                                                ILE.SetRange("Sales Shipment Source No.", GetRoyaltySum.OrderNo);
                                                ILE.SetRange("Item No.", SalesShipmentLn."No.");
                                                ILE.SetRange("Document No.", SalesShipmentLn."Document No.");
                                                ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
                                                ILE.SetRange("Document Line No.", SalesShipmentLn."Line No.");

                                                IF ILE.FindSet() then
                                                    repeat
                                                        ValueEntry.Reset();
                                                        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                                                        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                                                        ValueEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");

                                                        If ValueEntry.FindSet() then
                                                            repeat
                                                                GetRoyaltySum.PaidAmount += ValueEntry."Sales Amount (Actual)";
                                                            until ValueEntry.Next() = 0;
                                                    until ILE.Next() = 0;
                                            Until SalesShipmentLn.Next() = 0

                                    until SalesInvLn.Next() = 0;


                            end
                            else begin
                                ValueEntry.Reset();
                                ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                                ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                                If ValueEntry.FindSet() then
                                    repeat
                                        GetRoyaltySum.PaidAmount += ValueEntry."Sales Amount (Actual)";
                                    until ValueEntry.Next() = 0;
                            end;
                        end;
                    end;

                    GetRoyaltySum.Insert;
                end;
            until TmpCashLE.Next() = 0;


        ChkItem.Reset();
        ChkItemLicense.RESET;




        //mbr test
        // GetRoyaltySum.reset;
        // GetRoyaltySum.SetCurrentKey(Type);
        // GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
        // GetRoyaltySum.SetFilter(OrderNo, '<>%1', '');
        // if GetRoyaltySum.FindSet() then
        //     repeat
        //         message('%1  %2', GetRoyaltySum.InvoiceNo, GetRoyaltySum.PaidAmount);
        //     until GetRoyaltySum.Next() = 0;
        //mbr test
        GetRoyaltySum.reset;
        GetRoyaltySum.SetCurrentKey(Type);
        GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
        GetRoyaltySum.SetFilter(OrderNo, '<>%1', '');
        IF GetRoyaltySum.FindSet() then
            repeat
                ILE.Reset();
                ILE.SetCurrentKey("Entry No.", "Source Type", "Source No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
                ILE.SetRange("Source Type", ILE."Source Type"::Customer);
                ILE.SetRange("Source No.", GetRoyaltySum.CustNo);
                ILE.SetRange("Sales Shipment Source No.", GetRoyaltySum.OrderNo);
                //    ILE.SetRange("Item No.", '95312');  //mbr test

                IF ILE.FindSet() then
                    repeat
                        bFound := false;
                        //check if Chkitem filter applies to ILE
                        if chkItem.FindSet then begin
                            chkItem.FindFirst();
                            repeat
                                if ChkItem."No." = ILE."Item No." then
                                    bFound := true;
                            until (ChkItem.Next() = 0) or (bFound = true);
                        end
                        else
                            bFound := true;

                        if bFound = true then begin
                            //need to check if corresponding invoice number is in Value Entry.  if not, do not include at all;
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                            ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                            ValueEntry.SetRange("Item No.", ILE."Item No.");
                            ValueEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                            ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                            If ValueEntry.FindFirst() then begin
                                chkItemCount := 0;
                                ChkItemLicense.SetRange("Item No.", ILE."Item No.");
                                IF ChkItemLicense.FindSet() then
                                    repeat
                                        chkItemCount += 1;
                                        ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                        TmpRoyalty.Reset();
                                        TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                        TmpRoyalty.SetRange(Type, 'Invoice');
                                        TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                        TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                        TmpRoyalty.SetRange(License, ChkItemLicense.License);
                                        TmpRoyalty.SetRange(SubLicense, ChkItemLicense.Sublicense);
                                        TmpRoyalty.SetRange(ItemNo, ILE."Item No.");
                                        TmpRoyalty.SetRange(DatePaid, GetRoyaltySum.DatePaid);  //mbr fix


                                        If TmpRoyalty.FindFirst() then begin
                                            TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage");
                                            TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage");
                                            TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                            TmpRoyalty.Modify(true);
                                        end
                                        else begin
                                            TmpRoyalty.Init();
                                            TmpRoyalty.Type := 'Invoice';
                                            TmpRoyalty.CustNo := ILE."Source No.";
                                            TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                            TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                            TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.ItemNo := ILE."Item No.";
                                            If Item.get(TmpRoyalty.ItemNo) then
                                                TmpRoyalty.Description := Item.Description;
                                            TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage";
                                            TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage";
                                            if TmpRoyalty.Qty > 0 then
                                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                            //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                            TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.License := ChkItemLicense.License;
                                            TmpRoyalty.SubLicense := ChkItemLicense.Sublicense;
                                            TmpRoyalty.ItemSort := 0;
                                            TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                            TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                            TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                            TmpRoyalty.Insert();
                                        end;

                                    until ChkItemLicense.Next() = 0
                                else begin
                                    chkItemCount += 1;
                                    ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                    TmpRoyalty.Reset();
                                    TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                    TmpRoyalty.SetRange(Type, 'Invoice');
                                    TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                    TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                    TmpRoyalty.SetRange(DatePaid, GetRoyaltySum.DatePaid); //mbr fix;;
                                    TmpRoyalty.SetRange(ItemNo, ILE."Item No.");



                                    If TmpRoyalty.FindFirst() then begin
                                        TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity"));
                                        TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)");
                                        TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                        TmpRoyalty.Modify(true);
                                    end
                                    else begin
                                        TmpRoyalty.Init();
                                        TmpRoyalty.Type := 'Invoice';
                                        TmpRoyalty.CustNo := ILE."Source No.";
                                        TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                        TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                        TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemNo := ILE."Item No.";
                                        If Item.get(TmpRoyalty.ItemNo) then
                                            TmpRoyalty.Description := Item.Description;
                                        TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity");
                                        TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)";
                                        if TmpRoyalty.Qty > 0 then
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                        //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                        //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) 
                                        TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                        TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemSort := 0;
                                        TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                        TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                        TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                        TmpRoyalty.License := '';
                                        TmpRoyalty.SubLicense := '';
                                        TmpRoyalty.Insert();
                                    end;

                                    //   end;


                                end;

                            end;

                        end;
                    until ILE.Next() = 0;
            until GetRoyaltySum.Next() = 0;

        //Now, let's go through Invoices where OrderNo = Blank.  This means invoice was posted directly from Sales Invoice
        GetRoyaltySum.reset;
        GetRoyaltySum.SetCurrentKey(Type);
        GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
        GetRoyaltySum.SetFilter(OrderNo, '=%1', '');
        IF GetRoyaltySum.FindSet() then
            repeat
                ValueEntry.Reset();
                ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                ValueEntry.SetRange(Adjustment, false);
                If ValueEntry.FindSet() then
                    repeat
                        ILE.Reset();
                        ILE.SetRange("Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ILE.FindFirst() then begin
                            bFound := false;
                            //check if Chkitem filter applies to ILE
                            if chkItem.FindSet then begin
                                chkItem.FindFirst();
                                repeat
                                    if ChkItem."No." = ILE."Item No." then
                                        bFound := true;
                                until (chkItem.Next() = 0) or (bFound = true);
                            end
                            else
                                bFound := true;

                            if bFound = true then begin
                                chkItemCount := 0;
                                ChkItemLicense.SetRange("Item No.", ILE."Item No.");
                                IF ChkItemLicense.FindSet() then
                                    repeat
                                        chkItemCount += 1;
                                        ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                        TmpRoyalty.Reset();
                                        TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                        TmpRoyalty.SetRange(Type, 'Invoice');
                                        TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                        TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                        TmpRoyalty.SetRange(License, ChkItemLicense.License);
                                        TmpRoyalty.SetRange(SubLicense, ChkItemLicense.Sublicense);
                                        TmpRoyalty.SetRange(ItemNo, ILE."Item No.");
                                        TmpRoyalty.SetRange(DatePaid, GetRoyaltySum.DatePaid); //mbr fix;;


                                        If TmpRoyalty.FindFirst() then begin
                                            TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage");
                                            TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage");
                                            TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                            TmpRoyalty.Modify(true);
                                        end
                                        else begin
                                            TmpRoyalty.Init();
                                            TmpRoyalty.Type := 'Invoice';
                                            TmpRoyalty.CustNo := ILE."Source No.";
                                            TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                            TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                            TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.ItemNo := ILE."Item No.";
                                            If Item.get(TmpRoyalty.ItemNo) then
                                                TmpRoyalty.Description := Item.Description;
                                            TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage";
                                            TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage";
                                            if TmpRoyalty.Qty > 0 then
                                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                            //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                            TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.License := ChkItemLicense.License;
                                            TmpRoyalty.SubLicense := ChkItemLicense.Sublicense;
                                            TmpRoyalty.ItemSort := 0;
                                            TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                            TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                            TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                            TmpRoyalty.Insert();
                                        end;

                                    until ChkItemLicense.Next() = 0
                                else begin
                                    chkItemCount += 1;
                                    ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                    TmpRoyalty.Reset();
                                    TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                    TmpRoyalty.SetRange(Type, 'Invoice');
                                    TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                    TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                    TmpRoyalty.SetRange(ItemNo, ILE."Item No.");
                                    TmpRoyalty.SetRange(DatePaid, GetRoyaltySum.DatePaid); //mbr fix;;



                                    If TmpRoyalty.FindFirst() then begin
                                        TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity"));
                                        TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)");
                                        TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                        TmpRoyalty.Modify(true);
                                    end
                                    else begin
                                        TmpRoyalty.Init();
                                        TmpRoyalty.Type := 'Invoice';
                                        TmpRoyalty.CustNo := ILE."Source No.";
                                        TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                        TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                        TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemNo := ILE."Item No.";
                                        If Item.get(TmpRoyalty.ItemNo) then
                                            TmpRoyalty.Description := Item.Description;
                                        TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity");
                                        TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)";
                                        if TmpRoyalty.Qty > 0 then
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                        //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                        //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) 
                                        TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                        TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemSort := 0;
                                        TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                        TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                        TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                        TmpRoyalty.License := '';
                                        TmpRoyalty.SubLicense := '';
                                        TmpRoyalty.CreatedBy := UserId;
                                        TmpRoyalty.CreatedDate := Today;
                                        TmpRoyalty.Insert();
                                    end;
                                end;
                            end;
                        end;
                    until ValueEntry.Next() = 0



            until GetRoyaltySum.Next() = 0;

    end;
    //mbr 4/12/25 - end

    //pr 4/28/25 - start
    procedure RefreshTOTelexReleased()
    var
        TransHdr: Record "Transfer Header";
        TransLine: Record "Transfer Line";
    begin
        TransHdr.Reset();
        if TransHdr.FindSet() then
            repeat
                TransLine.reset();
                TransLine.SetRange("Document No.", TransHdr."No.");
                TransLine.SetRange("Telex Released", false);
                if (transline.FindSet()) then begin
                    TransHdr."Telex Released" := false;
                    TransHdr.Modify();
                end;
            until TransHdr.Next() = 0;
    end;
    //pr 4/28/25 - start
    procedure BackFillEarliestStartShipDatePurchaseLines()
    var
        PurchLine: Record "Purchase Line";
        GenCU: Codeunit GeneralCU;
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);

        if PurchLine.FindSet(true) then
            repeat
                GenCU.UpdateEarliestStartShipDatePurch(PurchLine);
                PurchLine.Modify();
            until PurchLine.Next() = 0;
    end;

    procedure BackFillEarliestStartShipDateContainerLines()
    var
        ContainerLine: Record ContainerLine;
        GenCU: Codeunit GeneralCU;
    begin
        ContainerLine.Reset();

        if ContainerLine.FindSet(true) then
            repeat
                GenCU.UpdateEarliestStartShipDateContainer(ContainerLine);
                ContainerLine.Modify();
            until ContainerLine.Next() = 0;
    end;

    procedure UpdatePurchLinesAndContainerLines()
    var
        PurchLines: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ContainerLine: Record ContainerLine;
    begin
        PurchLines.Reset();
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        if (PurchLines.FindSet()) then
            repeat
                PurchLines.Calcfields(RequestedCargoReadyDate);
                PurchLines.GetCRDDif();
                PurchLines.CalcEarliestDifDate();
                PurchLines.UpdateNewItem();
                PurchLines.Modify();
            until PurchLines.Next() = 0;

        ContainerLine.Reset();
        if (ContainerLine.FindSet()) then
            repeat
                ContainerLine.CalcEarliestDifDate();
                ContainerLine.UpdateNewItem();
                ContainerLine.Modify();
            until ContainerLine.Next() = 0;
    end;

    procedure UpdateSpecificContainerLine()
    var
        ContainerLine: Record ContainerLine;
    begin


        ContainerLine.Reset();
        ContainerLine.Init();
        ContainerLine."Container No." := 'GCXU5252332';
        ContainerLine."Document Line No." := 10000;
        ContainerLine.Validate("Item No.", '88420');
        ContainerLine."Document No." := 'T03642';
        ContainerLine."Location Code" := 'OVERSEAS';
        ContainerLine."Transfer Order No." := 'T03642';
        ContainerLine.Validate(Quantity, 10008);
        ContainerLine."Unit of Measure Code" := 'EACH';
        ContainerLine."Quantity Base" := 10008;
        ContainerLine."Port of Discharge" := 'LONG BEACH';
        ContainerLine."Port of Loading" := 'SHENZHEN';
        ContainerLine."Production Status" := ContainerLine."Production Status"::Shipped;
        ContainerLine.PONoFromTO := 'PO003265';
        ContainerLine.PONo := 'PO003265';
        ContainerLine."PO Owner" := 'IVY';
        ContainerLine.POClosed := true;
        ContainerLine.TOOpen := true;
        ContainerLine.Insert();
        Message('Container line Inserted.');

    end;


    procedure FixPurchaseLineQuantityMismatches()
    var
        PurchLine: Record "Purchase Line";
        Counter: Integer;
        ActualQtyReceived: Decimal;
        ActualQtyInvoiced: Decimal;
        ActualQtyReceivedBase: Decimal;
        ActualQtyInvoicedBase: Decimal;
        MismatchesFixed: Integer;
        Item: Record Item;
    begin
        MismatchesFixed := 0;


        // Process only Purchase Orders with potential mismatches
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.SetFilter("Quantity Received", '>0'); // Only lines with received quantities

        if PurchLine.FindSet() then
            repeat
                Item.Reset();
                Item.SetRange("No.", PurchLine."No.");
                Item.SetRange(Type, Item.Type::Inventory);
                If Item.FindFirst() then begin
                    // Calculate actual quantities from posted documents
                    ActualQtyReceived := CalcActualQtyReceived(PurchLine);
                    ActualQtyInvoiced := CalcActualQtyInvoiced(PurchLine);
                    ActualQtyReceivedBase := CalcActualQtyReceivedBase(PurchLine);
                    ActualQtyInvoicedBase := CalcActualQtyInvoicedBase(PurchLine);

                    // Check if mismatch exists
                    if (PurchLine."Quantity Received" <> ActualQtyReceived) or
                       (PurchLine."Quantity Invoiced" <> ActualQtyInvoiced) or
                       (PurchLine."Qty. Received (Base)" <> ActualQtyReceivedBase) or
                       (PurchLine."Qty. Invoiced (Base)" <> ActualQtyInvoicedBase) then begin

                        // Create audit record BEFORE making changes
                        CreatePurchLineAuditRecord(PurchLine, ActualQtyReceived, ActualQtyInvoiced,
                                                 ActualQtyReceivedBase, ActualQtyInvoicedBase);

                        // Update the purchase line with correct quantities
                        UpdatePurchLineQuantities(PurchLine, ActualQtyReceived, ActualQtyInvoiced,
                                                ActualQtyReceivedBase, ActualQtyInvoicedBase);

                        MismatchesFixed += 1;
                    end;

                end;


            until PurchLine.Next() = 0;

        // Send ONE summary email at the end (only if fixes were made)
        if MismatchesFixed > 0 then begin
            SendDailySummaryEmail(MismatchesFixed);

        end;
    end;

    // Remove the call from UpdatePurchLineQuantities - keep it simple:
    local procedure UpdatePurchLineQuantities(var PurchLine: Record "Purchase Line"; NewQtyReceived: Decimal; NewQtyInvoiced: Decimal; NewQtyReceivedBase: Decimal; NewQtyInvoicedBase: Decimal)
    begin
        PurchLine."Quantity Received" := NewQtyReceived;
        PurchLine."Quantity Invoiced" := NewQtyInvoiced;
        PurchLine."Outstanding Quantity" := PurchLine.Quantity - NewQtyReceived;
        PurchLine."Qty. Received (Base)" := NewQtyReceivedBase;
        PurchLine."Qty. Invoiced (Base)" := NewQtyInvoicedBase;
        PurchLine."Outstanding Qty. (Base)" := PurchLine."Quantity (Base)" - NewQtyReceivedBase;
        PurchLine.Validate("Outstanding Amount", PurchLine."Outstanding Quantity" * PurchLine."Direct Unit Cost");



        // Update related fields
        PurchLine."Qty. to Receive" := PurchLine.Quantity - NewQtyReceived;
        PurchLine."Qty. to Invoice" := NewQtyReceived - NewQtyInvoiced;
        PurchLine."Qty. to Receive (Base)" := PurchLine."Quantity (Base)" - NewQtyReceivedBase;
        PurchLine."Qty. to Invoice (Base)" := NewQtyReceivedBase - NewQtyInvoicedBase;

        // Calculate Qty. Rcd. Not Invoiced
        PurchLine."Qty. Rcd. Not Invoiced" := NewQtyReceived - NewQtyInvoiced;

        PurchLine.Modify(true);
        // NO EMAIL CALL HERE - just do the update
    end;

    // Add this new procedure for daily summary email:
    // Replace your SendDailySummaryEmail procedure with this enhanced version:

    // Replace your SendDailySummaryEmail procedure with this enhanced version:

    // Replace the detailed email with summary-only:

    local procedure SendDailySummaryEmail(MismatchCount: Integer)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        EmailSubject: Text;
        EmailBody: Text;
        ToRecipients: List of [Text];
        PurchLineAudit: Record "Purchase Line Audit";

    begin


        // Build email subject
        EmailSubject := StrSubstNo('Daily BC Quantity Mismatch Summary - %1 Fixes Applied', MismatchCount);

        // Build email body - SUMMARY ONLY

        EmailBody := '<h2>BC Quantity Mismatch Daily Summary</h2>' +
                       '<strong>Total Fixes Applied:</strong> ' + Format(MismatchCount) + '<br>' +
                       '<strong>Date:</strong> ' + Format(Today) + '<br><br>' +
                       'Review Purchase Line Audit List for complete details.';
        // Set recipients
        ToRecipients.Add('mitarances@mb-consult.com');
        // ToRecipients.Add('mandy@ashtelstudios.com');
        // Create and send email
        EmailMessage.Create(ToRecipients, EmailSubject, EmailBody, true);
        Email.Send(EmailMessage);
    end;



    local procedure CalcActualQtyReceived(PurchLine: Record "Purchase Line"): Decimal
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TotalQty: Decimal;
    begin
        TotalQty := 0;
        PurchRcptLine.SetRange("Order No.", PurchLine."Document No.");
        PurchRcptLine.SetRange("Order Line No.", PurchLine."Line No.");
        PurchRcptLine.SetRange(Type, PurchLine.Type);
        PurchRcptLine.SetRange("No.", PurchLine."No.");

        if PurchRcptLine.FindSet() then
            repeat
                TotalQty += PurchRcptLine.Quantity;
            until PurchRcptLine.Next() = 0;

        exit(TotalQty);
    end;

    local procedure CalcActualQtyInvoiced(PurchLine: Record "Purchase Line"): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
        TotalQty: Decimal;
    begin
        TotalQty := 0;
        PurchInvLine.SetRange("Order No.", PurchLine."Document No.");
        PurchInvLine.SetRange("Order Line No.", PurchLine."Line No.");
        PurchInvLine.SetRange(Type, PurchLine.Type);
        PurchInvLine.SetRange("No.", PurchLine."No.");

        if PurchInvLine.FindSet() then
            repeat
                TotalQty += PurchInvLine.Quantity;
            until PurchInvLine.Next() = 0;

        exit(TotalQty);
    end;

    local procedure CalcActualQtyReceivedBase(PurchLine: Record "Purchase Line"): Decimal
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TotalQty: Decimal;
    begin
        TotalQty := 0;
        PurchRcptLine.SetRange("Order No.", PurchLine."Document No.");
        PurchRcptLine.SetRange("Order Line No.", PurchLine."Line No.");
        PurchRcptLine.SetRange(Type, PurchLine.Type);
        PurchRcptLine.SetRange("No.", PurchLine."No.");

        if PurchRcptLine.FindSet() then
            repeat
                TotalQty += PurchRcptLine."Quantity (Base)";
            until PurchRcptLine.Next() = 0;

        exit(TotalQty);
    end;

    local procedure CalcActualQtyInvoicedBase(PurchLine: Record "Purchase Line"): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
        TotalQty: Decimal;
    begin
        TotalQty := 0;
        PurchInvLine.SetRange("Order No.", PurchLine."Document No.");
        PurchInvLine.SetRange("Order Line No.", PurchLine."Line No.");
        PurchInvLine.SetRange(Type, PurchLine.Type);
        PurchInvLine.SetRange("No.", PurchLine."No.");

        if PurchInvLine.FindSet() then
            repeat
                TotalQty += PurchInvLine."Quantity (Base)";
            until PurchInvLine.Next() = 0;

        exit(TotalQty);
    end;


    local procedure CreatePurchLineAuditRecord(PurchLine: Record "Purchase Line"; NewQtyReceived: Decimal; NewQtyInvoiced: Decimal; NewQtyReceivedBase: Decimal; NewQtyInvoicedBase: Decimal)
    var
        PurchLineAudit: Record "Purchase Line Audit";
    begin




        PurchLineAudit.Init();

        // Copy all purchase line fields
        PurchLineAudit.TransferFields(PurchLine);

        // Store original quantities before correction
        PurchLineAudit."Orig Quantity Received" := PurchLine."Quantity Received";
        PurchLineAudit."Orig Quantity Invoiced" := PurchLine."Quantity Invoiced";
        PurchLineAudit."Orig Qty. Received (Base)" := PurchLine."Qty. Received (Base)";
        PurchLineAudit."Orig Qty. Invoiced (Base)" := PurchLine."Qty. Invoiced (Base)";
        PurchLineAudit."Orig Qty. to Receive" := PurchLine."Qty. to Receive";
        PurchLineAudit."Orig Qty. to Invoice" := PurchLine."Qty. to Invoice";
        PurchLineAudit."Orig Qty. to Receive (Base)" := PurchLine."Qty. to Receive (Base)";
        PurchLineAudit."Orig Qty. to Invoice (Base)" := PurchLine."Qty. to Invoice (Base)";

        // Set corrected quantities
        PurchLineAudit."Quantity Received" := NewQtyReceived;
        PurchLineAudit."Quantity Invoiced" := NewQtyInvoiced;
        PurchLineAudit."Qty. Received (Base)" := NewQtyReceivedBase;
        PurchLineAudit."Qty. Invoiced (Base)" := NewQtyInvoicedBase;

        // Set audit information
        PurchLineAudit."Audit Date" := CurrentDateTime;
        PurchLineAudit."Audit User ID" := UserId;
        PurchLineAudit."Audit Action" := StrSubstNo('BC 26.3 Auto-Fix: Qty Received %1→%2, Qty Invoiced %3→%4',
                                                    PurchLine."Quantity Received", NewQtyReceived,
                                                    PurchLine."Quantity Invoiced", NewQtyInvoiced);
        PurchLineAudit."Orig Entry No." := PurchLine.SystemId;

        PurchLineAudit.Insert(true);
    end;

    local procedure FixOpenCustomerLedgerEntries()
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        // Find all CLEs where:
        // Remaining Amount = 0
        // Open = true
        // Closed by Entry No. is not blank
        CLE.SetRange(Open, true);
        CLE.SetRange("Remaining Amount", 0);
        CLE.SetFilter("Closed by Entry No.", '<>%1', 0);

        if CLE.FindSet(true) then
            repeat
                // Stamp Closed at Date if not filled
                if CLE."Closed at Date" = 0D then
                    CLE."Closed at Date" := WorkDate();

                CLE.Open := false;
                CLE.Modify(true);
            until CLE.Next() = 0;
    end;

    local procedure FixSalesLineEDILineDiscount()
    var
        SalesLine: Record "Sales Line";
        TmpTable: Record "TmpTableForProcessing";
        i: Integer;
        GenCU: Codeunit GeneralCU;
        SalesHeader: Record "Sales Header";
    begin
        TmpTable.Reset();
        if TmpTable.FindSet() then
            repeat
                i := 0;
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", TmpTable.DocumentNo);
                SalesLine.SetRange("External Document No.", TmpTable.ExternalDocumentNo);
                SalesLine.SetFilter("EDI Inv Line Discount", '<>%1', 0);

                if SalesLine.FindSet() then
                    repeat
                        i += 1;
                        if i = 1 then
                            SalesLine."EDI Inv Line Discount" := TmpTable.Decimal1
                        else
                            SalesLine."EDI Inv Line Discount" := TmpTable.Decimal2;
                        SalesLine.Modify(true);
                    until SalesLine.Next() = 0;
                //Update Sales Line Unit Price for G/L Account EDI Types
                SalesHeader.Reset();
                if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                    GenCU.ReCalcEDI(SalesHeader, false);
            until TmpTable.Next() = 0;
    end;

    //10/30/25 - start
    local procedure ManualFixWhseItemJournals()
    var
        WhseEntry: Record "Warehouse Entry";
        ILE: Record "Item Ledger Entry";
    begin
        WhseEntry.Reset();
        WhseEntry.SetRange("Lot No.", '');
        WhseEntry.SetRange("Item No.", '88192-NO LOT');
        if WhseEntry.FindSet() then
            repeat
                WhseEntry.Validate("Lot No.", 'TEMP_NO_LOT_FIX');
                WhseEntry.Modify(true);
            // Commit();
            until WhseEntry.Next() = 0;
        ILE.Reset();
        ILE.SetRange("Item No.", '88192-NO LOT');
        ILE.SetRange("Lot No.", '');
        if ILE.FindSet() then
            repeat
                ILE."Lot No." := 'TEMP_NO_LOT_FIX';
                ILE.Modify(true);
            until ILE.Next() = 0;
        //  Commit();
    end;
    //10/30/25 - end

}
