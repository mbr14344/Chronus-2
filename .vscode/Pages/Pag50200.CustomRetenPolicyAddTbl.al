page 50200 CustomRetenPolicyAddTbl
{
    ApplicationArea = All;
    Caption = 'Custom Reten. Pol. Allowed Tables';
    PageType = List;
    SourceTable = RetentionPolicyAddedTable;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field(TblID; Rec.TblID)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        RecRef: RecordRef;
                    begin
                        RecRef.Open(Rec.TblID);
                        Rec.TableName := RecRef.Name;
                    end;
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(AllowedTables)
            {
                Caption = 'Add to Reten. Pol. Allowed Tables';
                ApplicationArea = All;
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
                begin
                    if not Rec.IsEmpty then
                        repeat
                            RetenPolAllowedTables.AddAllowedTable(Rec.TblID);
                            Message(txtTableAdded, Rec.TblID, Rec.TableName);
                        until Rec.Next() = 0;
                end;

            }
        }
    }
    var
        txtTableAdded: Label 'Table %1 %2 is now added in the Retention Policy Allowable Tables.';
}