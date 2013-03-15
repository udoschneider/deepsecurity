#define MyAppVer gemVersion+".0"
#define MyAppVerText gemVersion+".0"
#define MyAppCopyright "Udo Schneider <Udo_Schneider@trendmicro.de>" 
#define MyAppCompany "Trend Micro" 
#define MyAppName "dsc" 

; #define gemVersion "0.0.16"
; #define gemFilename "deepsecurity-"+gemVersion+".gem"

; #define rubyVersion "1.9.3-p392"
#define rubyFilename "rubyinstaller-"+rubyVersion+".exe"
#define rubyUrl = "http://rubyforge.org/frs/download.php/76798/rubyinstaller-"+rubyVersion+".exe"

[Setup]
DefaultDirName={pf}\{#MyAppCompany}\{#MyAppName}
InternalCompressLevel=ultra
; OutputDir={#BaseDir}
; SourceDir={#BaseDir}
SolidCompression=true
AppCopyright=Copyright � {#MyAppCopyright}
AppName={#MyAppName}
AppVerName={#MyAppName} {#MyAppVerText}
ShowLanguageDialog=yes
DefaultGroupName={#MyAppCompany}\{#MyAppName}
AppID=84EDC400-BEB5-446E-90F8-6A9FBF89C3CD
Uninstallable=false
OutputBaseFilename={#MyAppName}_setup_{#MyAppVerText}
;WizardImageFile=Sources\WizardBigImage.bmp
;WizardSmallImageFile=Sources\WizardSmallImage.bmp
WizardImageFile=compiler:wizmodernimage-IS.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp
VersionInfoVersion={#MyAppVer}
VersionInfoCompany={#MyAppCompany}
VersionInfoDescription={#MyAppName} Setup
VersionInfoTextVersion={#MyAppVerText}
VersionInfoCopyright={#MyAppCopyright}
AppPublisher={#MyAppCompany}
AppPublisherURL=http://www.trendmicro.de/
AppSupportURL=http://www.trendmicro.de/
AppVersion={#MyAppVerText}
UninstallDisplayName={#MyAppName}
AppContact={#MyAppCompany}
AppSupportPhone=+49 (811) 88 99 0 698
ChangesAssociations=true
RestartIfNeededByRun=false

[Types]
Name: full; Description: {cm:fullInstallation}
Name: custom; Description: {cm:customInstallation}; Flags: iscustom

[Components]
Name: deepsecurity_gem; Description: deepsecurity gem ({#gemVersion}); Types: custom full
Name: ruby; Description: Ruby ({#rubyVersion}); Types: custom full; ExtraDiskSpaceRequired: 72204063 

[Files]
Source: "isxdl.dll"; Flags: dontcopy
Source: "WizModernImage.bmp"; DestDir: "{app}"; Flags: ignoreversion
Source: "WizModernImage-IS.bmp"; DestDir: "{app}"; Flags: ignoreversion
Source: "WizModernSmallImage.bmp"; DestDir: "{app}"; Flags: ignoreversion
Source: "WizModernSmallImage-IS.bmp"; DestDir: "{app}"; Flags: ignoreversion


[Icons]

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: compiler:Languages\German.isl

[Run]
Filename: "{tmp}\{#rubyFilename}"; Parameters: "/SILENT /TASKS=""MODPATH"""; StatusMsg: "{cm:installingRuby}"; Components: ruby
Filename: "{cmd}"; Parameters: "/C C:\Ruby193\bin\gem install --no-rdoc --no-ri deepsecurity -v {#gemVersion}"; StatusMsg: "{cm:installingGem}"; Components: deepsecurity_gem
; Flags: runhidden

[CustomMessages]
en.fullInstallation=Full Installation
en.customInstallation=Custom Installation
en.installingRuby=Installing Ruby
en.installingGem=Installing gem
de.fullInstallation=Komplette Installation
de.customInstallation=Angepasste Installation
de.installingRuby=Installiere Ruby
de.installingGem=Installiere gem

[ISSI]
; #define ISSI_UnZip1 gemZipFilename
#define ISSI_IncludePath "C:\ISSI"
#include ISSI_IncludePath+"\_issi.isi"
; include "C:\Program Files\Sherlock Software\InnoTools\Downloader\it_download.iss";

;#include ReadReg(HKEY_LOCAL_MACHINE,'Software\Sherlock Software\InnoTools\Downloader','ScriptPath','');

[Tasks]

[Code]
var
  FilesDownloaded: Boolean;

procedure isxdl_AddFile(URL, Filename: AnsiString);
external 'isxdl_AddFile@files:isxdl.dll stdcall';
function isxdl_DownloadFiles(hWnd: Integer): Integer;
external 'isxdl_DownloadFiles@files:isxdl.dll stdcall';
function isxdl_SetOption(Option, Value: AnsiString): Integer;
external 'isxdl_SetOption@files:isxdl.dll stdcall';

procedure DownloadFiles(Ruby: Boolean);
var
  hWnd: Integer;
  URL, FileName: String;
begin
  isxdl_SetOption('label', 'Downloading extra files');
  isxdl_SetOption('description', 'Please wait while Setup is downloading extra files to your computer.');

  try
    FileName := ExpandConstant('{tmp}\WizModernSmallImage-IS.bmp');
    if not FileExists(FileName) then
      ExtractTemporaryFile(ExtractFileName(FileName));
    isxdl_SetOption('smallwizardimage', FileName);
  except
  end;

  //turn off isxdl resume so it won't leave partially downloaded files behind
  //resuming wouldn't help anyway since we're going to download to {tmp}
  isxdl_SetOption('resume', 'false');

  hWnd := StrToInt(ExpandConstant('{wizardhwnd}'));
  
  if Ruby then begin
    URL := '{#rubyUrl}';
    FileName := ExpandConstant('{tmp}\{#rubyFilename}');
    isxdl_AddFile(URL, FileName);
  end;



  if isxdl_DownloadFiles(hWnd) <> 0 then
    FilesDownloaded := True
  else
    SuppressibleMsgBox('Setup could not download the extra files. Try again later or download and install the extra files manually.' + #13#13 + 'Setup will now continue installing normally.', mbError, mb_Ok, idOk);
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  downloadRuby: Boolean;
begin
  downloadRuby := IsComponentSelected('ruby');
  DownloadFiles(downloadRuby);
  Result := '';
end;
