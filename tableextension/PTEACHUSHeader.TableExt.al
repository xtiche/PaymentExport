tableextension 50209 "PTE ACH US Header" extends "ACH US Header"
{
    fields
    {
        field(50201; "ACH Batch No."; Code[20])
        {
            Caption = 'ACH Batch No.';
            DataClassification = CustomerContent;
        }
    }
}
