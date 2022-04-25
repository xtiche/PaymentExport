pageextension 50200 "PTE Bank Acc. Recon. Lines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
            }
            field("Related Party No."; Rec."Related Party No.")
            {
                ApplicationArea = All;
            }
            field("Related Party Name"; Rec."Related Party Name")
            {
                ApplicationArea = All;
            }
            field("Transation Type"; Rec."Transation Type")
            {
                ApplicationArea = All;
            }
            field("ACH Batch No."; Rec."ACH Batch No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

