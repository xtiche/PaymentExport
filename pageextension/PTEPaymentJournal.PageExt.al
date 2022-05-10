pageextension 50201 "PTE Payment Journal" extends "Payment Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("ACH Batch No."; Rec."ACH Batch No.")
            {
                ApplicationArea = All;
                //  Editable = true;
            }
            field("Unique ID"; Rec."Unique ID")
            {
                ApplicationArea = All;
                //Editable = false;
            }
            field("ACH Status"; Rec."ACH Status")
            {
                ApplicationArea = All;
                //    Editable = false;
            }
            field("ACH Batch Total"; Rec."ACH Batch Total")
            {
                ApplicationArea = All;
                //   Editable = false;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("Bank Statment Buffer")
            {
                ApplicationArea = All;
                Caption = 'Bank Extract Buffer';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                RunObject = page "PTE Bank Extract Buffer";
                RunPageLink = "Journal Template Name" = field("Journal Template Name"),
                    "Journal Batch Name" = field("Journal Batch Name");
            }
        }
    }
}
