page 60105 "Purchase Line Audit List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line Audit";
    Caption = 'Purchase Line Audit List';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field("Audit Entry No."; Rec."Audit Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique audit entry number';
                }
                field("Audit Date"; Rec."Audit Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when audit entry was created';
                }
                field("Audit User ID"; Rec."Audit User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who created the audit entry';
                }
                field("Audit Action"; Rec."Audit Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the audit action performed';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of purchase document';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase document number';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase line number';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Vendor number';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of purchase line';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item/Resource/GL Account number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the item/service';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Current quantity on purchase line';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current quantity received';
                    Style = Strong;
                }
                field("Orig Quantity Received"; Rec."Orig Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Original quantity received before correction';
                    Style = Attention;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current quantity invoiced';
                    Style = Strong;
                }
                field("Orig Quantity Invoiced"; Rec."Orig Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Original quantity invoiced before correction';
                    Style = Attention;
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current quantity received in base unit';
                    Visible = false;
                }
                field("Orig Qty. Received (Base)"; Rec."Orig Qty. Received (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Original quantity received in base unit before correction';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            /*
                        part(AuditSummary; "Purchase Line Audit FactBox")
                        {
                            ApplicationArea = All;
                            SubPageLink = "Document Type" = field("Document Type"),
                                  "Document No." = field("Document No."),
                                  "Line No." = field("Line No.");
                        }
                    }
            */
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ViewPurchaseLine)
            {
                ApplicationArea = All;
                Caption = 'View Purchase Line';
                Image = Line;
                ToolTip = 'Open the original purchase line';

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                begin
                    if PurchLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                        Page.Run(Page::"Purchase Lines", PurchLine);
                    end else
                        Message('Purchase line %1 %2 line %3 no longer exists.', Rec."Document Type", Rec."Document No.", Rec."Line No.");
                end;
            }
            action(ViewPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'View Purchase Order';
                Image = Document;
                ToolTip = 'Open the purchase order';

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin
                    if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                        Page.Run(Page::"Purchase Order", PurchHeader);
                    end else
                        Message('Purchase order %1 no longer exists.', Rec."Document No.");
                end;
            }
        }
        area(Processing)
        {
            group(Filters)
            {
                Caption = 'Filters';
                action(FilterToday)
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Audits';
                    Image = FilterLines;
                    ToolTip = 'Show only audit entries created today';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Audit Date", CreateDateTime(Today, 0T), CreateDateTime(Today, 235959T));
                        CurrPage.Update();
                    end;
                }
                action(FilterThisWeek)
                {
                    ApplicationArea = All;
                    Caption = 'This Week''s Audits';
                    Image = FilterLines;
                    ToolTip = 'Show audit entries from this week';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Audit Date", CreateDateTime(CalcDate('<-CW>', Today), 0T), CreateDateTime(Today, 235959T));
                        CurrPage.Update();
                    end;
                }
                action(FilterQuantityMismatches)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Mismatch Fixes';
                    Image = FilterLines;
                    ToolTip = 'Show only quantity mismatch correction entries';

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Audit Action", '*Quantity Mismatch*|*BC 26.3*|*Correction*');
                        CurrPage.Update();
                    end;
                }
                action(ClearFilters)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Filters';
                    Image = ClearFilter;
                    ToolTip = 'Remove all filters';

                    trigger OnAction()
                    begin
                        Rec.Reset();
                        CurrPage.Update();
                    end;
                }
            }

        }

    }

    views
    {
        view(TodaysAudits)
        {
            Caption = 'Today''s Audits';
            // Remove the Filters line - use actions instead for dynamic filtering
            OrderBy = descending("Audit Date");
        }
        view(QuantityMismatches)
        {
            Caption = 'Quantity Mismatch Fixes';
            Filters = where("Audit Action" = filter('*Quantity Mismatch*|*BC 26.3*|*Correction*'));
            OrderBy = descending("Audit Date");
        }
        view(RecentAudits)
        {
            Caption = 'Recent Audits';
            OrderBy = descending("Audit Date");
        }
    }
}