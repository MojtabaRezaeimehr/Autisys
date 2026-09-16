unit uUserRepository;

interface

type
  IUserRepository = interface
    ['{80D4C94A-1227-4F02-9776-FB50C47B47B8}']
    function ValidateCredentials(Const Username,Password: string): Boolean;
  end;
implementation

end.
