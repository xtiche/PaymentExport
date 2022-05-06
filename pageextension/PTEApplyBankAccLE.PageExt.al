pageextension 50206 "PTE Apply Bank Acc LE" extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ACH Batch No."; Rec."ACH Batch No.")
            {
                ApplicationArea = All;
            }
            field("Related Party No."; Rec."Related Party No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Related Party Name"; Rec."Related Party Name")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }
}
