table 50200 "PTE Transaction Type"
{
    Caption = 'Transaction Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; Sign; Option)
        {
            Caption = 'Sign';
            OptionMembers = "Debit","Credit";
            OptionCaption = 'Debit,Credit';
            DataClassification = CustomerContent;
        }
        field(30; System; Option)
        {
            Caption = 'System';
            OptionMembers = ACH,Wire;
            OptionCaption = 'ACH,Wire';
            DataClassification = CustomerContent;
        }
        field(40; Note; Text[250])
        {
            Caption = 'Note';
            DataClassification = CustomerContent;
        }
        field(50; "ACH Prefix"; Text[10])
        {
            Caption = 'ACH Prefix';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
