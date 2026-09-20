unit dmBaseData;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmBaseData = class(TDataModule)
    fQryTherapists: TFDQuery;
    fQryTherapistsId: TFDAutoIncField;
    fQryTherapistsFirstName: TWideStringField;
    fQryTherapistsLastName: TWideStringField;
    fQryTherapistsBirthYear: TIntegerField;
    fQryTherapistsBirthMonth: TIntegerField;
    fQryTherapistsBirthDay: TIntegerField;
    fQryTherapistsPhone: TWideStringField;
    fQryTherapistsAddress: TWideStringField;
    fQryTherapistsSpecialtyId: TIntegerField;
    dsTherapists: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
  end;

var
  dmBaseData_: TdmBaseData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses dmServer;

{$R *.dfm}

procedure TdmBaseData.DataModuleCreate(Sender: TObject);
var
  i: Integer;
  Q: TFDQuery;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TFDQuery then
    begin
      Q := Components[i] as TFDQuery;
      Q.Connection := dmServer_.FdServerConnection;
      try
        Q.Active := True;
      except
        on E: Exception do
          OutputDebugString(PChar('dmBaseData: failed to open ' + Q.Name + ': ' + E.Message));
      end;
    end;
end;

end.
