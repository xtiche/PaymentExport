page 50201 "PTE Bank Extract Buffer"
{
    Caption = 'Bank Extract Buffer';
    PageType = List;
    SourceTable = "PTE Bank Extract Buffer";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Account Number"; Rec."Account Number")
                {
                    ToolTip = 'Specifies the value of the Account Number field.';
                    ApplicationArea = All;
                }
                field("ABA Rounding"; Rec."ABA Rounding")
                {
                    ToolTip = 'Specifies the value of the ABA Rounding field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Individual Name"; Rec."Individual Name")
                {
                    ToolTip = 'Specifies the value of the Individual Name field.';
                    ApplicationArea = All;
                }
                field("Individual ID"; Rec."Individual ID")
                {
                    ToolTip = 'Specifies the value of the Individual ID field.';
                    ApplicationArea = All;
                }
                field("Company ID"; Rec."Company ID")
                {
                    ToolTip = 'Specifies the value of the Company ID field.';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    ApplicationArea = All;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                    ApplicationArea = All;
                }
                field(Class; Rec.Class)
                {
                    ToolTip = 'Specifies the value of the Class field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Transaction Number"; Rec."Transaction Number")
                {
                    ToolTip = 'Specifies the value of the Transaction Number field.';
                    ApplicationArea = All;
                }
                field("Unique ID"; Rec."Unique ID")
                {
                    ToolTip = 'Specifies the value of the Unique ID field.';
                    ApplicationArea = All;
                }
                field("ACH Batch No."; Rec."ACH Batch No.")
                {
                    ToolTip = 'Specifies the value of the ACH Batch No. field.';
                    ApplicationArea = All;
                }
                field(Recognized; Rec.Recognized)
                {
                    ToolTip = 'Specifies the value of the Recognized field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Buffer")
            {
                ApplicationArea = All;
                Caption = 'Process Buffer';
                Image = Process;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ProcessBuffer();
                end;
            }

            action("Import ACH EFT")
            {
                ApplicationArea = All;
                Caption = 'Import ACH EFT';
                Image = Import;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportACHHelper: Codeunit "PTE ACH EFT Import Helper";
                begin
                    ImportACHHelper.ImportEFTToBuffer(Rec."Journal Template Name", REc."Journal Batch Name");
                end;
            }
        }
    }

    local procedure ProcessBuffer()
    var
        GenJnlLine: Record "Gen. Journal Line";
        ExportBuffer: Record "PTE Bank Extract Buffer";
    begin
        ExportBuffer.Copy(Rec);

        GenJnlLine.SetRange("Journal Template Name", ExportBuffer."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", ExportBuffer."Journal Batch Name");

        ExportBuffer.SetRange(Recognized, false);
        if ExportBuffer.FindSet() then
            repeat
                GenJnlLine.SetRange("Posting Date", ExportBuffer.Date);
                GenJnlLine.SetRange("ACH Batch No.", ExportBuffer."ACH Batch No.");
                GenJnlLine.SetRange("Unique ID", ExportBuffer."Unique ID");
                GenJnlLine.SetRange("ACH Batch Total", ExportBuffer.Amount);
                if GenJnlLine.FindLast() then begin
                    GenJnlLine."ACH Status" := GenJnlLine."ACH Status"::Paid;
                    GenJnlLine.Modify();

                    ExportBuffer.Recognized := true;
                    ExportBuffer.Modify();
                end;
            until ExportBuffer.Next() = 0;
    end;


}
