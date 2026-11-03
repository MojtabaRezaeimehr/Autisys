unit dmTherapy;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows,
  FireDAC.UI.Intf, FireDAC.FMXUI.Login,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,FMX.Dialogs;

type
  TdmTherapy_ = class(TDataModule)
    fQryTherapySessions: TFDQuery;
    dsThrapySessions: TDataSource;
    dsTherapists: TDataSource;
    fQryTherapists: TFDQuery;
    dsTherapyTypes: TDataSource;
    fQryTherapyTypes: TFDQuery;
    dsSessions: TDataSource;
    fQrySessions: TFDQuery;
    fQrySessionsId: TFDAutoIncField;
    fQrySessionsClassId: TIntegerField;
    fQrySessionsStartTime: TTimeField;
    fQrySessionsEndTime: TTimeField;
    fQrySessionsTherapistId: TIntegerField;
    fQrySessionsNotes: TWideMemoField;
    fQryTherapistsId: TFDAutoIncField;
    fQryTherapistsFullName: TWideStringField;
    fQryTherapistsSpecialtyId: TIntegerField;
    fQrySessionsTherapyTypeId: TIntegerField;
    fQrySessionsTasks: TWideMemoField;
    fQrySessionsHomeWorks: TWideMemoField;
    fQryTherapyTypesId: TFDAutoIncField;
    fQryTherapyTypesTitle: TWideStringField;
    fQryRooms: TFDQuery;
    fQryRoomsid: TFDAutoIncField;
    fQryRoomsRoomName: TWideStringField;
    fQrySessionsPatientId: TIntegerField;
    fQryPriodicalTests: TFDQuery;
    fQryPriodicalTestsid: TIntegerField;
    fQryPriodicalTestsPatinetId: TIntegerField;
    fQryPriodicalTestsTherapistId: TIntegerField;
    fQryPriodicalTestsDateYear: TIntegerField;
    fQryPriodicalTestsDateMonth: TIntegerField;
    fQryPriodicalTestsDateDay: TIntegerField;
    fQryPriodicalTestsGrade: TIntegerField;
    fQryPriodicalTestsNotes: TWideMemoField;
    fQryPatientsRep: TFDQuery;
    fQryPatientsRepId: TFDAutoIncField;
    fQryPatientsRepPatientFullname: TWideStringField;
    fQryPatientsRepClassName: TWideStringField;
    fQryPatientsReptherapyName: TWideStringField;
    fQryPatientsRepSessionDate: TDateField;
    fQryPatientsRepStartTime: TTimeField;
    fQryPatientsRepEndTime: TTimeField;
    fQryPatientsRepTherapistFullName: TWideStringField;
    fQryPatientsRepTasks: TWideMemoField;
    fQryPatientsRepHomeWorks: TWideMemoField;
    fQryPatientsRepNotes: TWideMemoField;
    fQryPatientsRepSessionDate_fa: TWideStringField;
    fQryTherapySessionsId: TIntegerField;
    fQryTherapySessionsTherapyName: TWideStringField;
    fQryTherapySessionsTherapistName: TWideStringField;
    fQryTherapySessionsPatientName: TWideStringField;
    fQryTherapySessionsSessionDate: TWideStringField;
    fQryTherapySessionsStartTime: TTimeField;
    fQryTherapySessionsEndDate: TTimeField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTherapy_: TdmTherapy_;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses dmServer;

{$R *.dfm}

procedure TdmTherapy_.DataModuleCreate(Sender: TObject);
var
  i: integer;
  Q: TFDQuery;
begin
  for i := 0 to ComponentCount-1 do
    if Components[i] is TFDQuery then
    begin
      Q := Components[i] as TFDQuery;
      Q.Connection := dmServer_.FdServerConnection;
      // Fetch everything at open so no cursor stays open on the shared connection
      Q.FetchOptions.Mode := fmAll;
//      showmessage(q.Name);
      try
        Q.Active := True;
      except
        on E: Exception do
          OutputDebugString(PChar('dmTherapy: failed to open ' + Q.Name + ': ' + E.Message));
      end;
    end;
end;

end.
