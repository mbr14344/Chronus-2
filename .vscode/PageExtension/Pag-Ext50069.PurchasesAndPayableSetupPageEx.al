pageextension 50069 PurchasesAndPayableSetupPageEx extends "Purchases & Payables Setup"
{
    layout
    {
        addafter(General)
        {
            group(Email)
            {
                Caption = 'E-mail';
                group(APToGL)
                {
                    Caption = 'AP to GL';
                    field(APToGLEmailSubject; Rec.APToGLEmailSubject)
                    {
                        ApplicationArea = All;
                    }
                    field(APToGLEmailBody; Rec.APToGLEmailBody)
                    {

                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field("Purchasing Code Check"; Rec."Purchasing Code Check")
                    {
                        ApplicationArea = All;
                    }
                    field("Purchasing Code Default"; Rec."Purchasing Code Default")
                    {
                        ApplicationArea = All;
                    }
                }

            }
        }


    }
}
