@echo off
@setlocal enableextensions
%~d0
cd /d %~dp0

echo.
echo ******************************************************************************
echo.
echo		  SCRIPT STANDARISASI ROLL OUT PT. BANK SYARIAH INDONESIA
echo			       OLEH TIM TECHNICAL SPECIALIST
echo			      PT. VISIONET DATA INTERNASIONAL
echo.
echo ******************************************************************************
echo.

:GETINPUT

echo  1 - Standarisasi EX-BNIS
echo.
echo  2 - Standarisasi EX-BRIS
echo.
set INPUT=
set /P INPUT=Enter the option: %=%
if "%INPUT%" == "1" goto INSTALLBNIS
if "%INPUT%" == "2" goto INSTALLBRIS
if "%INPUT%" == "q" goto END

goto INVALID

:INSTALLBNIS

cls
echo.
echo Memulai standarisasi EX-BNIS
pause
cls
echo.
echo Menambahkan user adminbsi dan userbsi...
echo.
net user adminbsi sbinBaz21! /add /active:yes
wmic useraccount WHERE Name='adminbsi' set PasswordExpires=false
wmic useraccount WHERE Name='adminbsi' set PasswordChangeable=false
net localgroup Administrators adminbsi /add
echo adminbsi berhasil ditambahkan sebagai Administrator
echo.
net user userbsi bsi12345 /add /active:yes
wmic useraccount WHERE Name='userbsi' set PasswordExpires=false
wmic useraccount WHERE Name='userbsi' set PasswordChangeable=false
net localgroup administrators userbsi /add
echo.
echo userbsi berhasil ditambahkan
echo.
echo Selesai membuat user
echo.
pause
cls

echo.
echo Configuring WMI...
echo.
net start "Windows Management Instrumentation"
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt\ /v Start /t REG_DWORD /d 2 /f
echo.
pause
cls

echo.
echo Configuring Firewall for WMI...
NETSH ADVFIREWALL FIREWALL SET RULE GROUP="Windows Management Instrumentation (WMI)" NEW ENABLE=YES
pause
cls

echo.
echo Disable UAC...
echo.
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
echo.
echo Berhasil disable UAC
echo.
pause
cls

echo.
echo Register DNS...
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ()
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ("10.0.1.200", "10.0.1.201", "10.0.14.6", "10.0.14.7", "192.168.8.18", "192.168.8.19")
echo.
echo Berhasil register DNS
echo.
pause
cls

echo.
echo Copy file hosts...
echo.
cd %~dp0\"Etc Hosts\Hosts BSI"\
msg %username% /TIME:0 /V /W Edit bagian 10.x.x.2 menjadi IP ICONS, save, lalu lanjutkan script.
start wordpad -file hosts
pause
copy hosts C:\Windows\System32\drivers\etc\
echo.
echo Berhasil copy file hosts
echo.
pause
cls

echo.
echo Copy file Restart Passbook.bat...
cd %~dp0\"Standalone Script"\
copy "Restart Passbook.bat" "C:\Users\userbsi\Desktop"
echo.
echo Berhasil copy Restart Passbook.bat
echo.
pause
cls

set IS_X64=0 && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))
if "%IS_X64%" == "1" goto X64BNIS

echo.
echo Update patch Windows 7...
echo.
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\Prerequisites\
expand -f:* windows6.1-kb2670838-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2670838-x86.xml /norestart
expand -f:* windows6.1-kb2729094-v2-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2729094-v2-x86.xml /norestart
expand -f:* windows6.1-kb2731771-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2731771-x86.xml /norestart
expand -f:* windows6.1-kb2786081-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2786081-x86.xml /norestart
expand -f:* windows6.1-kb2834140-v2-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2834140-v2-x86.xml /norestart
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\
start /wait IE11-Windows6.1-x86-en-us.exe
cd %~dp0\Patches\"Windows 7"\Ransomware\
expand -f:* windows6.1-kb4012212-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4012212-x86.xml /norestart
cd %~dp0\Patches\"Windows 7"\SMB\
expand -f:* windows6.1-kb4019263-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4019263-x86.xml /norestart
echo.
echo Berhasil update patch Windows 7
echo.
pause
cls

