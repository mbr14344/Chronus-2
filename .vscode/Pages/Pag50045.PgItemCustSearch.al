page 50045 PgItemCustSearch
{
    ApplicationArea = All;
    Caption = 'PgItemCustSearch';
    PageType = StandardDialog;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
            }
        }
    }
}
