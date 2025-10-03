#define AppVersion GetEnv("AppVersion")

[Setup]
AppName=PiliPlus
AppVersion={#AppVersion}
DefaultDirName={pf}\PiliPlus
DefaultGroupName=PiliPlus
UninstallDisplayIcon={app}\PiliPlus.exe
Compression=lzma
SolidCompression=yes
OutputDir=.
OutputBaseFilename=PiliPlus_Setup
SetupIconFile=windows\runner\resources\app_icon.ico

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Files]
; TODO: 替换为实际构建产物路径
Source: "build\windows\runner\Release\PiliPlus.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\PiliPlus"; Filename: "{app}\PiliPlus.exe"
Name: "{commondesktop}\PiliPlus"; Filename: "{app}\PiliPlus.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加任务:"

[Run]
Filename: "{app}\PiliPlus.exe"; Description: "运行 PiliPlus"; Flags: nowait postinstall skipifsilent