echo.
echo Installing Microsoft Visual C++ Runtimes...
echo.
cd %~dp0\"Microsoft Visual C++ Runtimes"\
echo 2005...
start /wait vcredist2005_x86.exe /q
echo 2008...
start /wait vcredist2008_x86.exe /qb
echo 2010...
start /wait vcredist2010_x86.exe /passive /norestart
echo 2012...
start /wait vcredist2012_x86.exe /passive /norestart
echo 2013...
start /wait vcredist2013_x86.exe /passive /norestart
echo 2015, 2017 ^& 2019...
start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
echo.
echo Berhasil install Microsoft Visual C++ Runtimes
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
cd %userprofile%\AppData\Local\
rmdir /s /q Mozilla
cd %userprofile%\AppData\Roaming\
rmdir /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
msiexec /i "Firefox Setup 88.0 x86.msi" /passive INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=false START_MENU_SHORTCUT=false
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" %userprofile%\Desktop\
cd "C:\Program Files\Mozilla Firefox\"
start /wait firefox.exe -p
timeout 5
echo.
taskkill /im firefox.exe /t /f
start /wait firefox -CreateProfile userbsi
timeout 5
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
echo Berhasil install Mozilla Firefox
echo.
pause
cls

echo.
echo Update TightVNC...
cd %~dp0\VNC\
msiexec /i tightvnc-2.8.59-gpl-setup-32bit.msi /passive /norestart PROPERTY3=value3 SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=hne123 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=hne123 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=hne123
echo.
echo Berhasil update TightVNC
echo.
pause
cls

echo.
echo Installing Agent Desktop Central, pilih opsi nomor 1...
echo.
%systemroot%\system32\msiexec.exe /x{6AD2231F-FF48-4D59-AC26-405AFAE23DB7} MSIRESTARTMANAGERCONTROL=Disable REBOOT="ReallySuppress" /qn
cd %~dp0\"Agent Desktop Central"\localsetup\
start /wait Setup.bat 2>nul|findstr /i "termin"
if errorlevel 1 goto BYPASSBNIS

:X64BNIS

echo.
echo Update patch Windows 7...
echo.
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\Prerequisites\
expand -f:* windows6.1-kb2670838-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2670838-x64.xml /norestart
expand -f:* windows6.1-kb2729094-v2-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2729094-v2-x64.xml /norestart
expand -f:* windows6.1-kb2731771-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2731771-x64.xml /norestart
expand -f:* windows6.1-kb2786081-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2786081-x64.xml /norestart
expand -f:* windows6.1-kb2834140-v2-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2834140-v2-x64.xml /norestart
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\
start /wait IE11-Windows6.1-x64-en-us.exe
cd %~dp0\Patches\"Windows 7"\Ransomware\
expand -f:* windows6.1-kb4012212-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4012212-x64.xml /norestart
cd %~dp0\Patches\"Windows 7"\SMB\
expand -f:* windows6.1-kb4019263-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4019263-x64.xml /norestart
echo.
echo Berhasil update patch Windows 7
echo.
pause
cls

echo.
echo Installing Microsoft Visual C++ Runtimes...
echo.
cd %~dp0\"Microsoft Visual C++ Runtimes"\
echo 2005...
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q
echo 2008...
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb
echo 2010...
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart
echo 2012...
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart
echo 2013...
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart
echo 2015, 2017 ^& 2019...
start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_x64.exe /passive /norestart
echo.
echo Berhasil install Microsoft Visual C++ Runtimes
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
cd %userprofile%\AppData\Local\
rmdir /s /q Mozilla
cd %userprofile%\AppData\Roaming\
rmdir /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
msiexec /i "Firefox Setup 88.0 x64.msi" /passive INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=false START_MENU_SHORTCUT=false
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" %userprofile%\Desktop\
cd "C:\Program Files\Mozilla Firefox\"
start /wait firefox.exe -p
timeout 5
echo.
taskkill /im firefox.exe /t /f
start /wait firefox -CreateProfile userbsi
timeout 5
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
echo Berhasil install Mozilla Firefox
echo.
pause
cls

echo.
echo Update TightVNC...
cd %~dp0\VNC\
msiexec /i tightvnc-2.8.59-gpl-setup-64bit.msi /passive /norestart PROPERTY3=value3 SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=hne123 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=hne123 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=hne123
echo.
echo Berhasil update TightVNC
echo.
pause
cls

echo.
echo Installing Agent Desktop Central, pilih opsi nomor 1...
echo.
%systemroot%\system32\msiexec.exe /x{6AD2231F-FF48-4D59-AC26-405AFAE23DB7} MSIRESTARTMANAGERCONTROL=Disable REBOOT="ReallySuppress" /qn
cd %~dp0\"Agent Desktop Central"\localsetup\
start /wait Setup.bat 2>nul|findstr /i "termin"
if errorlevel 1 goto BYPASSBNIS

:INSTALLBRIS

