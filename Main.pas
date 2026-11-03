
unit Main;
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FireDAC.Stan.Param,
  FireDAC.Comp.Client,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, dmPatients, uFunctions, dmServer,
  dmTherapy, dmAccounting, uPatientService;

type
  TfMainScreen = class(TForm)
    Panel1: TPanel;
    btnNewMember: TButton;
    btnNewTransaction: TButton;
    btnNewSession: TButton;
    btnReports: TButton;
    btnSettings: TButton;
    grpNationalCode: TGroupBox;
    lblNationalCode: TLabel;
    btnSearch: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    edtPatientsCount: TEdit;
    Panel4: TPanel;
    lblPouyeshha: TLabel;
    Edit3: TEdit;
    Panel5: TPanel;
    Label3: TLabel;
    edtAllTransactions: TEdit;
    Panel6: TPanel;
    Label4: TLabel;
    edtNewMembersCount: TEdit;
    btnExit: TButton;
    Panel8: TPanel;
    Panel7: TPanel;
    lblSpacer: TLabel;
    lblVersion: TLabel;
    edtNationalCode: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewMemberClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnNewSessionClick(Sender: TObject);
    procedure btnNewTransactionClick(Sender: TObject);
    procedure btnReportsClick(Sender: TObject);
  private
    { Private declarations }
    FPatientService: IPatientService;
  public
    constructor Create(AOwner: TComponent; APatientService: IPatientService);
      reintroduce;
    { Public declarations }
  end;

var
  fMainScreen: TfMainScreen;

implementation

{$R *.fmx}

uses uProfile, uBaseData;

function GetAppVersion: string;
var
  Ver: Cardinal;
begin
  // Reads the version from the executable's version info resource.
  // Returns the packed high 32 bits: major version in the high word,
  // minor version in the low word.
  Ver := System.SysUtils.GetFileVersion(ParamStr(0));
  Result := Format('%d.%d', [Ver shr 16, Ver and $FFFF]);
end;

procedure TfMainScreen.btnNewSessionClick(Sender: TObject);
var
  Profile: TfProfile;
begin
  Profile := TfProfile.Create(nil);
  try
    Profile.OpenForNewSession;
    Profile.ShowModal;
    edtPatientsCount.Text := FPatientService.GetPatientCount.ToString;
  finally
    Profile.Free;
  end;
end;

procedure TfMainScreen.btnNewTransactionClick(Sender: TObject);
var
  Profile: TfProfile;
begin
  Profile := TfProfile.Create(nil);
  try
    Profile.OpenForNewTransaction;
    Profile.ShowModal;
    edtPatientsCount.Text := FPatientService.GetPatientCount.ToString;
  finally
    Profile.Free;
  end;
end;

procedure TfMainScreen.btnReportsClick(Sender: TObject);
begin
  ShowMessage('گزارشات در نسخه‌های آتی اضافه خواهد شد.');
end;

procedure TfMainScreen.btnSettingsClick(Sender: TObject);
begin
  with TfBaseData.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfMainScreen.btnNewMemberClick(Sender: TObject);
var
  Profile: TfProfile;
begin
  Profile := TfProfile.Create(nil);
  try
    Profile.OpenForNewPatient;
    Profile.ShowModal;
    edtPatientsCount.Text := FPatientService.GetPatientCount.ToString;
  finally
    Profile.Free;
  end;
end;

procedure TfMainScreen.btnExitClick(Sender: TObject);
begin
  // if MessageDlg('', TMsgDlgType.mtConfirmation,
  // [mbYes, mbNo],0) = mrYes then
  Application.Terminate;

end;

procedure TfMainScreen.btnSearchClick(Sender: TObject);
var
  sNationalCode: string;
  Q: TFDQuery;
  PatientID: Integer;
