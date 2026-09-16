unit uAuthenticationService;

interface

uses
  System.SysUtils, uUserRepository;

type
  IAuthenticationService = interface
    ['{69731C8A-47C0-445F-8A89-EEFB789F9BFB}']
    // Press Ctrl+Shift+G in Delphi to generate a unique GUID
    function login(const UserName, Password: string): Boolean;
  end;

  TAuthenticationService = class(TInterfacedObject, IAuthenticationService)
  private
    FUserRepository: IUserRepository;
  public
    constructor create(AUserRepository: IUserRepository);
    function login(const UserName, Password: string): Boolean;
  end;

implementation

{ TAuthenticationService }

constructor TAuthenticationService.create(AUserRepository: IUserRepository);
begin
  inherited create;
  FUserRepository := AUserRepository;
end;

function TAuthenticationService.login(const UserName, Password: string)
  : Boolean;
begin
  // Business rule: both username and password must be non-empty
  if (Trim(UserName) = '') or (Trim(Password) = '') then
    Exit(False);

  // Delegate credential validation to the repository
  Result := FUserRepository.ValidateCredentials(UserName, Password);
end;

end.
