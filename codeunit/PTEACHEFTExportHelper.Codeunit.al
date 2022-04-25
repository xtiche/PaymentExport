codeunit 50202 "PTE ACH EFT Export Helper"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Export EFT (ACH)", 'OnStartExportFileOnBeforeACHUSHeaderModify', '', false, false)]
    local procedure OnStartExportFileOnBeforeACHUSHeaderModify(var ACHUSHeader: Record "ACH US Header"; BankAccount: Record "Bank Account")
    begin
        Clear(BankAccountGlobal);
        BankAccountGlobal := BankAccount;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Export EFT (ACH)", 'OnStartExportBatchOnBeforeACHUSHeaderModify', '', false, false)]
    local procedure OnStartExportBatchOnBeforeACHUSHeaderModify(var ACHUSHeader: Record "ACH US Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if ACHUSHeader."ACH Batch No." = '' then
            if BankAccountGlobal."ACH Batch Nos." <> '' then begin
                ACHBatchNo := NoSeriesMgt.DoGetNextNo(BankAccountGlobal."ACH Batch Nos.", WorkDate(), true, false);
                ACHUSHeader."ACH Batch No." := ACHBatchNo;
                ACHUSHeader.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Export EFT (ACH)", 'OnBeforeACHUSDetailModify', '', false, false)]
    local procedure OnBeforeACHUSDetailModify(var TempEFTExportWorkset: Record "EFT Export Workset"; var ACHUSDetail: Record "ACH US Detail")
    var
        ACHUSHeader: Record "ACH US Header";
        GenJnlLine: Record "Gen. Journal Line";
        BankAccount: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        ACHUSHeader.FindLast();
        if TempEFTExportWorkset."Bal. Account Type" = TempEFTExportWorkset."Bal. Account Type"::"Bank Account" then
            BankAccount.Get(TempEFTExportWorkset."Bal. Account No.");

        ACHUSDetail."ACH Batch No." := ACHUSHeader."ACH Batch No.";
        if BankAccount."Unique ID Nos." <> '' then
            ACHUSDetail."Unique ID" := NoSeriesMgt.DoGetNextNo(BankAccount."Unique ID Nos.", WorkDate(), true, false);

        if GenJnlLine.Get(TempEFTExportWorkset."Journal Template Name",
            TempEFTExportWorkset."Journal Batch Name",
            TempEFTExportWorkset."Line No.")
        then begin
            GenJnlLine."ACH Batch No." := ACHUSHeader."ACH Batch No.";
            GenJnlLine."Unique ID" := ACHUSDetail."Unique ID";
            GenJnlLine."ACH Status" := GenJnlLine."ACH Status"::Exported;
            GenJnlLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Export EFT (ACH)", 'OnEndExportBatchOnBeforeACHUSFooterModify', '', false, false)]
    local procedure OnEndExportBatchOnBeforeACHUSFooterModify(var ACHUSFooter: Record "ACH US Footer"; BankAccount: Record "Bank Account")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if ACHBatchNo <> '' then begin
            GenJnlLine.SetRange("ACH Batch No.", ACHBatchNo);
            GenJnlLine.ModifyAll("ACH Batch Total", ACHUSFooter."Total Batch Credit Amount" / 2);
            Clear(ACHBatchNo);
        end;
    end;

    var
        BankAccountGlobal: Record "Bank Account";
        ACHBatchNo: Code[20];

}
