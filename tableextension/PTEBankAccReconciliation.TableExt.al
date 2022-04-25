tableextension 50208 "PTE Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    procedure MatchSinglenew(DateRange: Integer)
    var
        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
        IsHandled: Boolean;
        BankAccountReconciliation: Record "Bank Acc. Reconciliation";
    begin
        IsHandled := false;
        OnBeforeMatchSingle(Rec, DateRange, IsHandled);
        if IsHandled then
            exit;

        MatchBankRecLines.MatchSingle(Rec, DateRange);

    end;

    procedure MatchCandidateFilterDateNew(): Date
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.SetRange("Statement Type", "Statement Type");
        BankAccReconciliationLine.SetRange("Statement No.", "Statement No.");
        BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Account No.");
        BankAccReconciliationLine.SetCurrentKey("Transaction Date");
        BankAccReconciliationLine.Ascending := false;
        if BankAccReconciliationLine.FindFirst() then
            if BankAccReconciliationLine."Transaction Date" > "Statement Date" then
                exit(BankAccReconciliationLine."Transaction Date");

        exit("Statement Date");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeMatchSingle(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; DateRange: Integer; var IsHandled: Boolean)
    begin
    end;
}
