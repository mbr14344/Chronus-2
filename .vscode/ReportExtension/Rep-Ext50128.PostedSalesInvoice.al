reportextension 50128 PostedSalesInvoice extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Header)
        {
            column(Dept; Header.Dept)
            {

            }
            column(Type; Header.Type)
            {

            }
            column(ShipToCode; Header.GetEDIShipToCode())
            {

            }



        }

    }


    rendering
    {
        layout(CustomWordLayout)
        {
            Type = Word;
            Caption = 'Mod Standard Sales Invoice (Word)';
            LayoutFile = './WordReportLayout/Mod Standard Sales Invoice (Word).docx';
            Summary = 'Mod Standard Sales Invoice (Word)';
        }
    }




}
