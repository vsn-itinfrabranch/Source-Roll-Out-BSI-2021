@echo off
@setlocal enableextensions
%~d0
cd /d %~dp0

echo.
echo PASTIKAN SCRIPT INI BERJALAN DI USERBSI
echo.

:GETINPUT

echo  1 - Browser Settings EX-BNIS
echo.
echo  2 - Browser Settings EX-BRIS
echo.
echo  3 - Browser Settings Windows XP BNIS
echo.
echo  4 - Browser Settings Windows XP BRIS
echo.
set INPUT=
set /P INPUT=Enter the option: %=%
if "%INPUT%" == "1" goto INSTALLBNIS
if "%INPUT%" == "2" goto INSTALLBRIS
if "%INPUT%" == "3" goto WINXPBNIS
if "%INPUT%" == "4" goto WINXPBRIS
if "%INPUT%" == "q" goto END

goto INVALID

:INSTALLBNIS

cls
echo.
echo Memulai IE Settings...
pause
echo.
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
ping 127.0.0.1 -w 1 -n 2
echo set WshShell = CreateObject("WScript.Shell") >autokeys.vbs
echo WshShell.Sendkeys "%{DOWN}" >>autokeys.vbs
echo WshShell.Sendkeys "R{ENTER}" >>autokeys.vbs
echo WshShell.Sendkeys "%{UP}" >>autokeys.vbs
cscript autokeys.vbs
del autokeys.vbs
ping 127.0.0.1 -w 1 -n 3
echo set WshShell = CreateObject("WScript.Shell") >autokeys1.vbs
echo WshShell.Sendkeys "c" >>autokeys1.vbs
cscript autokeys1.vbs
del autokeys1.vbs
ping 127.0.0.1 -w 1 -n 1
echo n | gpupdate/force
copy "IE Settings.reg" C:\Users\userbsi\AppData\Local\Temp\
cd C:\Users\userbsi\AppData\Local\Temp\
regedit "IE Settings.reg"
echo.
echo Berhasil melakukan IE Settings
echo Silakan input manual IP server ICONS di Local Intranet dan Compatibility View
echo.
pause

cls
echo.
echo Memulai Firefox Settings EX-BNIS
pause
echo.
cd %~dp0\"Mozilla Firefox"\
certutil -addstore -enterprise -f -v root SertifikatRVIT.pfx
echo.
cd C:\Users\userbsi\AppData\Local\
rmdir /s /q Mozilla
cd C:\Users\userbsi\AppData\Roaming\
rmdir /s /q Mozilla
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" C:\Users\userbsi\Desktop\
echo.
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
cd C:\Users\userbsi\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
echo Berhasil melakukan Firefox Settings
echo.
goto ENDBNIS

:INSTALLBRIS

cls
echo.
echo Memulai IE Settings...
pause
echo.
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
ping 127.0.0.1 -w 1 -n 2
echo set WshShell = CreateObject("WScript.Shell") >autokeys.vbs
echo WshShell.Sendkeys "%{DOWN}" >>autokeys.vbs
echo WshShell.Sendkeys "R{ENTER}" >>autokeys.vbs
echo WshShell.Sendkeys "%{UP}" >>autokeys.vbs
cscript autokeys.vbs
del autokeys.vbs
ping 127.0.0.1 -w 1 -n 3
echo set WshShell = CreateObject("WScript.Shell") >autokeys1.vbs
echo WshShell.Sendkeys "c" >>autokeys1.vbs
cscript autokeys1.vbs
del autokeys1.vbs
ping 127.0.0.1 -w 1 -n 1
echo n | gpupdate/force
copy "IE Settings.reg" C:\Users\userbsi\AppData\Local\Temp\
cd C:\Users\userbsi\AppData\Local\Temp\
regedit "IE Settings.reg"
echo.
echo Berhasil melakukan IE Settings
echo Silakan input manual IP server ICONS di Local Intranet dan Compatibility View
echo.
pause

