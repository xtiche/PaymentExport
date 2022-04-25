pageextension 50203 "PTE Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    actions
    {
        addafter(ImportBankStatement)
        {
            action("Read Bai2")
            {
                Caption = 'Import BAI2 File';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Image = ElectronicBanking;
                ApplicationArea = All;
                trigger OnAction()
                var
                    BankAccountRecLine: Record "Bank Acc. Reconciliation Line";
                    CsvBuffer: Record "CSV Buffer";
                    Ins: InStream;
                    LineNo: Integer;
                    uploadResult: Boolean;
                    DialogCaption: Text;
                    BaiFileName: Text;
                    ListOf16: List of [Text];
                    ListOfContinuationLine: List of [Text];
                    PrevLineType: Text;
                    PrevLine: Integer;
                    LoopOnLine: Integer;
                    LoopOnContinuation: Integer;
                    TransactionCodeInt: Integer;
                    DecimalText: Text;
                    IntegerText: Text;
                    Int: Decimal;
                    Dec: Decimal;
                    factor: Integer;
                    FundsType: Text;
                    DescriptionPos: Integer;
                    savedColumnValueInt: Integer;
                    element: Text;
                    element16: Text;
                    ListofCon: List of [Text];
                    LoadDescription: Boolean;
                    doempty: Boolean;
                    is16: Boolean;
                    Is2: Boolean;
                    StatementDate: Text;
                    Is3: Boolean;
                    BankAccountNo: Text;


                    Splitted16: List of [Text];
                    SplittedLineNo: Text;

                    DD: Integer;
                    MM: Integer;
                    YY: Integer;
                    DateofStatement: Date;
                    TransactionNo: Code[20];
                    extractbuffer: Record "PTE Bank Extract Buffer";
                    UploadCount: Integer;
                begin
                    UploadCount := 0;
                    uploadResult := UploadIntoStream(DialogCaption, '', '', BaiFileName, Ins);
                    CsvBuffer.DeleteAll();
                    CsvBuffer.LoadDataFromStream(Ins, ',');
                    is16 := false;
                    Is2 := false;
                    Is3 := false;

                    if CsvBuffer.FindSet()
                    then
                        repeat

                            if (CsvBuffer."Field No." = 1) AND (CsvBuffer.Value = '02')
                                                      then begin
                                Is2 := true;
                            end;

                            if (CsvBuffer."Field No." = 5) AND Is2
                                                   then begin
                                StatementDate := CsvBuffer.Value;
                                Is2 := false;
                            end;

                            if (CsvBuffer."Field No." = 1) AND (CsvBuffer.Value = '03')
                            then begin
                                Is3 := true;
                            end;
                            if (CsvBuffer."Field No." = 2) AND Is3
                            then begin
                                BankAccountNo := CsvBuffer.Value;
                                is3 := false;
                            end;


                            if (CsvBuffer."Field No." = 1) AND (CsvBuffer.Value = '88') AND (is16 = true)
                            then begin
                                LoadDescription := true;
                            end;
                            if (CsvBuffer."Field No." = 2) AND is16 ANd LoadDescription then begin
                                ListOfContinuationLine.Add(Format(PrevLine) + '*' + CsvBuffer.Value);
                                is16 := false;
                                LoadDescription := false;
                            end;


                            if (CsvBuffer."Field No." = 1) AND (CsvBuffer.Value = '16')
                            then begin
                                ListOf16.Add(Format(CsvBuffer."Line No.") + '-' + StatementDate + '-' + BankAccountNo);
                                PrevLineType := '16';
                                PrevLine := CsvBuffer."Line No.";
                                is16 := true;

                            end else
                                if is16 = false
                       then begin
                                    PrevLineType := '';
                                    PrevLine := 0;

                                end;

                        until CsvBuffer.Next() = 0;

                    foreach element16 in ListOf16
                    do begin

                        Splitted16 := element16.Split('-');
                        SplittedLineNo := Splitted16.get(1);

                        Evaluate(YY, Splitted16.Get(2).Substring(1, 2));
                        Evaluate(MM, Splitted16.Get(2).Substring(3, 2));
                        Evaluate(DD, Splitted16.Get(2).Substring(5, 2));
                        DateofStatement := DMY2Date(DD, MM, 2000 + YY);
                        BankAccountNo := Splitted16.Get(3);

                        BankAccountRecLine.Init();
                        BankAccountRecLine."Bank Account No." := Rec."Bank Account No.";
                        BankAccountRecLine."Statement No." := Rec."Statement No.";
                        BankAccountRecLine."Statement Type" := BankAccountRecLine."Statement Type"::"Bank Reconciliation";


                        BankAccountRecLine."Transaction Date" := DateofStatement;
                        CsvBuffer.Reset();
                        CsvBuffer.SetFilter(CsvBuffer."Line No.", SplittedLineNo);
                        if CsvBuffer.FindSet() then
                            repeat
                                case CsvBuffer."Field No." of
                                    2:
                                        begin
                                            BankAccountRecLine."Transation Type" := Format(CsvBuffer.Value);
                                            Evaluate(TransactionCodeInt, Format(CsvBuffer.Value));
                                        end;
                                    3:
                                        begin
                                            DecimalText := CopyStr(CsvBuffer.Value, StrLen(CsvBuffer.Value) - 1);
                                            // Decimal part, 2 decimals
                                            IntegerText := CopyStr(CsvBuffer.Value, 1, StrLen(CsvBuffer.Value) - 2); // integer part
                                                                                                                     //      Message('Actual Amount' + DecimalText + ' ' + IntegerText);
                                            if IntegerText <> '' then
                                                Evaluate(Int, IntegerText);
                                            if DecimalText <> '' then
                                                Evaluate(Dec, DecimalText);
                                            factor := 1;
                                            if TransactionCodeInt > 400 then
                                                factor := -1;
                                            BankAccountRecLine."Statement Amount" := (Int + (Dec / 100)) * factor;
                                            BankAccountRecLine.Difference := (Int + (Dec / 100)) * factor;

                                        end;
                                    4:
                                        begin
                                            FundsType := CsvBuffer.Value;
                                            case FundsType of
                                                '', 'e', '1', '2':
                                                    DescriptionPos := 7;
                                                'S':
                                                    DescriptionPos := 10;
                                                'V':
                                                    DescriptionPos := 9;
                                            end;
                                        end;
                                    5:
                                        begin
                                            BankAccountRecLine."Transaction No." := Format(CsvBuffer.Value);
                                            TransactionNo := Format(CsvBuffer.Value);
                                            // Evaluate(savedColumnValueInt, CsvBuffer.Value);
                                            // DescriptionPos := savedColumnValueInt * 2;
                                            // Message('Description= %2\', DescriptionPos);
                                        end;
                                    6:
                                        begin
                                            if TransactionCodeInt IN [474, 1475, 395]
                                            then begin
                                                BankAccountRecLine."Transaction Text" := Delchr(CsvBuffer.Value, '=', '/'); // when the line has no description text, it ends with "/"

                                            end;
                                        end;
                                    9:
                                        begin
                                            if BankAccountRecLine."Transaction Text" = ''
                                            then begin


                                                BankAccountRecLine."Transaction Text" := Delchr(CsvBuffer.Value, '=', '/'); // when the line has no description text, it ends with "/"
                                            end;
                                        end;

                                end;
                                extractbuffer.Reset();
                                extractbuffer.SetFilter("Transaction Number", TransactionNo);
                                extractbuffer.SetFilter("Transaction Code", '%1', Format(TransactionCodeInt));
                                if extractbuffer.FindFirst()
                                then begin
                                    BankAccountRecLine."ACH Batch No." := extractbuffer."ACH Batch No.";
                                end;
                                BankAccountRecLine."Statement Line No." := BankAccountRecLine."Statement Line No." + 10000;
                                FOREACH element IN ListOfContinuationLine DO BEGIN
                                    ListofCon := element.Split('*');
                                    if ListofCon.Get(1) = Format(CsvBuffer."Line No.")
                                    then begin
                                        BankAccountRecLine.Description := ListofCon.Get(2);
                                    end;
                                END;

                            until CsvBuffer.Next() = 0;
                        BankAccountRecLine.Insert();
                        UploadCount := UploadCount + 1;

                    end;
                    if (UploadCount > 0)
                    then begin
                        Rec.SetRange("Statement Type", Rec."Statement Type");
                        Rec.SetRange("Bank Account No.", Rec."Bank Account No.");
                        Rec.SetRange("Statement No.", Rec."Statement No.");
                        REPORT.Run(REPORT::"Match Bank Entries", true, true, Rec);

                    end;
                end;

            }
        }
    }
}
