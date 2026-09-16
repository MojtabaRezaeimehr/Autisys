unit uUserRepository.FireDAC;

interface

uses
  uUserRepository, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TFireDACUserRepository = class(TInterfacedObject, IUserRepository)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function ValidateCredentials(const Username, Password: string): Boolean;
  end;

implementation

{ TFireDACUserRepository }

constructor TFireDACUserRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TFireDACUserRepository.ValidateCredentials(const Username,
  Password: string): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.sql.Text :=
      'SELECT COUNT(*) FROM Users WHERE Username=:u AND PasswordHash=:p';
    Query.ParamByName('u').AsString := Username;
    Query.ParamByName('p').AsString := Password;
    Query.Open;
    Result := Query.Fields[0].AsInteger > 0;
  finally
    Query.Free;
  end;
end;

end.
