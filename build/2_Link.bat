@echo off
setlocal

:: ==============================
::  STEP 2: Linking
:: ==============================

echo __________________________STEP_TWO__________________________
echo					  2nd step: Linking

:: === Настройки ===
set "MASM32_DIR=C:\masm32"
set "OBJ_DIR=..\obj"
set "RES_DIR=..\res"
set "BIN_DIR=..\bin"
set "EXE_NAME=CAPSLogger.exe"

:: Создаём выходную директорию
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

:: Пути к объектным файлам и ресурсу
set "OBJ_FILES=%OBJ_DIR%\CAPSLogger.obj %OBJ_DIR%\TrayStatusChange.obj"
set "RES_FILE=%OBJ_DIR%\resources.res"

:: Проверяем наличие link.exe
set "LINK_EXE=%MASM32_DIR%\bin\link.exe"
if not exist "%LINK_EXE%" (
	echo [!] Error: link.exe not found at '%LINK_EXE%'
	echo     Please install MASM32 SDK to C:\masm32
	pause
	exit /b 1
)

:: Проверяем наличие всех .obj файлов
for %%f in (%OBJ_FILES%) do (
	if not exist "%%f" (
		echo [!] Error: Object file not found: %%f
		echo     Run 'assemble.bat' first.
		pause
		exit /b 1
	)
)

:: Проверяем наличие .res файла
if not exist "%RES_FILE%" (
	echo [!] Error: Resource file not found: %RES_FILE%
	echo     Make sure RC.exe was run successfully.
	pause
	exit /b 1
)

:: === Линковка ===
echo [*] Linking executable: %BIN_DIR%\%EXE_NAME%
"%LINK_EXE%" /SUBSYSTEM:WINDOWS /OUT:"%BIN_DIR%\%EXE_NAME%" %OBJ_FILES% "%RES_FILE%"
if %errorlevel% neq 0 (
	echo [!] Linking failed.
	pause
	exit /b 1
)

echo.
echo [+] Successfully linked: %BIN_DIR%\%EXE_NAME%
pause
exit /b 0