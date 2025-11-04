page 50052 "Assembly Lines Page"
{
    ApplicationArea = All;
    Caption = 'Assembly Lines';
    PageType = List;
    SourceTable = "Assembly Line";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var

                        AssemblyOrder: Page "Assembly Order";
                        tblAssemblyOrder: Record "Assembly Header";
                    begin
                        tblAssemblyOrder.Reset();
                        tblAssemblyOrder.SetRange("No.", Rec."Document No.");
                        tblAssemblyOrder.SetRange("Document Type", Rec."Document Type");


                        if (tblAssemblyOrder.FindFirst()) then begin
                            Clear(AssemblyOrder);
                            AssemblyOrder.SetTableView(tblAssemblyOrder);
                            AssemblyOrder.Run();
                        end;
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Parent Item No."; Rec."Parent Item No.")
                {
                    ApplicationArea = All;
                }
                field("Parent Item Description"; Rec."Parent Item Description")
                {
                    ApplicationArea = All;
                }
                field("Parent Item Description 2"; Rec."Parent Item Description 2")
                {
                    ApplicationArea = All;
                }
                field(ParentItemQuantity; Rec.ParentItemQuantity)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity to Consume"; Rec."Quantity to Consume")
                {
                    ApplicationArea = All;
                }
                field("Consumed Quantity"; Rec."Consumed Quantity")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
}
