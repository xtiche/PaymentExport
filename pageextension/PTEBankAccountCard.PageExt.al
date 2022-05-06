pageextension 50202 "PTE Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addlast("Payment Matching")
        {
            field("ACH Batch Nos."; Rec."ACH Batch Nos.")
            {
                ApplicationArea = All;
            }
            field("Unique ID Nos."; Rec."Unique ID Nos.")
            {
                ApplicationArea = All;
            }
            field("FI Identification"; Rec."FI Identification")
            {
                ApplicationArea = All;
            }
        }
    }
}
