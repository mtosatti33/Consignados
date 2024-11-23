unit uConfiguration;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

const
  DB_CONFIG = 'database_config';
  INI_FILE = 'Consignado.ini';


type
  TIniStrings = record
    database: string;
    protocol: string;
    habilitado: Boolean;
  end;

function ReadIniFile: TIniStrings;

var
  ini: TIniFile;

implementation

function ReadIniFile: TIniStrings;
var
  iniStrings: TIniStrings;
begin
  ini := TIniFile.Create(INI_FILE);
  try
    iniStrings.database := ini.ReadString(DB_CONFIG, 'database', iniStrings.database);
    iniStrings.protocol := ini.ReadString(DB_CONFIG, 'protocol', iniStrings.protocol);
    iniStrings.habilitado := ini.ReadBool(DB_CONFIG, 'habilitado', iniStrings.habilitado);
  finally
    ini.Free;
  end;

  Result := iniStrings;
end;

end.

