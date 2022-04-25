tableextension 50210 "PTE ACH US Footer" extends "ACH US Footer"
{
    fields
    {
        field(50202; "ACH Batch Total"; Decimal)
        {
            Caption = 'ACH Batch Total';
            DataClassification = CustomerContent;
        }
    }
}
