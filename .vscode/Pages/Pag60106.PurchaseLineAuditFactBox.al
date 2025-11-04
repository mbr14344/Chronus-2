page 60106 "Purchase Line Audit FactBox"
{
    PageType = CardPart;
    SourceTable = "Purchase Line Audit";
    Caption = 'Purchase Line Audit Summary';

    layout
    {
        area(Content)
        {
            group(Summary)
            {
                Caption = 'Audit Summary';

                field(TotalAuditEntries; TotalAuditEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Total Audit Entries';
                    ToolTip = 'Total number of audit entries for this purchase line';
                    Editable = false;
                    Style = Strong;
                }
                field(LastAuditDate; LastAuditDate)
                {
                    ApplicationArea = All;
                    Caption = 'Last Audit Date';
                    ToolTip = 'Date of the most recent audit entry';
                    Editable = false;
                }
                field(LastAuditAction; LastAuditAction)
                {
                    ApplicationArea = All;
                    Caption = 'Last Action';
                    ToolTip = 'Description of the most recent audit action';
                    Editable = false;
                }
            }

            group(QuantityChanges)
            {
                Caption = 'Quantity Changes';

                field(QuantityReceivedChanges; QuantityReceivedChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Qty. Received Changes';
                    ToolTip = 'Number of times quantity received was modified';
                    Editable = false;
                    Style = Attention;
                }
                field(QuantityInvoicedChanges; QuantityInvoicedChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Qty. Invoiced Changes';
                    ToolTip = 'Number of times quantity invoiced was modified';
                    Editable = false;
                    Style = Attention;
                }
                field(MismatchCorrections; MismatchCorrections)
                {
                    ApplicationArea = All;
                    Caption = 'Mismatch Corrections';
                    ToolTip = 'Number of quantity mismatch corrections applied';
                    Editable = false;
                    Style = Favorable;
                }
            }

            group(CurrentValues)
            {
                Caption = 'Current vs Original';

                field(CurrentQuantityReceived; CurrentQuantityReceived)
                {
                    ApplicationArea = All;
                    Caption = 'Current Qty. Received';
                    ToolTip = 'Current quantity received on the purchase line';
                    Editable = false;
                    Style = Strong;
                }
                field(OriginalQuantityReceived; OriginalQuantityReceived)
                {
                    ApplicationArea = All;
                    Caption = 'Original Qty. Received';
                    ToolTip = 'Original quantity received before corrections';
                    Editable = false;
                    Style = Subordinate;
                }
                field(CurrentQuantityInvoiced; CurrentQuantityInvoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Current Qty. Invoiced';
                    ToolTip = 'Current quantity invoiced on the purchase line';
                    Editable = false;
                    Style = Strong;
                }
                field(OriginalQuantityInvoiced; OriginalQuantityInvoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Original Qty. Invoiced';
                    ToolTip = 'Original quantity invoiced before corrections';
                    Editable = false;
                    Style = Subordinate;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewAllAudits)
            {
                ApplicationArea = All;
                Caption = 'View All Audits';
                Image = History;
                ToolTip = 'View all audit entries for this purchase line';

                trigger OnAction()
                var
                    PurchLineAudit: Record "Purchase Line Audit";
                begin
                    PurchLineAudit.SetRange("Document Type", DocumentType);
                    PurchLineAudit.SetRange("Document No.", DocumentNo);
                    PurchLineAudit.SetRange("Line No.", LineNo);
                    Page.Run(Page::"Purchase Line Audit List", PurchLineAudit);
                end;
            }
            action(ViewPurchaseLine)
            {
                ApplicationArea = All;
                Caption = 'View Purchase Line';
                Image = Line;
                ToolTip = 'Open the purchase line';

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                begin
                    if PurchLine.Get(DocumentType, DocumentNo, LineNo) then
                        Page.Run(Page::"Purchase Lines", PurchLine)
                    else
                        Message('Purchase line no longer exists.');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateSummaryData();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateSummaryData();
    end;

    local procedure CalculateSummaryData()
    var
        PurchLineAudit: Record "Purchase Line Audit";
        PurchLine: Record "Purchase Line";
    begin
        // Get filter values from main page
        DocumentType := Rec."Document Type";
        DocumentNo := Rec."Document No.";
        LineNo := Rec."Line No.";

        // Calculate summary statistics
        PurchLineAudit.SetRange("Document Type", DocumentType);
        PurchLineAudit.SetRange("Document No.", DocumentNo);
        PurchLineAudit.SetRange("Line No.", LineNo);

        TotalAuditEntries := PurchLineAudit.Count();

        // Get last audit entry
        PurchLineAudit.SetCurrentKey("Audit Date");
        if PurchLineAudit.FindLast() then begin
            LastAuditDate := PurchLineAudit."Audit Date";
            LastAuditAction := PurchLineAudit."Audit Action";
        end else begin
            LastAuditDate := 0DT;
            LastAuditAction := '';
        end;

        // Count different types of changes
        PurchLineAudit.SetFilter("Audit Action", '*Quantity Received*');
        QuantityReceivedChanges := PurchLineAudit.Count();

        PurchLineAudit.SetFilter("Audit Action", '*Quantity Invoiced*');
        QuantityInvoicedChanges := PurchLineAudit.Count();

        PurchLineAudit.SetFilter("Audit Action", '*Mismatch*|*BC 26.3*|*Correction*');
        MismatchCorrections := PurchLineAudit.Count();

        // Get current values from purchase line
        if PurchLine.Get(DocumentType, DocumentNo, LineNo) then begin
            CurrentQuantityReceived := PurchLine."Quantity Received";
            CurrentQuantityInvoiced := PurchLine."Quantity Invoiced";
        end else begin
            CurrentQuantityReceived := 0;
            CurrentQuantityInvoiced := 0;
        end;

        // Get original values from first audit entry
        PurchLineAudit.Reset();
        PurchLineAudit.SetRange("Document Type", DocumentType);
        PurchLineAudit.SetRange("Document No.", DocumentNo);
        PurchLineAudit.SetRange("Line No.", LineNo);
        PurchLineAudit.SetCurrentKey("Audit Date");
        if PurchLineAudit.FindFirst() then begin
            OriginalQuantityReceived := PurchLineAudit."Orig Quantity Received";
            OriginalQuantityInvoiced := PurchLineAudit."Orig Quantity Invoiced";
        end else begin
            OriginalQuantityReceived := CurrentQuantityReceived;
            OriginalQuantityInvoiced := CurrentQuantityInvoiced;
        end;
    end;

    var
        DocumentType: Enum "Purchase Document Type";
        DocumentNo: Code[20];
        LineNo: Integer;
        TotalAuditEntries: Integer;
        LastAuditDate: DateTime;
        LastAuditAction: Text[250];
        QuantityReceivedChanges: Integer;
        QuantityInvoicedChanges: Integer;
        MismatchCorrections: Integer;
        CurrentQuantityReceived: Decimal;
        CurrentQuantityInvoiced: Decimal;
        OriginalQuantityReceived: Decimal;
        OriginalQuantityInvoiced: Decimal;
}