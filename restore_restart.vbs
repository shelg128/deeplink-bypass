If Not WScript.Arguments.Named.Exists("elevate") Then
CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
WScript.Quit
End If
On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
Set shl = CreateObject("WScript.Shell")
source = "C:\Program Files (x86)\DeepLink\rent_protect\nopolicy\GroupPolicy"
target = "C:\Windows\System32\GroupPolicy"
fso.CopyFolder source, target, True
shl.RegDelete "HKCU\Software\Policies\"
shl.RegDelete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\"
shl.RegDelete "HKLM\Software\Policies\"
shl.Run "shutdown /r /t 0 /f", 0, True