begin
  sNationalCode := Trim(edtNationalCode.Text);

  if sNationalCode = '' then
    Exit; // leave the whole procedure, not just this block

  Q := RunSQLQuery(dmServer_.FdServerConnection,
    'SELECT Id FROM Patients WHERE NationalCode = :NationalCode',
    [sNationalCode]); // آرایه‌ی const

    try
      // اگر رکوردی برگشت نداد، پیام خطا
      if Q.IsEmpty then
      begin
        ShowMessage('!توانجو با این کد ملی پیدا نشد');
        Exit;
      end;

      // دریافت Id (فرض می‌کنیم ستون اولین ستون است)
      PatientID := Q.Fields[0].AsInteger;
    finally
      Q.Free; // آزادسازی شیء بعد از اتمام
    end;

  // ------------------------------------------------------------------
  // 2. نمایش فرم پروفایل بیمار
  // ------------------------------------------------------------------
  with TfProfile.Create(nil) do
    try
      // Guard: data modules must exist
      if not Assigned(dmPatints) then
      begin
        ShowMessage('dmPatints is not created.');
        Exit;
      end;
      if not Assigned(dmTherapy_) then
      begin
        ShowMessage('dmTherapy_ is not created.');
        Exit;
      end;
      if not Assigned(dmAccounting_) then
      begin
        ShowMessage('dmAccounting_ is not created.');
        Exit;
      end;

      // 1. Locate in datasets (each guarded)

      // fQryPatients -> Id
      if Assigned(dmPatints.fQryPatients) and dmPatints.fQryPatients.Active and
        Assigned(dmPatints.fQryPatients.FindField('Id')) then
        dmPatints.fQryPatients.Locate('Id', PatientID, []);

      // fQryParents -> PatientId
      if Assigned(dmPatints.fQryParents) and dmPatints.fQryParents.Active and
        Assigned(dmPatints.fQryParents.FindField('PatientId')) then
        dmPatints.fQryParents.Locate('PatientId', PatientID, []);

      // fQrySessions -> PatientId
      if Assigned(dmTherapy_.fQrySessions) and
        dmTherapy_.fQrySessions.Active and
        Assigned(dmTherapy_.fQrySessions.FindField('PatientId')) then
        dmTherapy_.fQrySessions.Locate('PatientId', PatientID, []);

      // fQryTransactions -> PatientId
      if Assigned(dmAccounting_.fQryTransactions) and
        dmAccounting_.fQryTransactions.Active and
        Assigned(dmAccounting_.fQryTransactions.FindField('PatientId')) then
        dmAccounting_.fQryTransactions.Locate('PatientId', PatientID, []);

      // fQryTransactionsRep -> PatientId
      if Assigned(dmAccounting_.fQryTransactionsRep) and
        dmAccounting_.fQryTransactionsRep.Active and
        Assigned(dmAccounting_.fQryTransactionsRep.FindField('PatientId')) then
        dmAccounting_.fQryTransactionsRep.Locate('PatientId', PatientID, []);

      // 2. Show form modal
      ShowModal;
      // Refresh patient count after profile form closes
      edtPatientsCount.Text := FPatientService.GetPatientCount.ToString;
    finally
      Free;
    end;
end;

constructor TfMainScreen.Create(AOwner: TComponent;
  APatientService: IPatientService);
begin
  inherited Create(AOwner);
  FPatientService := APatientService;
end;

procedure TfMainScreen.FormCreate(Sender: TObject);
begin
  dmPatints := TdmPatints.Create(Self);
  dmTherapy_ := TdmTherapy_.Create(Self);
  dmAccounting_ := TdmAccounting_.Create(Self);
  edtPatientsCount.Text := FPatientService.GetPatientCount.ToString;
  edtNewMembersCount.Text := edtPatientsCount.Text;
  lblVersion.Text := 'v' + GetAppVersion;
end;

procedure TfMainScreen.FormResize(Sender: TObject);
begin
  // Use 'Self' or just the property name directly.
  // Do not use the global variable name 'fMainScreen' inside the form class.
  lblSpacer.Width := Self.Width / 5;
  // OR simply:
  // lblSpacer.Width := Width / 5;
end;

procedure TfMainScreen.FormShow(Sender: TObject);
begin
  edtNationalCode.SetFocus;
end;

end.
