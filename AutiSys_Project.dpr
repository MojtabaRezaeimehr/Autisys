program AutiSys_Project;

uses
  System.StartUpCopy,
  System.SysUtils,
  System.UITypes,
  FMX.Forms,
  FMX.Dialogs,
  Main in 'Main.pas' {fMainScreen},
  uLogin in 'forms\uLogin.pas' {fLogin},
  uProfile in 'forms\uProfile.pas' {fProfile},
  dmServer in 'data\dmServer.pas' {dmServer_: TDataModule},
  dmPatients in 'data\dmPatients.pas' {dmPatints: TDataModule},
  dmTherapy in 'data\dmTherapy.pas' {dmTherapy_: TDataModule},
  uSessionDetails in 'forms\uSessionDetails.pas' {Form1},
  dmAccounting in 'data\dmAccounting.pas' {dmAccounting_: TDataModule},
  dmEvents in 'data\dmEvents.pas' {dmEvents_: TDataModule},
  uFunctions in 'utils\uFunctions.pas',
  uJalaliCalendar in 'utils\PersianDate_Component\uJalaliCalendar.pas',
  uSimpleDatePicker in 'utils\uSimpleDatePicker.pas',
  uUserRepository in 'utils\uUserRepository.pas',
  uUserRepository.FireDAC in 'utils\uUserRepository.FireDAC.pas',
  uAuthenticationService in 'utils\uAuthenticationService.pas',
  uPatientRepository in 'utils\uPatientRepository.pas',
  uPatientRepository.FireDAC in 'utils\uPatientRepository.FireDAC.pas',
  uPatientService in 'utils\uPatientService.pas',
  uDbMigration in 'utils\uDbMigration.pas',
  dmBaseData in 'data\dmBaseData.pas' {dmBaseData: TDataModule},
  uBaseData in 'forms\uBaseData.pas' {fBaseData};

{$R *.res}

var
  UserRepo: IUserRepository;
  AuthService: IAuthenticationService;
  PatientRepo: IPatientRepository;
  PatientService: IPatientService;
  LoginForm: TfLogin;

begin
  Application.Initialize;

  // 1. Create and configure the data module manually
  dmServer_ := TdmServer_.Create(nil);
  try
    dmServer_.FdServerConnection.DriverName := 'MSSQL';
    dmServer_.FdServerConnection.Params.Values['Server']    := 'localhost';
    dmServer_.FdServerConnection.Params.Values['Database']  := 'AutiSys';
    dmServer_.FdServerConnection.Params.Values['User_Name'] := 'sa';
    dmServer_.FdServerConnection.Params.Values['Password']  := 'amf@sql2022';
    dmServer_.FdServerConnection.LoginPrompt := False;
    // NOTE: MARS deliberately disabled. All queries use fmAll fetch (full fetch,
    // cursor released at open), so multiple active result sets are not needed
    // and MARS itself can trigger 'Connection is busy' with ODBC Driver 17.
    try
      dmServer_.FdServerConnection.Connected := True;
    except
      on E: Exception do
      begin
        ShowMessage('خطا در اتصال به پایگاه داده:' + sLineBreak + E.Message);
        Exit; // dmServer_ is freed by the outer finally — do NOT free it here
      end;
    end;

    // ── DB Migrations ────────────────────────────────────────────────
    with TDbMigrator.Create(dmServer_.FdServerConnection) do
    try
      // Add new migrations here — already-applied ones are skipped.
      // Add(version, 'description', 'SQL script');

      Add(1, 'Add CreatedAt to Patients',
        'ALTER TABLE Patients ADD CreatedAt DATETIME2 NOT NULL ' +
        'CONSTRAINT DF_Patients_CreatedAt DEFAULT GETDATE()');

      Add(2, 'Add UpdatedAt to Patients',
        'ALTER TABLE Patients ADD UpdatedAt DATETIME2 NOT NULL ' +
        'CONSTRAINT DF_Patients_UpdatedAt DEFAULT GETDATE()');

      Add(3, 'Auto-update UpdatedAt on Patients via trigger',
        'CREATE OR ALTER TRIGGER trg_Patients_UpdatedAt ' +
        'ON Patients AFTER UPDATE AS ' +
        'BEGIN ' +
        '  SET NOCOUNT ON; ' +
        '  UPDATE Patients SET UpdatedAt = GETDATE() ' +
        '  FROM Patients p INNER JOIN inserted i ON p.Id = i.Id; ' +
        'END');

      Add(4, 'Add CreatedAt to Therapists',
        'ALTER TABLE Therapists ADD CreatedAt DATETIME2 NOT NULL ' +
        'CONSTRAINT DF_Therapists_CreatedAt DEFAULT GETDATE()');

      Add(5, 'Add UpdatedAt to Therapists',
        'ALTER TABLE Therapists ADD UpdatedAt DATETIME2 NOT NULL ' +
        'CONSTRAINT DF_Therapists_UpdatedAt DEFAULT GETDATE()');

      Add(6, 'Auto-update UpdatedAt on Therapists via trigger',
        'CREATE OR ALTER TRIGGER trg_Therapists_UpdatedAt ' +
        'ON Therapists AFTER UPDATE AS ' +
        'BEGIN ' +
        '  SET NOCOUNT ON; ' +
        '  UPDATE Therapists SET UpdatedAt = GETDATE() ' +
        '  FROM Therapists t INNER JOIN inserted i ON t.Id = i.Id; ' +
        'END');

      Run;
    finally
      Free;
    end;
    // ─────────────────────────────────────────────────────────────────
    // 2. Create repositories and services
    UserRepo := TFireDACUserRepository.Create(dmServer_.FdServerConnection);
    AuthService := TAuthenticationService.Create(UserRepo);

    PatientRepo := TFireDACPatientRepository.Create(dmServer_.FdServerConnection);
    PatientService := TPatientService.Create(PatientRepo);

    // 3. Show login form
    LoginForm := TfLogin.Create(nil, AuthService);
    try
      if LoginForm.ShowModal = mrOK then
      begin
        // 4. Create main form MANUALLY with injected service
        fMainScreen := TfMainScreen.Create(nil, PatientService);
        fMainScreen.Show;
        Application.Run;
      end;
    finally
      LoginForm.Free;
    end;
  finally
    dmServer_.Free;
  end;
end.