cls
echo.
echo Memulai standarisasi EX-BRIS
pause
cls
echo.
echo Menambahkan user adminbsi dan userbsi...
echo.
net user adminbsi sbinBaz21! /add /active:yes
wmic useraccount WHERE Name='adminbsi' set PasswordExpires=false
wmic useraccount WHERE Name='adminbsi' set PasswordChangeable=false
net localgroup Administrators adminbsi /add
echo adminbsi berhasil ditambahkan sebagai Administrator
echo.
net user userbsi bsi12345 /add /active:yes
wmic useraccount WHERE Name='userbsi' set PasswordExpires=false
wmic useraccount WHERE Name='userbsi' set PasswordChangeable=false
net localgroup administrators userbsi /add
echo userbsi berhasil ditambahkan
echo.
echo Selesai membuat user
echo.
pause
cls

echo.
echo Configuring WMI...
echo.
net start "Windows Management Instrumentation"
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt\ /v Start /t REG_DWORD /d 2 /f
echo.
pause
cls

echo.
echo Configuring Firewall for WMI...
NETSH ADVFIREWALL FIREWALL SET RULE GROUP="Windows Management Instrumentation (WMI)" NEW ENABLE=YES
pause
cls

echo.
echo Disable UAC...
echo.
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
echo.
echo Berhasil disable UAC
echo.
pause
cls

echo.
echo Register DNS...
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ()
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ("10.0.1.200", "10.0.1.201", "10.0.14.6", "10.0.14.7")
echo.
echo Berhasil register DNS
echo.
pause
cls

echo.
echo Copy file hosts...
echo.
cd %~dp0\"Etc Hosts\Hosts BSI"\
copy hosts C:\Windows\System32\drivers\etc\
echo.
echo Berhasil copy file hosts
echo.
pause
cls

set IS_X64=0 && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))
if "%IS_X64%" == "1" goto X64BRIS

echo.
echo Update patch Windows 7...
echo.
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\Prerequisites\
expand -f:* windows6.1-kb2670838-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2670838-x86.xml /norestart
expand -f:* windows6.1-kb2729094-v2-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2729094-v2-x86.xml /norestart
expand -f:* windows6.1-kb2731771-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2731771-x86.xml /norestart
expand -f:* windows6.1-kb2786081-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2786081-x86.xml /norestart
expand -f:* windows6.1-kb2834140-v2-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2834140-v2-x86.xml /norestart
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\
start /wait IE11-Windows6.1-x86-en-us.exe
cd %~dp0\Patches\"Windows 7"\Ransomware\
expand -f:* windows6.1-kb4012212-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4012212-x86.xml /norestart
cd %~dp0\Patches\"Windows 7"\SMB\
expand -f:* windows6.1-kb4019263-x86.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4019263-x86.xml /norestart
echo.
echo Berhasil update patch Windows 7
echo.
pause
cls

echo.
echo Installing Microsoft Visual C++ Runtimes...
echo.
cd %~dp0\"Microsoft Visual C++ Runtimes"\
echo 2005...
start /wait vcredist2005_x86.exe /q
echo 2008...
start /wait vcredist2008_x86.exe /qb
echo 2010...
start /wait vcredist2010_x86.exe /passive /norestart
echo 2012...
start /wait vcredist2012_x86.exe /passive /norestart
echo 2013...
start /wait vcredist2013_x86.exe /passive /norestart
echo 2015, 2017 ^& 2019...
start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
echo.
echo Berhasil install Microsoft Visual C++ Runtimes
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
cd %userprofile%\AppData\Local\
rmdir /s /q Mozilla
cd %userprofile%\AppData\Roaming\
rmdir /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
msiexec /i "Firefox Setup 88.0 x86.msi" /passive INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=false START_MENU_SHORTCUT=false
echo.
cd %~dp0\"Mozilla Firefox"\
xcopy /e /i /c /y "Mozilla Firefox 28.0" "C:\Program Files\Mozilla Firefox 28.0\"
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" %userprofile%\Desktop\
echo.
cd %~dp0\"Mozilla Firefox\Mozilla Firefox 28.0"\core\
copy "Syiar Firefox.lnk" %userprofile%\Desktop\
cd "C:\Program Files\Mozilla Firefox\"
start /wait firefox.exe -p
timeout 5
echo.
taskkill /im firefox.exe /t /f
start /wait firefox -CreateProfile userbsi
start /wait firefox -CreateProfile legacy
timeout 5
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".legacy" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js"
echo.
echo Berhasil install Mozilla Firefox
echo.
pause
cls

echo.
echo Update TightVNC...
cd %~dp0\VNC\
msiexec /i tightvnc-2.8.59-gpl-setup-32bit.msi /passive /norestart PROPERTY3=value3 SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=1 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=1 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=1
echo.
echo Berhasil update TightVNC
echo.
pause
cls

echo.
echo Installing Agent Desktop Central, pilih opsi nomor 1...
echo.
%systemroot%\system32\msiexec.exe /x{6AD2231F-FF48-4D59-AC26-405AFAE23DB7} MSIRESTARTMANAGERCONTROL=Disable REBOOT="ReallySuppress" /qn
cd %~dp0\"Agent Desktop Central"\localsetup\
start /wait Setup.bat 2>nul|findstr /i "termin"
if errorlevel 1 goto BYPASSBRIS

