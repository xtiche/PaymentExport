page 50200 "PTE Transaction Types"
{
    ApplicationArea = All;
    Caption = 'Transaction Types';
    PageType = List;
    SourceTable = "PTE Transaction Type";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    ApplicationArea = All;
                }
                field(Sign; Rec.Sign)
                {
                    ToolTip = 'Specifies the value of the Sign field.';
                    ApplicationArea = All;
                }
                field(System; Rec.System)
                {
                    ToolTip = 'Specifies the value of the System field.';
                    ApplicationArea = All;
                }
                field("ACH Prefix"; Rec."ACH Prefix")
                {
                    ToolTip = 'Specifies the value of the ACH Prefix field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
