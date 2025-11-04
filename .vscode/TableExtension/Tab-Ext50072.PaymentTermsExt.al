tableextension 50072 PaymentTermsExt extends "Payment Terms"
{
    fields
    {
        modify("Discount %")
        {
            trigger OnBeforeValidate()
            var
                SalesNRecieveSetup: Record "Sales & Receivables Setup";
            begin
                SalesNRecieveSetup.reset;
                if (SalesNRecieveSetup.FindSet()) then begin
                    if ("Discount %" > SalesNRecieveSetup."Payment Discount % Cap") then
                        Error(txtDiscountErr, Format(SalesNRecieveSetup."Payment Discount % Cap"));
                end;
            end;
        }
    }
    var
        txtDiscountErr: Label 'Discount cannot be > %1';

}
