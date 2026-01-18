@echo off
setlocal

set "EXE_PATH=..\bin\CAPSLogger.exe"

if not exist "%EXE_PATH%" (
	eecho [!] Executable not found: %EXE_PATH%
	echo     Please run '1_Assemble.bat' and '2_Link.bat' first.
	pause
	exit /b 1
)

:: Ищем TD32 (Turbo Debugger) в типичных местах
set "TD32_FOUND="
for %%D in (
	"C:\masm32\bin\td32.exe"
	"C:\Tools\TD32\td32.exe"
	"C:\Borland\BCC55\Bin\TD32.EXE"
	"%USERPROFILE%\Downloads\td32\td32.exe"
	"%USERPROFILE%\Desktop\td32\td32.exe"
) do (
	if exist "%%~D" (
		set "TD32_EXE=%%~D"
		set "TD32_FOUND=1"
		goto :found
	)
)

:found
if not defined TD32_FOUND (
	echo [!] TD32 ^(Turbo Debugger^) not found.
	echo     Get it from Borland C++ 5.5 or place td32.exe manually.
	echo     Supported locations:
	echo         - C:\masm32\bin\
	echo         - C:\Borland\BCC55\Bin\
	echo         - Your Desktop or Downloads folder
	pause
	exit /b 1
)

echo [*] Launching %EXE_PATH% in TD32...
start "" "!TD32_EXE!" "%EXE_PATH%"
exit /b 0