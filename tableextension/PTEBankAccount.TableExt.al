tableextension 50202 "PTE Bank Account" extends "Bank Account"
{
    fields
    {
        field(50200; "ACH Batch Nos."; Code[20])
        {
            Caption = 'ACH Batch Nos.';
            TableRelation = "No. Series";
        }
        field(50201; "Unique ID Nos."; Code[20])
        {
            Caption = 'Unique ID Nos.';
            TableRelation = "No. Series";
        }
        field(50202; "FI Identification"; Boolean)
        {
            Caption = 'FI Identification';
        }
    }
}
