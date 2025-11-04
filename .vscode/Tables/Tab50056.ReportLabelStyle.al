table 50056 ReportLabelStyle
{
    Caption = 'ReportLabelStyle';
    DataClassification = ToBeClassified;
    LookupPageId = "ReportLabelStylePage";


    fields
    {
        field(1; "Code"; code[30])
        {
        }
        field(2; "Report ID"; Integer)
        {
            TableRelation = "Report Layout List"."Report ID";
        }
        field(3; "Report Name"; text[100])
        {

            //  Editable = false;
        }
        field(4; "Layout Type"; Option)
        {
            OptionCaption = 'RDLC,Word,Custom Layout,Excel,External';
            OptionMembers = "RDLC (built-in)","Word (built-in)","Custom Layout","Excel Layout","External Layout";
            Editable = false;
        }
        field(5; "Layout Description"; text[250])
        {

            Editable = false;
        }
        field(6; "Batch Report ID"; Integer)
        {

        }
        field(7; "Batch Report Name"; text[100])
        {

            //  Editable = false;
        }
        field(8; "Batch Layout Type"; Option)
        {
            OptionCaption = 'RDLC,Word,Custom Layout,Excel,External';
            OptionMembers = "RDLC (built-in)","Word (built-in)","Custom Layout","Excel Layout","External Layout";
            Editable = false;
        }
        field(9; "Batch Layout Description"; text[250])
        {

            //   Editable = false;
        }
        field(10; "Label Translation"; Code[20])
        {

        }
        field(11; "Use Pallet"; Boolean)
        {

        }


    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    /*trigger OnInsert()
    var
        ReportLaoutSelection: Record "Report Layout Selection";
    begin
        ReportLaoutSelection.Reset();
        ReportLaoutSelection.SetRange("Report ID", rec."Report ID");
        if (ReportLaoutSelection.FindSet()) then begin
            rec."Report Name" := ReportLaoutSelection."Report Name";
            rec."Laoyout Description" := ReportLaoutSelection."Report Layout Description";
            rec."Laoyout Type" := ReportLaoutSelection.Type;
        end;

    end;*/
}
