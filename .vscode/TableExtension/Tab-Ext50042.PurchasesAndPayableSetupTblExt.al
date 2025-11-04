tableextension 50042 PurchasesAndPayableSetupTblExt extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; APToGLEmailBody; Text[500])
        {
            Caption = 'AP to GL Email Body';
        }
        field(50001; APToGLEmailSubject; Text[200])
        {
            Caption = 'AP to GL Email Subject';
        }
        field(50002; "Purchasing Code Check"; code[10])
        {
            TableRelation = Purchasing;
        }
        field(50003; "Purchasing Code Default"; code[10])
        {
            // TableRelation = Purchasing;
        }

    }
}
