; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "GameClass3"
#define MyAppVersion "3.85.2.10.3"
#define MyAppPublisher "numb"
#define MyAppURL "http://forum.nodasoft.com/"
#define MyAppExeName "GCServer.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppID={{7839CB0E-335D-4D61-A7C3-42CD12DE2492}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\GameClass3
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=gc3setup.{#MyAppVersion}
Compression=lzma/Max
SolidCompression=true
ShowLanguageDialog=no
OutputDir=C:\Projects\Free\Output\Setup
WizardImageFile=c:\Projects\Free\Res\Installer.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Types] 
Name: custom; Description: ���������; Flags: iscustom

[Components]
Name: Client; Description: ���������� �����; Flags: exclusive
Name: Operator; Description: ������������ �����; Flags: exclusive

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: C:\Projects\Free\Install\src\Packages\Client\*.*; DestDir: {app}\Client; Flags: ignoreversion recursesubdirs createallsubdirs; Components: Client
Source: C:\Projects\Free\Install\src\Packages\Server\*.*; DestDir: {app}; Flags: ignoreversion recursesubdirs createallsubdirs; Components: Operator



[Icons]
Name: {group}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Components: Operator; 

[Run]
Filename: {app}\Client\gcclsrv.exe; Parameters: "-install -silent"; Components: Client; 
Filename: net; Parameters: "start gcclsrv"; Flags: RunHidden; Components: Client; 
Filename: netsh; Parameters: "firewall add allowedprogram ""{app}\Client\gccl.exe"" GCClient ENABLE"; Flags: RunHidden; Components: Client; 
Filename: netsh; Parameters: "firewall add allowedprogram ""{app}\Client\gcclsrv.exe"" GCClientService ENABLE"; Flags: RunHidden; Components: Client; 

[Registry]
Root: HKLM; SubKey: SOFTWARE\GameClass3\Client; ValueType: string; ValueName: Installation; ValueData: -1; Flags: UninsDeleteKey deletekey; Components: Client
Root: HKLM; SubKey: SOFTWARE\GameClass3\Client; ValueType: string; ValueName: InstallDirectory; ValueData: {app}; Flags: UninsDeleteKey deletekey; Components: Client
Root: HKLM; SubKey: SOFTWARE\GameClass3\Client; ValueType: string; ValueName: CurrentVersion; ValueData: {#MyAppVersion}; Flags: UninsDeleteKey deletekey; Components: Client
Root: HKLM; SubKey: SOFTWARE\Microsoft\Windows\CurrentVersion\Run; ValueType: string; ValueName: "GameClass Client"; ValueData: """{app}\gccl.exe"""; Flags: UninsDeleteValue deletekey ; Components: Client 
Root: HKLM; SubKey: SOFTWARE\Microsoft\Windows\CurrentVersion\Run; ValueType: string; ValueName: gccl; ValueData: gccl.exe; Flags: UninsDeleteValue deletekey ; Components: Client

Root: HKLM; SubKey: SOFTWARE\GameClass3\Server; ValueType: string; ValueName: Installation; ValueData: -1; Flags: UninsDeleteKey deletekey; Components: Operator
Root: HKLM; SubKey: SOFTWARE\GameClass3\Server; ValueType: string; ValueName: InstallDirectory; ValueData: {app}; Flags: UninsDeleteKey deletekey; Components: Operator
Root: HKLM; SubKey: SOFTWARE\GameClass3\Server; ValueType: string; ValueName: CurrentVersion; ValueData: {#MyAppVersion}; Flags: UninsDeleteKey deletekey; Components: Operator


[UninstallRun]
Filename: cmd; Parameters: "/c taskkill /IM gcclsrv.exe /F"; Flags: RunHidden; Components: Client; 
Filename: cmd; Parameters: "/c taskkill /IM gccl.exe /F"; Flags: RunHidden; Components: Client; 
Filename: cmd; Parameters: "/c ""{app}\Client\gcclsrv.exe"" -uninstall -silent"; Flags: RunHidden; Components: Client; 
Filename: cmd; Parameters: "/c del ""{app}\Client\gcclsrv.exe"""; Flags: RunHidden; Components: Client; 
Filename: cmd; Parameters: "/c del ""{app}\Client\*.log"" /Q"; Flags: RunHidden; Components: Client; 

[Code]
Function CheckKey: Boolean; 
Begin 
if  RegValueExists(HKLM, 'SOFTWARE\GameClass3\Client','CurrentVersion') then Result:= True 
End;

Function CheckOldInstaller: Boolean; 
Begin 
if  RegValueExists(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AB164D55-33F9-4417-A7C4-B07698C7EDE7}','InstallLocation') then Result:= True
End;

procedure CurStepChanged(CurStep: TSetupStep); 
var r: Integer;
begin
    if (CurStep = ssInstall) then
    begin
      if CheckKey then
      begin
        Exec(ExpandConstant('{app}\unins000.exe'), '/VERYSILENT /SUPPRESSMSGBOXES', '', SW_SHOW, ewWaitUntilTerminated, r);
        // ���������� ���������� ��������...
        while CheckForMutexes('MyProgramUninstallMutex') do Sleep(100);
      end;

      Exec(ExpandConstant('cmd'), '/c taskkill /IM gcclsrv.exe /F', '', SW_HIDE, ewWaitUntilTerminated, r);
      Exec(ExpandConstant('cmd'), '/c taskkill /IM gccl.exe /F', '', SW_HIDE, ewWaitUntilTerminated, r);

      if CheckOldInstaller then 
      begin
        Exec(ExpandConstant('cmd'), '/c "'+ExpandConstant('{app}')+'\Client\gcclsrv.exe" -uninstall -silent', '', SW_HIDE, ewWaitUntilTerminated, r);

        Exec(ExpandConstant('cmd'), '/c rmdir /Q /S "'+ExpandConstant('{app}')+'"', '', SW_HIDE, ewWaitUntilTerminated, r);
        RegDeleteKeyIncludingSubkeys(HKLM,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AB164D55-33F9-4417-A7C4-B07698C7EDE7}');
      end;

    end; 
end;
 
function InitializeUninstall(): Boolean; 
begin
    // ������ Mutex ����� ����� ����� �������� ����������
    CreateMutex('MyProgramUninstallMutex');
    result := true;
end;

