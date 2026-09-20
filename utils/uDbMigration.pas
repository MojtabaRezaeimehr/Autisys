unit uDbMigration;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client;

type
  TDbMigration = record
    Version: Integer;
    Description: string;
    Script: string;
  end;

  TDbMigrator = class
  private
    FConnection: TFDConnection;
    FMigrations: TList<TDbMigration>;
    procedure EnsureMigrationsTable;
    function IsApplied(AVersion: Integer): Boolean;
    procedure MarkApplied(AVersion: Integer; const ADescription: string);
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Add(AVersion: Integer; const ADescription, AScript: string);
    procedure Run;
  end;

implementation

{ TDbMigrator }

constructor TDbMigrator.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
  FMigrations := TList<TDbMigration>.Create;
end;

destructor TDbMigrator.Destroy;
begin
  FMigrations.Free;
  inherited;
end;

procedure TDbMigrator.Add(AVersion: Integer; const ADescription, AScript: string);
var
  M: TDbMigration;
begin
  M.Version     := AVersion;
  M.Description := ADescription;
  M.Script      := AScript;
  FMigrations.Add(M);
end;

procedure TDbMigrator.EnsureMigrationsTable;
begin
  FConnection.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = ''DbMigrations'') ' +
    'CREATE TABLE DbMigrations (' +
    '  Version     INT          NOT NULL PRIMARY KEY,' +
    '  Description NVARCHAR(255) NOT NULL,' +
    '  AppliedAt   DATETIME     NOT NULL DEFAULT GETDATE()' +
    ')'
  );
end;

function TDbMigrator.IsApplied(AVersion: Integer): Boolean;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text   := 'SELECT COUNT(1) FROM DbMigrations WHERE Version = :V';
    Q.ParamByName('V').AsInteger := AVersion;
    Q.Open;
    Result := Q.Fields[0].AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure TDbMigrator.MarkApplied(AVersion: Integer; const ADescription: string);
begin
  FConnection.ExecSQL(
    'INSERT INTO DbMigrations (Version, Description) VALUES (:V, :D)',
    [AVersion, ADescription]
  );
end;

procedure TDbMigrator.Run;
var
  M: TDbMigration;
begin
  EnsureMigrationsTable;
  for M in FMigrations do
  begin
    if not IsApplied(M.Version) then
    begin
      FConnection.ExecSQL(M.Script);
      MarkApplied(M.Version, M.Description);
    end;
  end;
end;

end.
