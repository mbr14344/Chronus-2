codeunit 50010 InvValToBSReconcile
{
    procedure RunReconciliation(AsOfDate: Date)
    var
        InvRec: Record InventoryReconciliationLedger;
        GLE: record "G/L Entry";
        ValEntry: Record "Value Entry";
        GLESum: Decimal;
        ValSum: Decimal;
        Item: Record Item;

    begin

        //1. Clear Reconciliation Records
        InvRec.SETRANGE("As of Date", AsOfDate);
        IF InvRec.FindSet THEN
            InvRec.DeleteAll();

        // 2. Seeed from G/l 10700
        GLESum := 0;
        GLE.Reset;
        GLE.SetRange("G/L Account No.", '10700');
        GLE.SetFilter("Posting Date", '<=%1', AsOfDate);

        IF GLE.FindSet() then
            repeat

                InvRec.Init();
                InvRec."As of Date" := AsOfDate;
                InvRec."Run By User ID" := UserId;
                InvRec."Run DateTime" := CurrentDateTime;
                InvRec."Source Code" := GLE."Source Code";
                InvRec.SourceDescription := GLE.Description;
                InvRec."Item No." := '';  //leave blank for now
                InvRec.GLValue := GLE.Amount;
                GLESum += GLE.Amount;   //this will give us the total on BS
                InvRec."GL Entry No." := GLE."Entry No.";
                InvRec."Rec ID" := 0; // Set Rec ID to 0 for now
                InvRec.Insert();

            until GLE.Next() = 0;

        //3. seed from Value Entry (Inventory Valuation)
        ValSum := 0;
        ValEntry.Reset();
        ValEntry.SetFilter("Posting Date", '<=%1', AsOfDate);
        If ValEntry.FindSet() then
            repeat
                Item.Reset();
                Item.SetRange("No.", ValEntry."Item No.");
                Item.SetRange(Type, Item.Type::Inventory);
                If Item.FindFirst() then begin
                    InvRec.Init();
                    InvRec."As of Date" := AsOfDate;
                    InvRec."Run By User ID" := UserId;
                    InvRec."Run DateTime" := CurrentDateTime;
                    InvRec."Item No." := ValEntry."Item No.";
                    InvRec.Valuation := ValEntry."Cost Amount (Actual)" + ValEntry."Cost Amount (Expected)";     //ValEntry."Valued Quantity" * ValEntry."Cost per Unit";
                    ValSum += InvRec.Valuation;
                    InvRec."Rec ID" := 0; // Set Rec ID to 0 for now

                    InvRec.Insert();
                end;

            until ValEntry.Next() = 0;

        // 4) Summarize & compare
        InvRec.Init();
        InvRec."As of Date" := AsOfDate;
        InvRec."Run By User ID" := UserId;
        InvRec."Run DateTime" := CurrentDateTime;
        InvRec."Item No." := '*TOTAL*';
        InvRec.GLValue := GLESum;
        InvRec."Valuation" := ValSum;
        ;
        Invrec.Delta := GLESum - ValSum;
        If InvRec.Delta = 0 then
            InvRec.Status := 'Matched'
        else
            InvRec.Status := 'Mismatch';
        InvRec.StatusDetails := 'GLE vs. Valuation';
        InvRec."Rec ID" := 0; // Set Rec ID to 0 for now

        Invrec.Insert();


    end;


}
