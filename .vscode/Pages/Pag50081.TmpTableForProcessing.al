page 50081 TmpTableForProcessing
{
    ApplicationArea = All;
    Caption = 'TmpTableForProcessing';
    PageType = List;
    SourceTable = TmpTableForProcessing;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(DocumentNo; Rec.DocumentNo)
                {
                    ToolTip = 'Specifies the value of the DocumentNo field.', Comment = '%';
                }
                field(ExternalDocumentNo; Rec.ExternalDocumentNo)
                {
                    ToolTip = 'Specifies the value of the ExternalDocumentNo field.', Comment = '%';
                }
                field(Decimal1; Rec.Decimal1)
                {
                    ToolTip = 'Specifies the value of the Decimal1 field.', Comment = '%';
                }
                field(Decimal2; Rec.Decimal2)
                {
                    ToolTip = 'Specifies the value of the Decimal2 field.', Comment = '%';
                }
            }
        }
    }
}
