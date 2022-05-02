codeunit 50205 "PTERelatedPartyNoAndName"
{
    Permissions = TableData "Bank Account Ledger Entry" = RIMD;
    TableNo = Customer;

    trigger OnRun();

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        BankaccountLedgerEntry: Record "Bank Account Ledger Entry";
        EmptyText: text;

    begin
        EmptyText := '';
        BankaccountLedgerEntry.SetFilter(BankaccountLedgerEntry."Related Party Name", '=%1', EmptyText);
        if BankaccountLedgerEntry.FindSet() then
            repeat
                VendorLedgerEntry.SetFilter("Document No.", BankaccountLedgerEntry."Document No.");
                if VendorLedgerEntry.FindFirst()
                then begin
                    BankaccountLedgerEntry."Related Party No." := VendorLedgerEntry."Vendor No.";
                    BankaccountLedgerEntry."Related Party Name" := VendorLedgerEntry."Vendor Name";
                    BankaccountLedgerEntry.Modify();
                    Commit();
                end;

            until BankaccountLedgerEntry.Next() = 0;


    end;



}
