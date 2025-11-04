page 50123 FreeStyleCheck
{

    Caption = 'Free Style Check';
    PageType = NavigatePage;
    SourceTable = TmpTable;
    SourceTableTemporary = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Adress field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Postal Code"; Rec.PostalCode)
                {
                    ToolTip = 'Specifies the value of the PostalCode field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                InFooterBar = true;

                trigger OnAction()
                begin
                    description := 'Pay to: ' + Rec.Name + ', ' + Rec.Address + ', ' + Rec.City + ', ' + Rec.State + ', ' + Rec.PostalCode;
                    if (StrLen(description) > 250) then begin
                        description := description.Substring(1, 247);
                        description := description + '...';
                    end;
                    clear(FreeStyleCheckReport);
                    GenJournalLineRef.Reset();
                    GenJournalLineRef.SetFilter("Journal Template Name", GenJournalLine."Journal Template Name");
                    GenJournalLineRef.SetFilter("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    if (GenJournalLineRef.FindSet()) then begin
                        //GenJournalLineRef.Comment := description;
                        FreeStyleCheckReport.SetTableView(GenJournalLineRef);
                        FreeStyleCheckReport.SetVoidGenJnlLine(GenJournalLineRef);
                        FreeStyleCheckReport.SetDescription(description);
                        FreeStyleCheckReport.SetTmpTable(Rec);
                        FreeStyleCheckReport.RunModal();
                        CurrPage.Close();

                    end;


                end;
            }
        }
    }
    trigger OnInit()
    begin
        description := '';
        Rec.DeleteAll();
        Rec.Init();
        Rec."Entry No." := 1;
        Rec.Insert();
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    procedure SetGenJournalLine(GenJournalLineRef: Record "Gen. Journal Line")
    begin
        GenJournalLine := GenJournalLineRef;
    end;

    procedure GetDescription(): Text
    begin
        exit(description);
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLineRef: Record "Gen. Journal Line";
        FreeStyleCheckReport: Report "FS Check (Check/Stub/Stub)";
        description: Text[250];
}
