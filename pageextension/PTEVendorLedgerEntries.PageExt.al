pageextension 50205 "PTE Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ACH Batch No."; Rec."ACH Batch No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Unique ID"; Rec."Unique ID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ACH Status"; Rec."ACH Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ACH Batch Total"; Rec."ACH Batch Total")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
