@echo off
setlocal

set "EXE_PATH=..\bin\CAPSLogger.exe"

if not exist "%EXE_PATH%" (
	echo [!] Executable not found: %EXE_PATH%
	echo     Please run '1_Assemble.bat' and '2_Link.bat' first.
	pause
	exit /b 1
)

:: Ищем OllyDbg в типичных местах
set "OLLY_FOUND="
for %%D in (
	"C:\Program Files\OllyDbg\ollydbg.exe"
	"C:\Program Files (x86)\OllyDbg\ollydbg.exe"
	"%LOCALAPPDATA%\Programs\OllyDbg\ollydbg.exe"
	"%USERPROFILE%\Desktop\ollydbg\ollydbg.exe"
) do (
	if exist "%%~D" (
		set "OLLY_EXE=%%~D"
		set "OLLY_FOUND=1"
		goto :found
	)
)

:found
if not defined OLLY_FOUND (
	echo [!] OllyDbg not found.
	echo     Download it from https://www.ollydbg.de/
	echo     And install it to one of the standard locations.
	pause
	exit /b 1
)

echo [*] Launching %EXE_PATH% in OllyDbg...
start "" "%OLLY_EXE%" "%EXE_PATH%"
exit /b 0