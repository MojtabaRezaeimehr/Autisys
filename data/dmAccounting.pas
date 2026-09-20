unit dmAccounting;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmAccounting_ = class(TDataModule)
    fQryTransactionTypes: TFDQuery;
    fQryTransactions: TFDQuery;
    fQryTransactionsId: TFDAutoIncField;
    fQryTransactionsPatientId: TIntegerField;
    fQryTransactionsPaymentDate_Year: TIntegerField;
    fQryTransactionsPaymentDate_Month: TIntegerField;
    fQryTransactionsPaymentDate_Day: TIntegerField;
    fQryTransactionsAmount: TIntegerField;
    fQryTransactionsTransactionType_Id: TIntegerField;
    fQryTransactionsNotes: TWideMemoField;
    fQryTransactionsRep: TFDQuery;
    fQryTransactionsRepId: TFDAutoIncField;
    fQryTransactionsRepPatientId: TIntegerField;
    fQryTransactionsRepPatientFullName: TWideStringField;
    fQryTransactionsRepAmount: TIntegerField;
    fQryTransactionsRepTransactionType_Id: TIntegerField;
    fQryTransactionsRepTitle: TWideStringField;
    fQryTransactionsRepNotes: TWideMemoField;
    fQryTransactionsRepPaymentDate: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmAccounting_: TdmAccounting_;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses dmServer;

{$R *.dfm}

procedure TdmAccounting_.DataModuleCreate(Sender: TObject);
var
  i: integer;
  Q: TFDQuery;
begin
  for i := 0 to ComponentCount-1 do
    if Components[i] is TFDQuery then
    begin
      Q := Components[i] as TFDQuery;
      Q.Connection := dmServer_.FdServerConnection;
      try
        Q.Active := True;
      except
        on E: Exception do
          OutputDebugString(PChar('dmAccounting: failed to open ' + Q.Name + ': ' + E.Message));
      end;
    end;
end;

end.
