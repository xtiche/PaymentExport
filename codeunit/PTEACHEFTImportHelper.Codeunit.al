codeunit 50203 "PTE ACH EFT Import Helper"
{
    procedure ImportEFTToBuffer(JnlTemplName: Code[10]; JnlBatchName: Code[10])
    var
        BankExtractBuffer: Record "PTE Bank Extract Buffer";
        FileMgt: Codeunit "File Management";
        FileBlob: Codeunit "Temp Blob";
        FileStream: InStream;
        FileLen: Integer;
        ReadBuffer: Text;
        ACHBatchNo: Code[20];
        ClientFileName: Text;
        SettleDate: Date;
    begin
        ClientFileName := FileMgt.BLOBImport(FileBlob, '');
        if ClientFileName = '' then
            exit;

        FileBlob.CreateInStream(FileStream);

        FileLen := 0;

        BankExtractBuffer.SetRange("Journal Template Name", JnlTemplName);
        BankExtractBuffer.SetRange("Journal Batch Name", JnlBatchName);
        if not BankExtractBuffer.FindLast() then begin
            BankExtractBuffer."Journal Template Name" := JnlTemplName;
            BankExtractBuffer."Journal Batch Name" := JnlBatchName;
        end;

        while (FileLen < FileBlob.Length()) do begin
            FileStream.ReadText(ReadBuffer);
            FileLen += StrLen(ReadBuffer) + 2;

            case CopyStr(ReadBuffer, 1, 1) of
                '5':
                    ProcessACHBathHeader(ReadBuffer, ACHBatchNo, SettleDate);
                '6':
                    begin
                        ProcessACHDetail(ReadBuffer, BankExtractBuffer);
                        BankExtractBuffer."ACH Batch No." := ACHBatchNo;
                        BankExtractBuffer.Date := SettleDate;
                        BankExtractBuffer.Modify();
                    end;
                '7':
                    ProcessACHAddendaDetail(ReadBuffer, BankExtractBuffer);
                '8':
                    ProcessACHFooter(ReadBuffer, ACHBatchNo, BankExtractBuffer);
                '9':
                    FileLen := FileBlob.Length();
            end
        end;
    end;

    local procedure ProcessACHBathHeader(ACHHeader: Text; var ACHBatchNo: Code[20]; var SettleDate: Date)
    var
        Year, Month, Day : Integer;
    begin
        Clear(ACHBatchNo);
        Clear(SettleDate);
        ACHBatchNo := CopyStr(ACHHeader, 54, 10);
        if Evaluate(Year, CopyStr(ACHHeader, 70, 2)) and
            Evaluate(Month, CopyStr(ACHHeader, 72, 2)) and
            Evaluate(Day, CopyStr(ACHHeader, 74, 2))
        then
            SettleDate := DMY2Date(Day, Month, 2000 + Year);
    end;

    local procedure ProcessACHDetail(ACHDetailLine: Text; var BankExtractBuffer: Record "PTE Bank Extract Buffer")
    begin
        BankExtractBuffer."Line No." += 10000;
        BankExtractBuffer.Init();

        BankExtractBuffer."Transaction Number" := CopyStr(ACHDetailLine, 2, 9); // Transaction Code
        BankExtractBuffer."Account Number" := CopyStr(ACHDetailLine, 12, 17); // Payee Transit Routing Number
        BankExtractBuffer."Individual ID" := CopyStr(ACHDetailLine, 40, 15);
        BankExtractBuffer."Individual ID" := CopyStr(RemoveSpacesInEnd(BankExtractBuffer."Individual ID"), 1, MaxStrLen(BankExtractBuffer."Individual ID"));
        BankExtractBuffer."Individual Name" := CopyStr(ACHDetailLine, 55, 22);
        BankExtractBuffer."Individual Name" := CopyStr(RemoveSpacesInEnd(BankExtractBuffer."Individual Name"), 1, MaxStrLen(BankExtractBuffer."Individual Name"));

        BankExtractBuffer.Insert();
    end;

    local procedure ProcessACHAddendaDetail(ACHDetailLine: Text; var BankExtractBuffer: Record "PTE Bank Extract Buffer")
    begin
        BankExtractBuffer."Unique ID" := CopyStr(ACHDetailLine, 64, 10); // Document No
        // External Document No
        // Applies-To Document No
        // Addenda Sequence Number
        // Entry Detail Sequence Number
        BankExtractBuffer.Modify();
    end;

    local procedure ProcessACHFooter(ACHFooter: Text; ACHBatchNo: Code[20]; var BankExtractBuffer: Record "PTE Bank Extract Buffer")
    var
        AmountText: text;
        TmpDec: Decimal;
    begin
        AmountText := CopyStr(ACHFooter, 33, 12);
        if Evaluate(TmpDec, AmountText) then begin
            BankExtractBuffer.SetRange("ACH Batch No.", ACHBatchNo);
            if not BankExtractBuffer.IsEmpty() then
                BankExtractBuffer.ModifyAll(Amount, TmpDec / 100);
        end;
    end;

    local procedure RemoveSpacesInEnd(Str: Text): Text;
    begin
        if StrLen(Str) > 1 then
            while (CopyStr(Str, StrLen(Str)) = ' ') do begin
                Str := CopyStr(Str, 1, StrLen(Str) - 1);
                if (StrLen(Str) <= 1) then
                    break;
            end;
        exit(Str);
    end;

}
