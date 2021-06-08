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
echo.
pause
cls
echo.
echo Menambahkan user adminbsi dan userbsi...
echo.
net user adminbsi sbinBaz21! /add /active:yes
wmic useraccount WHERE Name='adminbsi' set PasswordExpires=false
wmic useraccount WHERE Name='adminbsi' set PasswordChangeable=false
net localgroup administrators adminbsi /add
echo adminbsi berhasil ditambahkan sebagai administrator
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
copy "Restart Passbook.bat" "C:\Documents and Settings\All Users\Desktop\"
echo.
echo Berhasil copy Restart Passbook.bat
echo.
pause
cls

echo.
echo Update patch Windows XP...
echo.
cd %~dp0\Patches\"Windows XP"\
start /wait KB4012598-x86-custom-enu.exe
start /wait IE8-WindowsXP-x86-ENU.exe
echo Berhasil update patch Windows XP
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
cd %userprofile%\Application Data\
rd /s /q Mozilla
cd %userprofile%\Local Settings\Application Data\
rd /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
call "Firefox Setup 52.9.1 x86.exe" /s
echo.
copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\Mozilla Firefox.lnk" "C:\Documents and Settings\All Users\Desktop\"
cd "C:\Program Files\Mozilla Firefox\"
start firefox.exe -p
echo.
taskkill /im firefox.exe /t /f
echo.
start /w firefox -CreateProfile userbsi
echo.
set copycmd=/y
c:
cd %userprofile%\Application Data\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json"
echo.
echo Berhasil install Mozilla Firefox
echo.
pause
cls

echo.
echo Installing Google Chrome...
echo.
taskkill /im chrome.exe /t /f
echo.
cd "%ProgramFiles%\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "%ProgramFiles%\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"%ProgramFiles%\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "%ProgramFiles%\Google\"
rd /s /q Chrome
echo.
cd "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "%userprofile%\Local Settings\Application Data\Google\"
rd /s /q Chrome
echo.
cd %~dp0\"Google Chrome"\
call "Google Chrome (32bit) v49.0.2623.112.exe"
echo.
taskkill /im chrome.exe /t /f
echo.
cd "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Bookmarks" "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Preferences" "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
echo.
echo Berhasil install Google Chrome
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
echo Installing OCS Inventory...
echo Setting dan IP Server URL pada saat instalasi harus sesuai dengan WI
echo.
cd %~dp0\OCS Inventory\OCSNG-Windows-Agent-2.1.1.3\
start /wait OCS-NG-Windows-Agent-Setup.exe
echo.
echo Berhasil install OCS Inventory
echo.
pause
goto ENDBNIS

:INSTALLBRIS

cls
echo.
echo Memulai standarisasi EX-BRIS
echo.
pause
cls
echo.
echo Menambahkan user adminbsi dan userbsi...
echo.
net user adminbsi sbinBaz21! /add /active:yes
wmic useraccount WHERE Name='adminbsi' set PasswordExpires=false
wmic useraccount WHERE Name='adminbsi' set PasswordChangeable=false
net localgroup administrators adminbsi /add
echo adminbsi berhasil ditambahkan sebagai administrator
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

echo.
echo Update patch Windows XP...
echo.
cd %~dp0\Patches\"Windows XP"\
start /wait KB4012598-x86-custom-enu.exe /passive /norestart
start /wait IE8-WindowsXP-x86-ENU.exe /passive /norestart
echo Berhasil update patch Windows XP
echo.
pause
cls

echo.
echo Installing Mozilla Firefox...
echo.
taskkill /im firefox.exe /t /f
if exist "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
echo.
if exist "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" ("%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms) else echo Updating...
cd %userprofile%\Application Data\
rd /s /q Mozilla
cd %userprofile%\Local Settings\Application Data\
rd /s /q Mozilla
cd %~dp0\"Mozilla Firefox"\
call "Firefox Setup 52.9.1 x86.exe" /s
echo.
cd %~dp0\"Mozilla Firefox"\
xcopy /e /i /c /y "Mozilla Firefox 28.0" "C:\Program Files\Mozilla Firefox 28.0\"
echo.
copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\Mozilla Firefox.lnk" "C:\Documents and Settings\All Users\Desktop\"
echo.
copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\Mozilla Firefox 28.0\core\Syiar Firefox.lnk" "C:\Documents and Settings\All Users\Desktop\"
cd "C:\Program Files\Mozilla Firefox\"
start firefox.exe -p
echo.
taskkill /im firefox.exe /t /f
start /w firefox -CreateProfile userbsi
start /w firefox -CreateProfile legacy
echo.
set copycmd=/y
c:
cd "%userprofile%\Application Data\Mozilla\Firefox\"
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json"
echo.
set copycmd=/y
c:
cd "%userprofile%\Application Data\Mozilla\Firefox\"
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
echo Installing Google Chrome...
echo.
taskkill /im chrome.exe /t /f
echo.
cd "%ProgramFiles%\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "%ProgramFiles%\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"%ProgramFiles%\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "%ProgramFiles%\Google\"
rd /s /q Chrome
echo.
cd "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "%userprofile%\Local Settings\Application Data\Google\"
rd /s /q Chrome
echo.
cd %~dp0\"Google Chrome"\
call "Google Chrome (32bit) v49.0.2623.112.exe"
echo.
taskkill /im chrome.exe /t /f
echo.
cd "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Bookmarks" "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Preferences" "%userprofile%\Local Settings\Application Data\Google\Chrome\Application\%version%\"
echo.
echo Berhasil install Google Chrome
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
echo Installing OCS Inventory...
echo Setting dan IP Server URL pada saat instalasi harus sesuai dengan WI
echo.
cd %~dp0\OCS Inventory\OCSNG-Windows-Agent-2.1.1.3\
start /wait OCS-NG-Windows-Agent-Setup.exe
echo.
echo Berhasil install OCS Inventory
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
pause
shutdown -r
exit

:END
exit