cls
echo.
echo Memulai Firefox Settings...
pause
echo.
cd %~dp0\"Mozilla Firefox"\
certutil -addstore -enterprise -f -v root SertifikatRVIT.pfx
echo.
cd C:\Users\userbsi\AppData\Local\
rmdir /s /q Mozilla
cd C:\Users\userbsi\AppData\Roaming\
rmdir /s /q Mozilla
echo.
cd %~dp0\"Mozilla Firefox"\
copy "Mozilla Firefox.lnk" C:\Users\userbsi\Desktop\
echo.
cd %~dp0\"Mozilla Firefox\Mozilla Firefox 28.0"\core\
copy "Syiar Firefox.lnk" C:\Users\userbsi\Desktop\
echo.
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
cd C:\Users\userbsi\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi\xulstore.json"
echo.
set copycmd=/y
c:
cd C:\Users\userbsi\AppData\Roaming\Mozilla\Firefox\
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".legacy" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js"
echo.
echo Berhasil melakukan Firefox Settings
echo.
pause
goto ENDBRIS

:WINXPBNIS

cls
echo.
echo Memulai IE Settings...
pause
echo.
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
ping 127.0.0.1 -w 1 -n 2
echo set WshShell = CreateObject("WScript.Shell") >autokeys.vbs
echo WshShell.Sendkeys "%{DOWN}" >>autokeys.vbs
echo WshShell.Sendkeys "R{ENTER}" >>autokeys.vbs
echo WshShell.Sendkeys "%{UP}" >>autokeys.vbs
cscript autokeys.vbs
del autokeys.vbs
ping 127.0.0.1 -w 1 -n 3
echo set WshShell = CreateObject("WScript.Shell") >autokeys1.vbs
echo WshShell.Sendkeys "c" >>autokeys1.vbs
cscript autokeys1.vbs
del autokeys1.vbs
ping 127.0.0.1 -w 1 -n 1
echo n | gpupdate/force
copy "IE Settings.reg" "C:\Documents and Settings\userbsi\Local Settings\Temp\"
cd "C:\Documents and Settings\userbsi\Local Settings\Temp\"
regedit "IE Settings.reg"
echo.
echo Berhasil melakukan IE Settings
echo Silakan input manual IP server ICONS di Local Intranet dan Compatibility View
echo.
pause

cls
echo.
echo Memulai Firefox Settings...
pause
echo.
cd %~dp0\"Mozilla Firefox"\
certutil -addstore -enterprise -f -v root SertifikatRVIT.pfx
cd cd "C:\Documents and Settings\userbsi\Application Data\"
rd /s /q Mozilla
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\"
rd /s /q Mozilla
start firefox -p
echo.
taskkill /im firefox.exe /t /f
echo.
start /w firefox -CreateProfile userbsi
echo.
set copycmd=/y
c:
cd "C:\Documents and Settings\userbsi\Application Data\Mozilla\Firefox\"
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json"
echo.
echo Berhasil melakukan Firefox Settings
echo.
pause

echo.
echo Installing Google Chrome...
echo.
taskkill /im chrome.exe /t /f
echo.
cd "C:Program Files\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "C:Program Files\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"C:Program Files\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "C:Program Files\Google\"
rd /s /q Chrome
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\"
rd /s /q Chrome
echo.
cd %~dp0\"Google Chrome"\
call "Google Chrome (32bit) v49.0.2623.112.exe"
echo.
taskkill /im chrome.exe /t /f
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Bookmarks" "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Preferences" "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
echo.
echo Berhasil install Google Chrome
echo.
pause
goto ENDBNIS

:WINXPBRIS

