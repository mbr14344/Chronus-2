reportextension 50127 Vendor1099InfoExt extends "Vendor 1099 Information"
{
    RDLCLayout = './.vscode/ReportLayout/Vendor1099InformationMod.rdl';


    dataset
    {
        add(Vendor)
        {
            column(Address; Vendor.Address)
            {

            }
            column(City; Vendor.City)
            {

            }
            Column(County; County)
            {

            }
            Column(Post_Code; "Post Code")
            {

            }
            Column(Federal_ID_No_; "Federal ID No.")
            {

            }


        }
    }



}




