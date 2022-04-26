codeunit 50201 "PTE Gen. Jnl Posting Helper"
{

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."ACH Batch No." := GenJournalLine."ACH Batch No.";
        VendorLedgerEntry."ACH Batch Total" := GenJournalLine."ACH Batch Total";
        VendorLedgerEntry."ACH Status" := GenJournalLine."ACH Status";
        VendorLedgerEntry."Unique ID" := GenJournalLine."Unique ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."ACH Batch No." := GenJournalLine."ACH Batch No.";
        BankAccountLedgerEntry."ACH Batch Total" := GenJournalLine."ACH Batch Total";
        BankAccountLedgerEntry."ACH Status" := GenJournalLine."ACH Status";
        BankAccountLedgerEntry."Unique ID" := GenJournalLine."Unique ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCodeGenJnlPost(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if GenJnlTemplate.Get(GenJournalLine."Journal Template Name") and
            (GenJnlTemplate."Page ID" = Page::"Payment Journal")
        then
            GenJournalLine.TestField("ACH Status", GenJournalLine."ACH Status"::Paid);
    end;

}
