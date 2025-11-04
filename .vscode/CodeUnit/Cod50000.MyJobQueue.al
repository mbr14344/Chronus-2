codeunit 50000 MyJobQueue
{
    // pr 12/1/23 code for job queue from Nutraza
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Cust. Ledger Entry" = RIMD, tabledata "Vendor Ledger Entry" = RIMD,
    tabledata "G/L Entry" = RIMD, tabledata "Bank Account Ledger Entry" = RIMD,
    tabledata "Detailed Cust. Ledg. Entry" = RIMD, tabledata "Detailed Vendor Ledg. Entry" = RIMD,
    tabledata "Posted Gen. Journal Line" = RIMD, tabledata "Value Entry" = RIMD, tabledata "Sales Invoice Header" = RIMD,
    tabledata "Purch. Rcpt. Header" = RIMD, tabledata "Purch. Inv. Header" = RIMD,
    tabledata "Purch. Cr. Memo Line" = RIMD, tabledata "Purch. Inv. Line" = RIMD, tabledata "Posted Whse. Receipt Line" = RIMD,
    tabledata "Incoming Document" = RIMD, tabledata "Sales Cr.Memo Header" = RIMD;


    trigger OnRun()
    begin
        If Rec."Parameter String" = 'UpdPostingPeriod' then
            UpdPostingPeriod()
        else
            if rec."Parameter String" = 'AdjCostItems' then
                AdjCostItems()
            else
                if rec."Parameter String" = 'VLEUpdateOpenIfRemGrtrThanZero' then
                    VLEUpdateOpenIfRemGrtrThanZero()
                else
                    if rec."Parameter String" = 'CLEUpdateOpenIfRemGrtrThanZero' then
                        CLEUpdateOpenIfRemGrtrThanZero()
                    else
                        if rec."Parameter String" = 'SendInvEventPlanDaily' then
                            SendInvEventPlan(1)
                        else
                            if rec."Parameter String" = 'SendInvEventPlanWeekly' then
                                SendInvEventPlan(2)
                            else
                                if rec."Parameter String" = 'SendAPtoGL' then
                                    SendAPtoGL()
                                else
                                    if rec."Parameter String" = 'ImportPackaginInfo' then
                                        ImportPackaginInfo()
                                    else
                                        if rec."Parameter String" = 'AutoEmailSODCBreakdown' then
                                            AutoEmailSODCBreakdown()
                                        else
                                            if rec."Parameter String" = 'RunCashBasisItemSales' then
                                                RunCashBasisItemSales()
                                            else
                                                if rec."Parameter String" = 'SendFDANotice' then
                                                    SendFDANotice()
                                                else
                                                    if rec."Parameter String" = 'SendFDAReleaseNotice' then
                                                        SendFDAReleaseNotice();





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
                    UserSetup."Allow Posting From" := CalcDate('-2W', TODAY);
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

    procedure FixOpeningControlBals()
    var

        GLE: Record "G/L Entry";
        GLEChk: Record "G/L Entry";
        FromDt: Date;
        ToDt: Date;
    begin

        // FromDt := DMY2Date(1, 1, 2024);
        ToDt := DMY2Date(1, 3, 2024);
        // message('Daterange is %1-%2 ' + FORMAT(FromDt), Format(ToDt));

        GLE.Reset();
        GLE.SetFilter("Posting Date", '<%1', ToDt);
        // GLE.SetRange("User ID", 'ANISH');
        GLE.SetRange("G/L Account No.", '99999');
        GLE.SetFilter("Document No.", '<>G*');
        // GLE.SetFilter(GLE."Document No.", '%1|%2', '110577', '110583');
        IF GLE.FindSet() then
            repeat
                GLE.Validate("G/L Account No.", '50410');
                GLE.Modify(false);

            Until GLE.Next() = 0;


        Message('Opening Control Fix Done.');
    end;

    procedure MoveBadDebtsTo2023()
    var
        ToDt: Date;
        CLE: Record "Cust. Ledger Entry";
        IncDoc: Record "Incoming Document";
        SalesCrMemo: Record "Sales Cr.Memo Header";
        GLE: Record "G/L Entry";
        ToTm: Time;
        DetlCLE: Record "Detailed Cust. Ledg. Entry";
    begin
        ToDt := DMY2Date(31, 12, 2023);
        ToTm := Time;
        CLE.Reset();
        CLE.SETFILTER("Document No.", 'PS-CR104324|PS-CR104646|PS-CR104645|PS-CR104644|PS-CR104643|PS-CR104642|PS-CR104641|PS-CR104640|PS-CR104639|PS-CR104638|PS-CR104637|PS-CR104340|PS-CR104339|PS-CR104338|PS-CR104421|PS-CR104381|PS-CR104348|PS-CR104352|PS-CR104387|PS-CR104399|PS-CR104354|PS-CR104675|PS-CR104674|PS-CR104355|PS-CR104667|PS-CR104673|PS-CR104672|PS-CR104359|PS-CR104357|PS-CR104435|PS-CR104746|PS-CR104745');

        ;
        IF CLE.FindSet() then
            repeat
                IncDoc.Reset();
                IncDoc.SetRange("Document No.", CLE."Document No.");
                IncDoc.SetRange("Document Type", CLE."Document Type");
                IF IncDoc.FindSet() then
                    repeat
                        IncDoc."Posting Date" := ToDt;
                        IncDoc."Posted Date-Time" := CreateDateTime(ToDt, ToTm);
                        IncDoc."Document Date" := ToDt;
                        IncDoc.Modify();
                    until IncDoc.Next() = 0;

                SalesCrMemo.Reset();
                SalesCrMemo.SetRange("No.", CLE."Document No.");
                If SalesCrMemo.FindFirst() then begin
                    SalesCrMemo."Posting Date" := ToDt;
                    SalesCrMemo."Document Date" := ToDt;
                    SalesCrMemo.Modify();
                end;

                GLE.Reset();
                GLE.SetRange("Document No.", CLE."Document No.");
                GLE.SetRange("Document Type", CLE."Document Type");
                IF GLE.FindSet() then
                    repeat
                        GLE."Posting Date" := ToDt;
                        GLE."Document Date" := ToDt;
                        GLE.Modify();
                    until GLE.Next() = 0;

                DetlCLE.Reset();
                DetlCLE.SetRange("Document No.", CLE."Document No.");
                DetlCLE.SetRange("Document Type", CLE."Document Type");
                IF DetlCLE.FindSet() then
                    repeat
                        DetlCLE."Posting Date" := ToDt;
                        DetlCLE."Initial Entry Due Date" := ToDt;
                        DetlCLE.Modify();
                    until DetlCLE.Next() = 0;

                CLE."Posting Date" := ToDt;
                CLE."Document Date" := ToDt;
                CLE."Due Date" := ToDt;
                CLE.Modify();
            until CLE.Next() = 0;


    end;

    procedure MoveBoleCommTo2023()
    var
        ToDt: Date;
        VLE: Record "Vendor Ledger Entry";
        PurchInvHdr: Record "Purch. Inv. Header";
        SalesCrMemo: Record "Sales Cr.Memo Header";
        GLE: Record "G/L Entry";
        DetlVLE: Record "Detailed Vendor Ledg. Entry";
    begin
        ToDt := DMY2Date(31, 12, 2023);
        VLE.Reset();
        VLE.SetRange("Document No.", '110537');

        IF VLE.FindSet() then
            repeat
                PurchInvHdr.Reset();
                PurchInvHdr.SetRange("No.", VLE."Document No.");
                IF PurchInvHdr.FindSet() then
                    repeat
                        PurchInvHdr."Posting Date" := ToDt;
                        PurchInvHdr."Document Date" := ToDt;
                        PurchInvHdr."Order Date" := ToDt;
                        PurchInvHdr."Due Date" := ToDt;
                        PurchInvHdr.Modify();
                    until PurchInvHdr.Next() = 0;

                SalesCrMemo.Reset();
                SalesCrMemo.SetRange("No.", VLE."Document No.");
                If SalesCrMemo.FindFirst() then begin
                    SalesCrMemo."Posting Date" := ToDt;
                    SalesCrMemo."Document Date" := ToDt;
                    SalesCrMemo.Modify();
                end;

                GLE.Reset();
                GLE.SetRange("Document No.", VLE."Document No.");
                GLE.SetRange("Document Type", VLE."Document Type");
                IF GLE.FindSet() then
                    repeat
                        GLE."Posting Date" := ToDt;
                        GLE."Document Date" := ToDt;
                        GLE.Modify();
                    until GLE.Next() = 0;

                DetlVLE.Reset();
                DetlVLE.SetRange("Document No.", VLE."Document No.");
                DetlVLE.SetRange("Document Type", VLE."Document Type");
                IF DetlVLE.FindSet() then
                    repeat
                        DetlVLE."Posting Date" := ToDt;
                        DetlVLE."Initial Entry Due Date" := ToDt;
                        DetlVLE.Modify();
                    until DetlVLE.Next() = 0;

                VLE."Posting Date" := ToDt;
                VLE."Document Date" := ToDt;
                VLE."Due Date" := ToDt;
                VLE.Modify();
            until VLE.Next() = 0;


    end;

    procedure VLEUpdateOpenIfRemGrtrThanZero()
    var
        VLE: Record "Vendor Ledger Entry";
        RecCnt: Integer;
    begin
        VLE.Reset();
        VLE.SetFilter("Remaining Amount", '<>%1', 0);
        VLE.SetRange(Open, false);
        RecCnt := 0;

        IF VLE.FindSet() then
            repeat
                VLE.Open := true;
                VLE.Modify();
                RecCnt += 1;
            until VLE.Next() = 0;

        //  Message('VLE: There are %1 transactions that have remaining amount <> 0 and Open = NO.', RecCnt);
    end;

    procedure CLEUpdateOpenIfRemGrtrThanZero()
    var
        CLE: Record "Cust. Ledger Entry";
        RecCnt: Integer;
    begin
        CLE.Reset();
        CLE.SetFilter("Remaining Amount", '<>%1', 0);
        CLE.SetRange(Open, false);
        RecCnt := 0;

        IF CLE.FindSet() then
            repeat
                CLE.Open := true;
                CLE.Modify();
                RecCnt += 1;
            until CLE.Next() = 0;

        //Message('CLE: There are %1 transactions that have remaining amount <> 0 and Open = NO.', RecCnt);
    end;

    procedure SendInvEventPlan(Mode: Integer)
    var
        GenCU: Codeunit GeneralCU;
        curDate: Date;
    begin
        curDate := CalcDate('-CM', Today());
        GenCU.AutoEmailInventoryPlanReport(curDate, Mode);
    end;


    procedure SendAPtoGL()
    var
        GenCU: Codeunit GeneralCU;
    begin
        GenCU.AutoEmailAPToGL();
    end;
    // 7/25/25 - start
    procedure SendFDANotice()
    var
        GenCU: Codeunit GeneralCU;
    begin
        GenCU.AutoEmailFDA(true);
    end;

    procedure SendFDAReleaseNotice()
    var
        GenCU: Codeunit GeneralCU;
    begin
        GenCU.AutoEmailFDA(false);
    end;
    //7/25/25 - end

    procedure ImportPackaginInfo()
    var
        xmlCU: Codeunit XMLCU;
    begin
        xmlCU.ImportFromFTP_Async();
    end;

    procedure AutoEmailSODCBreakdown()
    var
        GenCU: Codeunit GeneralCU;
    begin
        GenCU.AutoEmailSODCBreakdown();
    end;

    procedure RunCashBasisItemSales()
    var
        AdminCU: Codeunit AdminCU;
    begin
        AdminCU.RefreshSalesByItemCashBasis();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Log Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterJobQueueLogInsert(var Rec: Record "Job Queue Log Entry")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recipients: List of [Text];
        Body: Text;
    begin
        if Rec.Status = Rec.Status::Error then begin
            Recipients.Add('mitarances@mb-consult.com'); // Set your recipient

            Body := StrSubstNo(
                'Job Queue Log Entry "%1" (%2) failed.%43rror: %4',
                Format(Rec."Entry No."),
                Rec.Description,
                Rec.CurrentCompany,
                '\n\n',
                Rec."Error Message"
            );

            EmailMessage.Create(Recipients, 'Business Central Job Queue Failure', Body, False);
            Email.Send(EmailMessage);
        end;
    end;
}