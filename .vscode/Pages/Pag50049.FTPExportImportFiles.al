page 50049 "FTP Exported/Imported Files"
{
    ApplicationArea = All;
    Caption = 'FTP Exported/Imported Files';
    PageType = List;
    SourceTable = FTPStoreFile;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    SourceTableView = sorting("Entry No.") order(descending);



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("File Content"; Rec."File Content")
                {
                    ToolTip = 'This is the File Content stored in a BLOB data type.  Click onto this to view Document.';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileManagement: Codeunit "File Management";
                        InStr: InStream;
                        FileName: Text;
                    begin

                        if Rec."File Content".HasValue() then begin
                            FileName := Rec."File Name";
                            Rec.CalcFields("File Content");
                            Rec."File Content".CreateInStream(InStr);
                            File.DownloadFromStream(InStr, 'Download XML Export', '',
                                                 FileManagement.GetToFilterText('', FileName),
                                                 FileName);

                        end;


                    end;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = All;
                }
                field(FileType; Rec.FileType)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var

                        SalesOrder: Page "Sales Order";
                        SalesHdr: Record "Sales Header";
                    begin
                        SalesHdr.Reset();
                        SalesHdr.SetRange("No.", Rec."Document No.");
                        SalesHdr.SetRange("Document Type", SalesHdr."Document Type"::Order);
                        IF SalesHdr.FindFirst() then begin
                            Clear(SalesOrder);
                            SalesOrder.SetTableView(SalesHdr);
                            SalesOrder.Run();
                        end;
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field(CustomerNo; Rec.CustomerNo)
                {

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(ExternalDocumentNo; Rec.ExternalDocumentNo)
                {

                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field(RecordedDateTime; Rec.RecordedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date/Time document was sent or imported';
                }


            }


            part(PackingInformationLine; CartonInformationImportLines)
            {
                Caption = 'Package Information Imported Lines';
                ApplicationArea = Basic, Suite;
                Editable = false;
                SubPageLink = "From Entry No." = field("Entry No.");

            }
        }




    }





    actions
    {
        area(Processing)
        {
            action(ProcessImport)
            {
                ApplicationArea = All;
                Caption = 'Process Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    rec1: Record FTPStoreFile;
                    popupConfirm: Page "Confirmation Dialog";
                    CartonInfoImport: Record CartonInformationImport;
                    CartonInfo: Record CartonInformation;
                    SalesLine: Record "Sales Line";
                    j: Integer;
                begin
                    Clear(popupConfirm);
                    popupConfirm.setMessage(txtConfirmation);
                    Commit;
                    if popupConfirm.RunModal() = Action::yes then begin
                        If rec.Count >= 1 then begin
                            CurrPage.SetSelectionFilter(rec1);
                            if rec1.findset then begin
                                j := 0;
                                repeat
                                    if rec1.Direction <> rec1.Direction::Import then
                                        Error(txtErrDirection);
                                until rec1.Next() = 0;
                                rec1.FindFirst();
                                repeat
                                    CartonInfoImport.Reset();
                                    CartonInfoImport.SetRange("From Entry No.", rec1."Entry No.");
                                    If not CartonInfoImport.FindSet() then
                                        Error(StrSubstNo(txtNoEntryFound, rec1."Document No.", rec1.CustomerNo))
                                    else begin
                                        CartonInfo.Reset();
                                        CartonInfo.SetRange("Document No.", rec1."Document No.");
                                        CartonInfo.SetRange("Document Type", CartonInfo."Document Type"::Order);

                                        If CartonInfo.FindSet() then
                                            CartonInfo.DeleteAll();
                                        repeat
                                            CartonInfo.Init();
                                            CartonInfo."Document No." := CartonInfoImport."Document No.";
                                            CartonInfo."Document Type" := CartonInfoImport."Document Type"::Order;


                                            CartonInfo."Item No." := CartonInfoImport."Item No.";

                                            CartonInfo."Serial No." := CartonInfoImport."Serial No.";

                                            CartonInfo."DocumentLine No." := CartonInfoImport."DocumentLine No.";

                                            CartonInfo."Unit of Measure Code" := CartonInfoImport."Unit of Measure Code";
                                            CartonInfo.Weight := CartonInfoImport.Weight;
                                            CartonInfo.Validate(ShippingLabelStyle, CartonInfoImport.ShippingLabelStyle);

                                            SalesLine.Reset();
                                            SalesLine.SetRange("Document No.", CartonInfoImport."Document No.");
                                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                            SalesLine.SetRange(Type, SalesLine.Type::Item);
                                            SalesLine.SetRange("No.", CartonInfoImport."Item No.");
                                            SalesLine.SetRange("Line No.", CartonInfoImport."DocumentLine No.");
                                            IF SalesLine.FindFirst() then begin
                                                SalesLine.CalcFields("M-Pack Qty", "Reserved Qty. (Base)", "M-Pack Weight");
                                                CartonInfo."Package Quantity" := SalesLine."M-Pack Qty";
                                                CartonInfo."Item Reserved Quantity" := SalesLine."Reserved Qty. (Base)";
                                                // CartonInfo.Weight := SalesLine."M-Pack Weight";  -- no need as we are receiving this from sender now

                                            end;
                                            CartonInfo.ImportedPackagedQuantity := CartonInfoImport.ImportedPackagedQuantity;
                                            CartonInfo.Imported := true;
                                            CartonInfo."Reserved Quantity" := 1;
                                            j += 1;
                                            CartonInfo.LineCount := j;

                                            CartonInfo.Insert();
                                        until CartonInfoImport.Next() = 0;
                                    end;
                                until rec1.Next() = 0;

                            end;


                            Message(txtExportDone);
                        end;

                    end;
                end;
            }



        }

    }
    var
        txtConfirmation: label 'Are you sure you want to process the import for selected sales order(s)?';
        txtExportDone: Label 'Import Reprocessing Completed!';
        txtErrDirection: Label 'Incorrect direction value for one or more selected documents.  Only Direction = Import can be processed.';
        txtNoEntryFound: Label 'No Packing Information found for Document No. %1 Customer %2.';
}