cls
echo.
echo Memulai IE Settings...
pause
echo.
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
ping 127.0.0.1 -w 1 -n 2
echo set WshShell = CreateObject("WScript.Shell") >autokeys.vbs
echo WshShell.Sendkeys "%{DOWN}" >>autokeys.vbs
echo WshShell.Sendkeys "R{ENTER}" >>autokeys.vbs
echo WshShell.Sendkeys "%{UP}" >>autokeys.vbs
cscript autokeys.vbs
del autokeys.vbs
ping 127.0.0.1 -w 1 -n 3
echo set WshShell = CreateObject("WScript.Shell") >autokeys1.vbs
echo WshShell.Sendkeys "c" >>autokeys1.vbs
cscript autokeys1.vbs
del autokeys1.vbs
ping 127.0.0.1 -w 1 -n 1
echo n | gpupdate/force
copy "IE Settings.reg" "C:\Documents and Settings\userbsi\Local Settings\Temp\"
cd "C:\Documents and Settings\userbsi\Local Settings\Temp\"
regedit "IE Settings.reg"
echo.
echo Berhasil melakukan IE Settings
echo Silakan input manual IP server ICONS di Local Intranet dan Compatibility View
echo.
pause

cls
echo.
echo Memulai Firefox Settings...
pause
echo.
cd %~dp0\"Mozilla Firefox"\
certutil -addstore -enterprise -f -v root SertifikatRVIT.pfx
cd "C:\Documents and Settings\userbsi\Application Data\"
rd /s /q Mozilla
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\"
rd /s /q Mozilla
start firefox -p
echo.
taskkill /im firefox.exe /t /f
start /w firefox -CreateProfile userbsi
start /w firefox -CreateProfile legacy
echo.
set copycmd=/y
c:
cd "C:\Documents and Settings\userbsi\Application Data\Mozilla\Firefox\"
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".userbsi" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\prefs.js"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.userbsi.firefox52\xulstore.json"
echo.
set copycmd=/y
c:
cd "C:\Documents and Settings\userbsi\Application Data\Mozilla\Firefox\"
for /f "tokens=1,2 delims=/" %%i in ('findstr /l ".legacy" profiles.ini') do call set var1=%%j
cd Profiles\%var1%
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\localstore.rdf"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\places.sqlite"
if exist "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js" copy "C:\Source Roll Out BSI 2021\Mozilla Firefox\profile.legacy\prefs.js"
echo.
echo Berhasil melakukan Firefox Settings
echo.
pause

echo.
echo Installing Google Chrome...
echo.
taskkill /im chrome.exe /t /f
echo.
cd "C:Program Files\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "C:Program Files\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"C:Program Files\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "C:Program Files\Google\"
rd /s /q Chrome
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\"
:: return version number
setlocal enabledelayedexpansion
set version=
set /a count=1
for /f "delims=" %%V in ('dir "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\" /a:d /b') do (
if !count!==1 set version=%%V
set /a count+=1
)
echo %version%
echo.
"C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\%version%\Installer\setup.exe" --uninstall --force-uninstall
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\"
rd /s /q Chrome
echo.
cd %~dp0\"Google Chrome"\
call "Google Chrome (32bit) v49.0.2623.112.exe"
echo.
taskkill /im chrome.exe /t /f
echo.
cd "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Bookmarks" "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
copy "C:\Source Roll Out BSI 2021\Google Chrome\profile.userbsi\Preferences" "C:\Documents and Settings\userbsi\Local Settings\Application Data\Google\Chrome\Application\49.0.2623.112\"
echo.
echo Berhasil install Google Chrome
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
net localgroup administrators userbsi /delete
echo.
msg userbsi /TIME:0 /V /W Berhasil melakukan Browser Settings EX-BNIS. Pastikan untuk melakukan test print passbook dari IE.
pause
shutdown -r
exit

:ENDBRIS

cls
echo.
net localgroup administrators userbsi /delete
echo.
msg userbsi /TIME:0 /V /W Berhasil melakukan Browser Settings EX-BRIS. Pastikan untuk melakukan test print passbook dari IE.
pause
shutdown -r
exit

:END
exit