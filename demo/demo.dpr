program demo;

{$APPTYPE CONSOLE}

uses
  SysUtils, MiniWebP;

const
  webp_DLL = 'libwebp.dll';

var
  LoopVar: Integer;
  NewFileName: String;
  
begin
  loadLibWebP(webp_DLL);

  If Not MiniWebP.isLibLoaded Then
  Begin
     If MiniWebP.isLibFileExists() Then
        WriteLn('WebP Library (libwebp.dll) not loaded')
     Else
        WriteLn('WebP Library (libwebp.dll) not exists');

     Exit;
  End;

  WriteLn('WebP Library (libwebp.dll) LOADED!');

  If ParamCount < 1 Then
  Begin
     WriteLn(' usage: ' + ExtractFileName(ParamStr(0)) + ' [WebP File] ...');
     Exit;
  End;

  For LoopVar := 1 to ParamCount do
  Begin
     WriteLn('* Convert WebP to PNG : ' + ParamStr(LoopVar));

     If FileExists(ParamStr(LoopVar)) Then
     Begin
        NewFileName := ChangeFileExt(ParamStr(LoopVar), '.png');
        If NewFileName = ParamStr(LoopVar) Then NewFileName := NewFileName + '.new.png';

        WebPToPng(ParamStr(LoopVar), NewFileName);
        WriteLn(' - write new file : ' + NewFileName);
     End
     Else
     Begin
        WriteLn(' - not exists : ' + ParamStr(LoopVar));
     End;
  End;
end.
