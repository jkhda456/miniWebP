unit MiniWebp;

// by jkh.

interface

uses
  Windows, SysUtils, Classes, GDIPOBJ;

type
  TWebPDecodeBGRA = function(const data: PByte; data_size: Cardinal; width, height: PInteger): PByte; cdecl;
  TWebPFree = procedure (p : pointer); cdecl;

function loadLibWebP(ALibPath: String): Integer;
function unloadLibWebP: Integer;

function WebPToPng(TargetFile, DestFile: String): Integer;

implementation

const
  gGIf: TGUID = '{557CF402-1A04-11D3-9A73-0000F81EF32E}';
  gPNG: TGUID = '{557CF406-1A04-11D3-9A73-0000F81EF32E}';
  gPJG: TGUID = '{557CF401-1A04-11D3-9A73-0000F81EF32E}';
  gBMP: TGUID = '{557CF400-1A04-11D3-9A73-0000F81EF32E}';
  gTIF: TGUID = '{557CF405-1A04-11D3-9A73-0000F81EF32E}';

var
  libwebp_hwnd: Hwnd = 0;
  WebPDecodeBGRA: TWebPDecodeBGRA = nil;
  WebPFree: TWebPFree = nil;

function loadLibWebP(ALibPath: String): Integer;
begin
  Result := -1;
  If Not FileExists(ALibPath) Then Exit;

  Result := -2;  
  libwebp_hwnd := LoadLibrary(PChar(ALibPath));

  Result := -3;
  If libwebp_hwnd = 0 Then Exit;

  WebPDecodeBGRA := GetProcAddress(libwebp_hwnd, 'WebPDecodeBGRA');
  WebPFree := GetProcAddress(libwebp_hwnd, 'WebPFree');
end;

function unloadLibWebP: Integer;
begin
  If libwebp_hwnd <> 0 Then
     FreeLibrary(libwebp_hwnd);
end;

procedure WebpDecode(fs: TStream; var data: PByte; var bitmap : TGPBitmap);
var
  buffer: String;
  width, height: integer;
begin
  fs.Position := 0;
  setlength(buffer, fs.Size);
  fs.Read(buffer[1], fs.size);
  data := WebPDecodeBGRA(@buffer[1], fs.Size, @width, @height);
  setlength(buffer, 0);
  bitmap := TGPBitmap.Create(width, height, 4 * width, 2498570, data);
end;

function WebPToPng(TargetFile, DestFile: String): Integer;
var
  fs: TFileStream;
  bmp: TGPBitmap;
  dat: PByte;
begin
  bmp := TGPBitmap.Create;
  fs := TFileStream.Create(TargetFile, fmOpenRead);
  Try
     WebpDecode(fs, dat, bmp);
     bmp.Save(DestFile, gPNG);
  Finally
     bmp.Free;
     fs.Free;
     WebPFree(dat);  //
  End;
end;

end.
