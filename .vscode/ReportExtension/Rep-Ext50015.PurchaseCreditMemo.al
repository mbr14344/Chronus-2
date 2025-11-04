reportextension 50015 PurchaseCreditMemo extends "Purchase Credit Memo NA"
{
    RDLCLayout = './.vscode/ReportLayout/PurchaseCreditMemoNA.rdl';

    dataset
    {
        add(PageLoop)
        {

            column(CompanyPicture; CompanyInfoPicture.Picture)
            { }

        }



    }

    var
        CompanyInfoPicture: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfoPicture.Get;
        CompanyInfoPicture.CalcFields(Picture);
    end;

}
