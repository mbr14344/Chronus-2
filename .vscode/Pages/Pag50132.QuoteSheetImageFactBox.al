page 50132 "QuoteSheetImageFactBox"
{
    PageType = CardPart;
    SourceTable = "QuoteSheet";
    ApplicationArea = All;
    Caption = 'Picture';

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = All;
                ShowCaption = false;

                // Allows clicking the image (the assist-edit button / pencil icon)
                trigger OnAssistEdit()
                var
                    InStr: InStream;
                    FileName: Text;
                begin
                    if UploadIntoStream('Select image', '', 'Image files (*.png;*.jpg;*.jpeg)|*.png;*.jpg;*.jpeg', FileName, InStr) then begin
                        Clear(Rec.Picture);
                        Rec.Picture.ImportStream(InStr, FileName);
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                Caption = 'Upload picture';
                Image = Import;
                ApplicationArea = All;

                trigger OnAction()
                var
                    InStr: InStream;
                    FileName: Text;
                begin
                    if UploadIntoStream('Select image', '', 'Image files (*.png;*.jpg;*.jpeg)|*.png;*.jpg;*.jpeg', FileName, InStr) then begin
                        Clear(Rec.Picture);
                        Rec.Picture.ImportStream(InStr, FileName);
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(ClearPicture)
            {
                Caption = 'Clear picture';
                Image = Delete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Rec.Picture.Clear();
                    Clear(Rec.Picture);
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
