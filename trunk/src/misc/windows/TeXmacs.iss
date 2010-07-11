; -- TeXmacs.iss --
; Inno Setup configuration file for the compilation of the 
; Windows TeXmacs installer

[Setup]
AppName=iTeXmacs
AppVerName=iTeXmacs version 1.0.7.4
DefaultDirName={pf}\iTeXmacs
DefaultGroupName=iTeXmacs
UninstallDisplayIcon={app}\TeXmacs.ico
OutputDir=..\..\..\distr
OutputBaseFilename=itexmacs-installer
; SourceDir=../..
ChangesAssociations=yes

WizardImageFile=TeXmacs-large.bmp
WizardImageStretch=no
WizardSmallImageFile=TeXmacs-small.bmp

PrivilegesRequired=none

[Registry]
Root: HKCU; Subkey: "Software\Classes\.tm"; ValueType: string; ValueName: ""; ValueData: "tmfile"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\tmfile"; ValueType: string; ValueName: ""; ValueData: "text/tm"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\tmfile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\TeXmacs.ico"
Root: HKCU; Subkey: "Software\Classes\tmfile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\bin\texmacs.exe"" ""%1""" 

[Files]
Source: ..\..\..\distr\TeXmacs-Windows\*; DestDir: {app}; Flags: recursesubdirs createallsubdirs
Source: TeXmacs.ico; DestDir: {app}
Source: portable.bat; DestDir: {app}
Source: settings.scm; DestDir: {userappdata}\iTeXmacs\system; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\iTeXmacs"; Filename: "{app}\bin\texmacs.exe"; IconFilename: "{app}\TeXmacs.ico"
Name: "{group}\Uninstall iTeXmacs"; Filename: "{uninstallexe}"
Name: "{commondesktop}\iTeXmacs"; Filename: "{app}\bin\texmacs.exe"; IconFilename: "{app}\TeXmacs.ico"
