unit UEstruturaDados;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TUsuario = record
    UserID: integer;
    Username: string;
    Role: string;
    Status: string;
  end;

implementation

end.
