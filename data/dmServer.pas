unit dmServer;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TdmServer_ = class(TDataModule)
    FdServerConnection: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmServer_: TdmServer_;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
