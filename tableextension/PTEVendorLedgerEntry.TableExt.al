tableextension 50203 "PTE Vendor Ledger Entry" extends "Vendor Ledger Entry"
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
        field(50202; "ACH Status"; Enum "PTE ACH Status")
        {
            Caption = 'ACH Status';
            DataClassification = CustomerContent;
        }
        field(50203; "ACH Batch Total"; Decimal)
        {
            Caption = 'ACH Batch Total';
            DataClassification = CustomerContent;
        }
    }
}