:X64BRIS

echo.
echo Update patch Windows 7...
echo.
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\Prerequisites\
expand -f:* windows6.1-kb2670838-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2670838-x64.xml /norestart
expand -f:* windows6.1-kb2729094-v2-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2729094-v2-x64.xml /norestart
expand -f:* windows6.1-kb2731771-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2731771-x64.xml /norestart
expand -f:* windows6.1-kb2786081-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2786081-x64.xml /norestart
expand -f:* windows6.1-kb2834140-v2-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB2834140-v2-x64.xml /norestart
cd %~dp0\Patches\"Windows 7\Internet Explorer 11"\
start /wait IE11-Windows6.1-x64-en-us.exe
cd %~dp0\Patches\"Windows 7"\Ransomware\
expand -f:* windows6.1-kb4012212-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4012212-x64.xml /norestart
cd %~dp0\Patches\"Windows 7"\SMB\
expand -f:* windows6.1-kb4019263-x64.msu %TEMP%
pkgmgr.exe /n:%TEMP%\Windows6.1-KB4019263-x64.xml /norestart
echo.
echo Berhasil update patch Windows 7
echo.
pause
cls

echo.
echo Installing Microsoft Visual C++ Runtimes...
echo.
cd %~dp0\"Microsoft Visual C++ Runtimes"\
echo 2005...
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q
echo 2008...
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb
echo 2010...
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart
echo 2012...
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart
echo 2013...
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart
echo 2015, 2017 ^& 2019...
start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_x64.exe /passive /norestart
echo.
echo Berhasil install Microsoft Visual C++ Runtimes
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
timeout 5
cd %userprofile%\AppData\Local\
rmdir /s /q Mozilla
cd %userprofile%\AppData\Roaming\
rmdir /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
msiexec /i "Firefox Setup 88.0 x64.msi" /passive INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=false START_MENU_SHORTCUT=false
echo.
cd %~dp0\"Mozilla Firefox"\
xcopy /e /i /c /y "Mozilla Firefox 28.0" "C:\Program Files\Mozilla Firefox 28.0\"
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" %userprofile%\Desktop\
echo.
cd %~dp0\"Mozilla Firefox\Mozilla Firefox 28.0"\core\
copy "Syiar Firefox.lnk" %userprofile%\Desktop\
cd "C:\Program Files\Mozilla Firefox\"
start /wait firefox.exe -p
timeout 5
echo.
taskkill /im firefox.exe /t /f
start /wait firefox -CreateProfile userbsi
start /wait firefox -CreateProfile legacy
timeout 5
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
set copycmd=/y
c:
cd %userprofile%\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".legacy" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js"
echo.
echo Berhasil install Mozilla Firefox
echo.
pause
cls

echo.
echo Update TightVNC...
cd %~dp0\VNC\
msiexec /i tightvnc-2.8.59-gpl-setup-64bit.msi /passive /norestart PROPERTY3=value3 SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=1 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=1 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=1
echo.
echo Berhasil update TightVNC
echo.
pause
cls

echo.
echo Installing Agent Desktop Central, pilih opsi nomor 1...
echo.
%systemroot%\system32\msiexec.exe /x{6AD2231F-FF48-4D59-AC26-405AFAE23DB7} MSIRESTARTMANAGERCONTROL=Disable REBOOT="ReallySuppress" /qn
cd %~dp0\"Agent Desktop Central"\localsetup\
start /wait Setup.bat 2>nul|findstr /i "termin"
if errorlevel 1 goto BYPASSBRIS

:BYPASSBNIS

echo.
echo Berhasil install Agent Desktop Central
echo.
pause
goto ENDBNIS

:BYPASSBRIS

echo.
echo Berhasil install Agent Desktop Central
echo.
pause
goto ENDBRIS

:INVALID

cls
echo.
msg %username% /TIME:0 /V /W "Please enter the valid option."
echo.
goto GETINPUT

:ENDBNIS

cls
echo.
msg %username% /TIME:0 /V /W Standarisasi EX-BNIS selesai, silakan dilanjut untuk merubah IP, hostname, dan join domain. Jangan lupa untuk setting printer dan pinpad di userbsi.
echo.
shutdown -r
exit

:ENDBRIS

cls
echo.
msg %username% /TIME:0 /V /W Standarisasi EX-BRIS selesai, silakan dilanjut untuk merubah IP, hostname, dan join domain. Jangan lupa untuk setting printer dan pinpad di userbsi.
echo.
shutdown -r
exit

:END
exit