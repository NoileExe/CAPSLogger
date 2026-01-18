@echo off
setlocal enabledelayedexpansion

:: ==============================
::  STEP 1: Assemble & Compile Resources
::  Compatible with MASM32 SDK
:: ==============================

echo __________________________STEP_ONE__________________________
echo					1st step: Translation

:: === Настройки (можно вынести в отдельный config.bat при желании) ===
set "MASM32_DIR=C:\masm32"
set "SRC_DIR=..\src"
set "RES_DIR=..\res"
set "OBJ_DIR=..\obj"

:: Создаём выходную директорию для .obj файлов
if not exist "%OBJ_DIR%" mkdir "%OBJ_DIR%"

:: === Поиск ml.exe и rc.exe ===
set "ML_EXE=%MASM32_DIR%\bin\ml.exe"
set "RC_EXE=%MASM32_DIR%\bin\rc.exe"

if not exist "%ML_EXE%" (
	echo [!] Error: ml.exe not found at '%ML_EXE%'
	echo     Please install MASM32 SDK to C:\masm32
	echo     Or update MASM32_DIR in this script.
	pause
	exit /b 1
)

if not exist "%RC_EXE%" (
	echo [!] Error: RC.exe not found at '%RC_EXE%'
	pause
	exit /b 1
)

:: === Ассемблируем модули ===
set MODULES=CAPSLogger.asm TrayStatusChange.asm

for %%f in (%MODULES%) do (
	echo [*] Assembling %%f ...
	"%ML_EXE%" /coff /c /Fo"%OBJ_DIR%\%%~nf.obj" "%SRC_DIR%\%%f"
	if !errorlevel! neq 0 (
		echo [!] Failed to assemble %%f
		pause
		exit /b 1
	)
)

:: === Компилируем ресурсы ===
echo [*] Compiling resources...
"%RC_EXE%" /v "%RES_DIR%\resources.rc"
if %errorlevel% neq 0 (
	echo [!] Resource compilation failed
	pause
	exit /b 1
)

move "%RES_DIR%\resources.res" "%OBJ_DIR%\resources.res" >nul
if %errorlevel% neq 0 (
	echo [!] Failed to move %RES_DIR%\resources.res file
	pause
	exit /b 1
)

echo.
echo [+] Step 1 completed successfully.
pause
exit /b 0