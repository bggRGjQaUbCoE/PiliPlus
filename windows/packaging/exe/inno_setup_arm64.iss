#define RepoRoot AddBackslash(SourcePath + "..\..\..")
#define AppVersion "2.1.5+5411"
#define AppExe "piliplus.exe"

[Setup]
AppId={{5ef970f9-2b9e-4155-b7d6-a9d4dbd6b226}
AppVersion={#AppVersion}
VersionInfoVersion=2.1.5.5411
AppName=PiliPlus
AppPublisher=dom
AppPublisherURL=https://github.com/bggRGjQaUbCoE/PiliPlus
AppSupportURL=https://github.com/bggRGjQaUbCoE/PiliPlus
AppUpdatesURL=https://github.com/bggRGjQaUbCoE/PiliPlus
DefaultDirName={autopf}\PiliPlus
DisableProgramGroupPage=yes
OutputDir={#RepoRoot}dist
OutputBaseFilename=PiliPlus_windows_{#AppVersion}_arm64_setup
Compression=lzma2
SolidCompression=yes
SetupIconFile={#RepoRoot}windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
CloseApplications=yes
RestartApplications=no
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce
Name: "launchAtStartup"; Description: "{cm:AutoStartProgram,PiliPlus}"; GroupDescription: "{cm:AutoStartProgramGroupDescription}"; Flags: unchecked

[Files]
Source: "{#RepoRoot}build\windows\arm64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\PiliPlus"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"
Name: "{autodesktop}\PiliPlus"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{autostartup}\PiliPlus"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Tasks: launchAtStartup

[Registry]
Root: HKA; Subkey: "Software\Classes\bilibili"; ValueType: string; ValueData: "URL:Bilibili Protocol"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\bilibili"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKA; Subkey: "Software\Classes\bilibili\DefaultIcon"; ValueType: string; ValueData: "{app}\{#AppExe},0"
Root: HKA; Subkey: "Software\Classes\bilibili\shell\open\command"; ValueType: string; ValueData: """{app}\{#AppExe}"" ""%1"""

[Run]
Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Description: "{cm:LaunchProgram,PiliPlus}"; Flags: runascurrentuser nowait postinstall skipifsilent
