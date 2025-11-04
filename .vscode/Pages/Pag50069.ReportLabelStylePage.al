page 50069 ReportLabelStylePage
{
    ApplicationArea = All;
    Caption = 'Report Label Type';
    PageType = List;
    SourceTable = ReportLabelStyle;
    UsageCategory = Lists;
    // Editable = false;
    //InsertAllowed = false;
    //DeleteAllowed = false;



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."Code")
                {

                    ApplicationArea = all;
                }
                field("Label Translation"; Rec."Label Translation")
                {
                    ApplicationArea = All;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ReportLayoutSelection: Record "Report Layout List";
                    begin
                        ReportLayoutSelection.Reset();
                        ReportLayoutSelection.SetRange("Report ID", rec."Report ID");
                        if (ReportLayoutSelection.FindSet()) then begin
                            rec."Report Name" := ReportLayoutSelection."Report Name";
                            rec."Layout Description" := ReportLayoutSelection."Description";
                            rec."Layout Type" := ReportLayoutSelection."Layout Format";
                            // rec.Modify();ReportLayoutSelection
                        end;

                    end;
                }
                field("Use Pallet"; Rec."Use Pallet")
                {
                    ApplicationArea = all;
                }
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = all;
                }
                field("Layout Type"; Rec."Layout Type")
                {
                    ApplicationArea = All;
                }
                field("Layout Description"; Rec."Layout Description")
                {
                    ApplicationArea = All;
                }
                field("Batch Report ID"; Rec."Batch Report ID")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ReportLayoutSelection: Record "Report Layout List";
                    begin
                        ReportLayoutSelection.Reset();
                        ReportLayoutSelection.SetRange("Report ID", rec."Batch Report ID");
                        if (ReportLayoutSelection.FindSet()) then begin
                            rec."Batch Report Name" := ReportLayoutSelection."Report Name";
                            rec."Batch Layout Description" := ReportLayoutSelection."Description";
                            rec."Batch Layout Type" := ReportLayoutSelection."Layout Format";
                            // rec.Modify();ReportLayoutSelection
                        end;

                    end;
                }
                field("Batch Report Name"; Rec."Batch Report Name")
                {
                    ApplicationArea = all;
                }
                field("Batch Layout Type"; Rec."Batch Layout Type")
                {
                    ApplicationArea = All;
                }
                field("Batch Layout Description"; Rec."Batch Layout Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ReportLaoutSelection: Record "Report Layout List";
    begin
        ReportLaoutSelection.Reset();
        ReportLaoutSelection.SetRange("Report ID", rec."Report ID");
        if (ReportLaoutSelection.FindSet()) then begin
            rec."Report Name" := ReportLaoutSelection."Report Name";
            rec."Layout Description" := ReportLaoutSelection."Description";
            rec."Layout Type" := ReportLaoutSelection."Layout Format";
        end;

    end;
}
