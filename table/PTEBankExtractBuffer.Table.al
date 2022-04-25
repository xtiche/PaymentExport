table 50201 "PTE Bank Extract Buffer"
{
    Caption = 'PTE Bank Extract Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(30; "Account Number"; Code[20])
        {
            Caption = 'Account Number';
            DataClassification = CustomerContent;
        }
        field(40; "ABA Rounding"; Decimal)
        {
            Caption = 'ABA Rounding';
            DataClassification = CustomerContent;
        }
        field(50; "Individual ID"; Text[50])
        {
            Caption = 'Individual ID';
            DataClassification = CustomerContent;
        }
        field(51; "Individual Name"; Text[100])
        {
            Caption = 'Individual Name';
            DataClassification = CustomerContent;
        }
        field(60; "Company ID"; Text[50])
        {
            Caption = 'Company ID';
            DataClassification = CustomerContent;
        }
        field(61; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(70; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            DataClassification = CustomerContent;
        }
        field(80; Class; Text[100])
        {
            Caption = 'Class';
            DataClassification = CustomerContent;
        }
        field(90; "Transaction Number"; Text[100])
        {
            Caption = 'Transaction Number';
            DataClassification = CustomerContent;
        }
        field(100; "Unique ID"; Text[100])
        {
            Caption = 'Unique ID';
            DataClassification = CustomerContent;
        }
        field(110; "ACH Batch No."; Code[20])
        {
            Caption = 'ACH Batch No.';
            DataClassification = CustomerContent;
        }
        field(120; Recognized; Boolean)
        {
            Caption = 'Recognized';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }
}
