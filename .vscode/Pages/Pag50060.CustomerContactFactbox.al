page 50060 CustomerContactFactbox
{
    ApplicationArea = All;
    Caption = 'CustomerContactFactbox';
    PageType = ListPart;
    SourceTable = Contact;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        contactPage: Page "Contact Card";
                        contact: Record Contact;
                    begin
                        contact.Reset();
                        contact.SetRange("No.", rec."No.");
                        if (contact.FindFirst()) then begin
                            Clear(contactPage);
                            contactPage.SetRecord(contact);
                            contactPage.Run();
                        end;

                    end;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        contactPage: Page "Contact Card";
                        contact: Record Contact;
                    begin
                        contact.Reset();
                        contact.SetRange("No.", rec."No.");
                        if (contact.FindFirst()) then begin
                            Clear(contactPage);
                            contactPage.SetRecord(contact);
                            contactPage.Run();
                        end;

                    end;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        contactPage: Page "Contact Card";
                        contact: Record Contact;
                    begin
                        contact.Reset();
                        contact.SetRange("No.", rec."No.");
                        if (contact.FindFirst()) then begin
                            Clear(contactPage);
                            contactPage.SetRecord(contact);
                            contactPage.Run();
                        end;

                    end;
                }
            }
        }
    }
}
