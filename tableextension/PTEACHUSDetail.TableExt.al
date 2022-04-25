tableextension 50207 "PTE ACH US Detail" extends "ACH US Detail"
{
    fields
    {
        field(50200; "Unique ID"; Code[20])
        {
            Caption = 'Unique ID';
            DataClassification = CustomerContent;
        }
        field(50201; "ACH Batch No."; Code[20])
        {
            Caption = 'ACH Batch No.';
            DataClassification = CustomerContent;
        }
    }
}
