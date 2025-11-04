page 50035 "Select Transfer To"
{
    ApplicationArea = All;
    Caption = 'Select Transfer-To Code';
    PageType = List;
    SourceTable = location;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name or address of the location.';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ChangeNow)
            {
                ApplicationArea = All;
                Caption = 'Change Now', comment = 'NLB="Change Transfer-to Code Location"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TransferOrder;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                    TransferLine: Record "Transfer Line";
                    Loc: Record Location;
                begin
                    Loc.Reset();

                    CurrPage.SetSelectionFilter(Loc);
                    if Loc.FindSet() then
                        if Loc.Count > 1 then
                            Error(txtLocCount, DocumentNo);


                    if Not TransferHeader.get(DocumentNo) then
                        ERROR(txtTONonExistent, DocumentNo);
                    //if at least one transfer line has been received, error out.
                    TransferLine.Reset;
                    TransferLine.SetRange("Document No.", TransferHeader."No.");
                    TransferLine.SetFilter("Quantity Received", '>%1', 0);
                    If TransferLine.FindSet() then
                        ERROR(txtQtyReceived, DocumentNo);

                    //otherwise, we can proceed with the change of transfer-to Code
                    GenCU.UpdateTransferToCode(DocumentNo, Loc.Code);
                    Message(txtSuccessTransferTo, DocumentNo, Loc.Code);
                    CurrPage.Close();
                end;
            }
        }

    }
    var
        DocumentNo: Code[20];
        txtTONonExistent: Label 'Transfer Order %1 NOT FOUND!';
        txtQtyReceived: Label 'Transfer Order %1 has 1 or more transfer lines with Quantity Received > 0.  You can no longer change the Transfer-to Code.  Please complete the receipt process for this Transfer Order and create a new Transfer Order for your new Transfer Destination.';
        txtLocCount: Label 'Please select only 1 Transfer-To Code to replace in Transfer Order No. %1';
        GenCU: Codeunit GeneralCU;
        txtSuccessTransferTo: Label 'Transfer Order %1 Transfer-To Code was successfully replaced with %2.';

    procedure SetTransferTo(InDocumentNo: Code[20])
    begin
        DocumentNo := InDocumentNo;
    end;
}
