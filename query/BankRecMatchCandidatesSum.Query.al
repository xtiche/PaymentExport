query 50202 "Bank Rec. Match Candidates Sum"
{
    Caption = 'Bank Rec. Match Candidates Summary';

    elements
    {
        dataitem(Bank_Acc_Reconciliation_Line; "Bank Acc. Reconciliation Line")
        {
            DataItemTableFilter = Difference = FILTER(<> 0), Type = FILTER(= "Bank Account Ledger Entry");

            column(Rec_Line_Bank_Account_No; "Bank Account No.")
            {
            }

            dataitem(Bank_Account_Ledger_Entry; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = Bank_Acc_Reconciliation_Line."Bank Account No.";
                DataItemTableFilter = "Remaining Amount" = FILTER(<> 0), Open = CONST(true), "Statement Status" = FILTER(Open), Reversed = CONST(false);
                column(Bank_Account_No; "Bank Account No.")
                {
                }
                column(Bank_Ledger_Entry_Open; Open)
                {
                }
                column(Statement_Status; "Statement Status")
                {
                }
                column(ACH_Batch_No_New; "ACH Batch No.")
                {
                }
                column(Remaining_Amount; "Remaining Amount")
                {
                    Method = Sum;
                }
            }
        }
    }
}
