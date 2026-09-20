unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  uAuthenticationService, Main; // <-- for IAuthenticationService

type
  TfLogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    GridPanelLayout1: TGridPanelLayout;
    btnExit: TButton;
    btnLogin: TButton;
    Label1: TLabel;
    Label2: TLabel;
    eUserName: TEdit;
    ePassword: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    FAuthService: IAuthenticationService;
  public
    constructor Create(AOwner: TComponent;
      AAuthService: IAuthenticationService); reintroduce;
  end;

implementation

{$R *.fmx}

constructor TfLogin.Create(AOwner: TComponent;
  AAuthService: IAuthenticationService);
begin
  inherited Create(AOwner);
  FAuthService := AAuthService;
end;

procedure TfLogin.btnExitClick(Sender: TObject);
begin
  ModalResult := mrCancel; // cleaner than Application.Terminate for modal form
end;

procedure TfLogin.btnLoginClick(Sender: TObject);
begin
  if FAuthService.Login(eUserName.Text, ePassword.Text) then
    ModalResult := mrOK
  else
  begin
    ShowMessage('Invalid username or password.');
    ePassword.SetFocus;
  end;
end;

end.
