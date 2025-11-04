report 50134 FDANotice
{
    Caption = 'FDANotice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    ApplicationArea = All;

    RDLCLayout = './.vscode/ReportLayout/FDANotice.rdl';

    dataset
    {
        dataitem(ContainerLine; ContainerLine)
        {
            column(CompanyInfo; CompanyInfo.Name)
            { }
            column(RptTitle; RptTitle)
            { }
            column(Container_No_; "Container No.")
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(Item_Description; "Item Description")
            {

            }
            column(Quantity; "Quantity")
            {

            }

            column(Dynamic_Date; DynamicDate)
            {
            }
            column(Dynamic_Caption; DynamicCaption)
            {
            }

            trigger OnPreDataItem()
            begin
                SubjectTitle := '';
                ContainerHdrsTmp.DeleteAll();
                ContainerHdrsTmp.reset();
                containerCount := 0;
                if (FDAHoldType = true) then begin
                    ContainerLine.SetRange("FDA Hold", true);
                    ContainerLine.SetRange(FDAHoldEmailNotifiSentDate, 0D);
                    DynamicCaption := 'FDA Hold Date';
                    SubjectTitle := 'FDA Hold Notice';
                end else begin
                    ContainerLine.SetRange("FDA Hold", false);
                    ContainerLine.SetRange(FDAReleasedEmailNotifiSentDate, 0D);
                    ContainerLine.SetFilter("FDA Released Date", '<>%1', 0D);
                    DynamicCaption := 'FDA Released Date';
                    SubjectTitle := 'FDA Released Notice';
                end;
                recCount := 0;
                subjectLength := 250 - StrLen(SubjectTitle);
                CompanyInfo.Get();
            end;


        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("FDAHoldType"; FDAHoldType)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Select the type of FDA action to perform.';
                        Caption = 'Type';
                        ShowMandatory = true;
                    }

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        FDAHoldType: Boolean;
        DynamicDate: Date;
        DynamicCaption: Text[50];
        recCount: Integer;
        CompanyInfo: Record "Company Information";
        RptTitle: Label 'FDA Notice Report';
        SubjectTitle: Text;
        subject: Text[250];
        subjectLength: Integer;
        ContainerHdrsTmp: Record TmpTable temporary;
        containerCount: Integer;

    procedure ChkNoRecords(): integer
    begin
        exit(recCount);
    end;

    procedure InitializeRequest(givenType: Boolean)
    begin
        FDAHoldType := givenType;
    end;

    procedure GetSubject(): Text[250]
    var
        seperator: Text[10];
        index: Integer;
    begin
        subjectLength := 250 - StrLen(SubjectTitle) + 3;
        index := 0;
        ContainerHdrsTmp.Reset();
        if (ContainerHdrsTmp.FindFirst()) then begin

        end;
        if (ContainerHdrsTmp.FindSet()) then
            repeat
                if (index = 0) then
                    seperator := ''
                else if (index >= (containerCount - 1)) then
                    seperator := ' and '
                else
                    seperator := ', ';
                subject += seperator + ContainerHdrsTmp."Code";
                index += 1;
            until ContainerHdrsTmp.Next() = 0;
        if (StrLen(subject) <= subjectLength) then
            // restrict subject length
            subject := CopyStr(subject, 1, subjectLength)
        else begin
            subject := CopyStr(subject, 1, subjectLength - 3);
            subject := subject + '...';
        end;
        subject := subject + ' - ' + SubjectTitle;
        exit(subject);
    end;
}



enum 50000 FDAHoldType
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "Hold") { }
    value(1; "Release") { }
}

