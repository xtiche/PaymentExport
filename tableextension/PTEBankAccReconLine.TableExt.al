tableextension 50201 "PTE Bank Acc. Recon. Line" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(50200; "Transaction No."; Text[100])
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }
        field(50201; "Related Party No."; Code[20])
        {
            Caption = 'Related Party No.';
            DataClassification = CustomerContent;
        }
        field(50202; "Related Party Name"; Text[100])
        {
            Caption = 'Related Party Name';
            DataClassification = CustomerContent;
        }
        field(50203; "Transation Type"; Code[20])
        {
            Caption = 'Transation Type';
            DataClassification = CustomerContent;
        }
        field(50204; "ACH Batch No."; Code[20])
        {
            Caption = 'ACH Batch No.';
            DataClassification = CustomerContent;
        }
    }
}
