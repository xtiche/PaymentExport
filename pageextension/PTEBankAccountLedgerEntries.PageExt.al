pageextension 50204 "PTEBank Account Ledger Entries" extends "Bank Account Ledger Entries"
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