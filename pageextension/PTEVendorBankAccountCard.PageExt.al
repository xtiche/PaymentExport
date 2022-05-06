pageextension 50207 "PTE Vendor Bank Account Card" extends "Vendor Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field(FIID; Rec.FIID)
            {
                ApplicationArea = All;
            }
        }
    }
}