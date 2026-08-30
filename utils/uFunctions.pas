unit uFunctions;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Param,
  FireDAC.Comp.Client;

/// <summary>
/// Executes a SQL statement with optional parameters and returns the
/// resulting TFDQuery.  For SELECT statements the query is opened
/// automatically; for UPDATE/INSERT/DELETE you can set <c>ASkipExecute</c>
/// to True and call <c>ExecSQL</c> yourself.
/// </summary>
/// <param name="AConnection">The FireDAC connection to use.</param>
/// <param name="ASQL">The SQL statement (may contain parameters).</param>
/// <param name="AParams">Optional parameter values (in order).</param>
/// <param name="ASkipExecute">If True, the query is not opened/executed.</param>
/// <returns>A reference to the created TFDQuery.  Caller must free it.</returns>
function RunSQLQuery(const AConnection: TFDConnection;
                     const ASQL: string;
                     const AParams: array of string;
                     const ASkipExecute: Boolean = False): TFDQuery;

implementation



function RunSQLQuery(const AConnection: TFDConnection;
                     const ASQL: string;
                     const AParams: array of string;
                     const ASkipExecute: Boolean = False): TFDQuery;
var
  Q: TFDQuery;
  i: Integer;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text   := ASQL;

    // Set parameters if any were supplied
    if Length(AParams) > 0 then
    begin
      if Length(AParams) <> Q.Params.Count then
        raise Exception.CreateFmt('Expected %d parameters, got %d.',
                                  [Q.Params.Count, Length(AParams)]);
      for i := 0 to High(AParams) do
        Q.Params[i].Value := AParams[i];  // تبدیل صحیح
    end;

    // Execute (Open for SELECT, ExecSQL for non‑SELECT if desired)
    if not ASkipExecute then
      Q.Open;      // برای SELECT؛ برای UPDATE/INSERT/DELETE فراخوانی ExecSQL در خارج

    Result := Q;   // مالکیت را به caller می‌دهیم
  except
    Q.Free;
    raise;          // خطا را دوباره پرتاب می‌کنیم
  end;
end;

end.   { unit uFunctions }
