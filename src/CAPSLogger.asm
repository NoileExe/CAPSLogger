
.386
.model	flat, stdcall
option	casemap:none

include		\masm32\INCLUDE\WINDOWS.INC
include		\masm32\INCLUDE\KERNEL32.INC
include		\masm32\INCLUDE\USER32.INC
include		\masm32\INCLUDE\SHELL32.INC
include		\masm32\INCLUDE\ADVAPI32.INC
include		\masm32\INCLUDE\GDI32.INC
include		\masm32\INCLUDE\comdlg32.inc
include		\masm32\INCLUDE\winmm.inc
include		..\res\resources.inc
include		macro.inc
                        
includelib	\masm32\lib\winmm.lib
includelib	\masm32\lib\comctl32.lib
includelib	\masm32\lib\comdlg32
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\shell32.lib
includelib	\masm32\lib\gdi32.lib
includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\advapi32.lib

;----------------------------------------------------------------------------------------------

MAIN_WINDOW_PROC		PROTO	:DWORD, :DWORD, :DWORD, :DWORD
MODULE_ADD_PROC			PROTO	hWnd1:DWORD, hIcon:DWORD 
MODULE_MODIFY_PROC		PROTO	hWnd1:DWORD
MODULE_DELETE_PROC		PROTO	hWnd1:DWORD

;----------------------------------------------------------------------------------------------

public		HINST
public		WM_PRIVATE_MESSAGE

public		isCapsLockOn
public		isNumLockOn
public		isScrollLockOn

;----------------------------------------------------------------------------------------------
;data--data--data--data--data--data--data--data--data--data--		PROC
;----------------------------------------------------------------------------------------------
.data

HINST			DWORD		NULL
HWND_WIN		DWORD		NULL	; дескриптор
H_MENU			DWORD		NULL   

stringClass			DB		"MY_WINDOW", 0
stringCaption		DB		"MY_CAPTION", 0

msgWindow			MSG		<0>

privateMessage		DB  	"MY_PRIVATE_MESSAGE", 0
WM_PRIVATE_MESSAGE	DWORD	NULL

isCapsLockOn		BYTE	FALSE
isNumLockOn			BYTE	FALSE
isScrollLockOn		BYTE	FALSE

szMutexName			DB		"CAPSLoggerV1_Instance_Mutex", 0

;--------------------------------------------------------------------------------------------------
;code--code--code--code--code--code--code--code--code--code--		PROC
;--------------------------------------------------------------------------------------------------
.code

START:
	
	; Защита от повторного запуска
	INVOKE	CreateMutex,	NULL, TRUE, OFFSET szMutexName
	INVOKE	GetLastError
	.IF		EAX == ERROR_ALREADY_EXISTS
		JMP EXIT
	.ENDIF
	
	
	
	INVOKE	GetModuleHandle, NULL
	MOV		HINST, EAX

	CALL	MY_REGISTER_CLASS 
	CMP		EAX, NULL
	JE		EXIT

	INVOKE	CreateWindowEx, NULL, ADDR stringClass, NULL, \
							NULL, 0, 0, 0, 0, \
							NULL, NULL, HINST, NULL

	MOV		HWND_WIN, EAX


MSG_LOOP:
	INVOKE	GetMessage,		ADDR msgWindow, NULL, NULL, NULL
	CMP		EAX, FALSE
	JE		EXIT

	INVOKE	TranslateMessage, ADDR msgWindow
	INVOKE	DispatchMessage, ADDR msgWindow
	JMP		MSG_LOOP

EXIT:
	INVOKE	ExitProcess, NULL

;--------------------------------------------------------------------------------------------------
;											REGISTER CLASS
;-------------------------------------------------------------------------------------------------- 
MY_REGISTER_CLASS	PROC
	LOCAL	_Struct_WNDCLASS:WNDCLASSEX
		
		; Инициализация статусов опций кнопок в зависимости от текущего состояния в системе (при запуске программы)
		INVOKE	GetKeyState, VK_CAPITAL		; Caps Lock
		AND		EAX, 0001h
		MOV		isCapsLockOn, AL
		
		INVOKE	GetKeyState, VK_NUMLOCK
		AND		EAX, 0001h
		MOV		isNumLockOn, AL
		
		INVOKE	GetKeyState, VK_SCROLL
		AND		EAX, 0001h
		MOV		isScrollLockOn, AL
		
		
		MOV		_Struct_WNDCLASS.cbSize, SIZEOF WNDCLASSEX
		MOV		_Struct_WNDCLASS.style, CS_DBLCLKS						; стиль окна

		MOV		_Struct_WNDCLASS.lpfnWndProc, MAIN_WINDOW_PROC			; процедура окна
		MOV		_Struct_WNDCLASS.cbClsExtra, NULL						; дополнительная память для класса
		MOV		_Struct_WNDCLASS.cbWndExtra, NULL						; дополнительная память для  окна
		MOV		EAX,  HINST
		MOV		_Struct_WNDCLASS.hInstance, EAX							; handle приложения

		MOV		_Struct_WNDCLASS.lpszMenuName, NULL						; идентификатор меню
		MOV		_Struct_WNDCLASS.lpszClassName, OFFSET stringClass		; адрес строки класса

		INVOKE	LoadIcon,	HINST, ICON_NO		; load Icon
		MOV		_Struct_WNDCLASS.hIcon, EAX
		
		INVOKE	LoadIcon,	HINST, ICON_NO		; load Icon
		MOV		_Struct_WNDCLASS.hIconSm, EAX

		INVOKE	LoadCursor, NULL, IDC_ARROW
		MOV		_Struct_WNDCLASS.hCursor, EAX


		INVOKE	CreateSolidBrush, 000000h	; возвратит идентификатор кисти

		MOV  _Struct_WNDCLASS.hbrBackground,  EAX

		INVOKE	RegisterClassExA,	ADDR _Struct_WNDCLASS

		RET
		
MY_REGISTER_CLASS	ENDP
;--------------------------------------------------------------------------------------------------
;										WINDOW PROCEDURE
;--------------------------------------------------------------------------------------------------
MAIN_WINDOW_PROC	PROC	USES	EBX ESI EDI \
							hWnd_:DWORD, MESG:DWORD, wParam:DWORD, lParam:DWORD
	LOCAL	_Point:POINT

		CMP		MESG, WM_CREATE
		JE		WMCREATE
		CMP		MESG, WM_COMMAND
		JE		WMCOMMAND

		mCMP	MESG, WM_PRIVATE_MESSAGE
		JE		WMPRIVATEMESSAGE

		CMP		MESG, WM_TIMER
		JE		WMTIMER

		CMP		MESG, WM_KEYUP
		JE		WMKEYUP

		CMP		MESG, WM_DESTROY
		JE		WMDESTROY


	DEF_:
		INVOKE	DefWindowProc,		hWnd_, MESG, wParam, lParam
		JMP		FINISH

	WMCOMMAND:
		MOV		EAX, wParam
		AND		EAX, 0000FFFFh	; идентификатор элемента меню иконки-в-трэе
		
		.IF		EAX == 10 
			JMP		WMDESTROY
		.ENDIF
		
		JMP		FINISH

	WMCREATE:

		INVOKE	RegisterWindowMessage,	ADDR privateMessage
		MOV		WM_PRIVATE_MESSAGE, EAX
		INVOKE	LoadMenu,	HINST, 99
		INVOKE	GetSubMenu,	EAX, 0
		MOV		H_MENU, EAX

		INVOKE	LoadIcon,	HINST, ICON_NO
		INVOKE	MODULE_ADD_PROC,	hWnd_, EAX

		INVOKE	SetTimer,	hWnd_, 1, 500, NULL

		JMP		WMKEYUP

	WMPRIVATEMESSAGE:
		;wParam = ID icon
		.IF		lParam == WM_RBUTTONDOWN
			INVOKE	SetForegroundWindow, hWnd_
			INVOKE	GetCursorPos, ADDR _Point
			INVOKE	TrackPopupMenu,		H_MENU, NULL, \
										_Point.x, _Point.y, \
										NULL, hWnd_, NULL
		.ENDIF

		JMP		FINISH

	WMTIMER:
		.IF		wParam == 1
			JMP		WMKEYUP
		.ENDIF

		JMP		FINISH

	WMKEYUP:
		INVOKE	GetKeyState, VK_CAPITAL		; Caps Lock
		AND		EAX, 0001h
		CMP		AL, isCapsLockOn
		; не изменилось — пропустить
		JE		@F
			MOV isCapsLockOn, AL	; обновить состояние
		@@:
		
		; --- Проверка Num Lock ---
		INVOKE	GetKeyState, VK_NUMLOCK
		AND		EAX, 0001h
		CMP AL, isNumLockOn
		JE  @F
			MOV isNumLockOn, AL
		@@:

		; --- Проверка Scroll Lock ---
		INVOKE	GetKeyState, VK_SCROLL
		AND		EAX, 0001h
		CMP AL, isScrollLockOn
		JE  @F
			MOV isScrollLockOn, AL
		@@:

		;смена иконки в трее
		INVOKE	MODULE_MODIFY_PROC,		hWnd_

		JMP		FINISH 



	WMDESTROY:
		INVOKE	MODULE_DELETE_PROC,		hWnd_
		INVOKE	KillTimer,				hWnd_, 1
		INVOKE	PostQuitMessage,		FALSE
		
	FINISH:
		RET		16
		
MAIN_WINDOW_PROC	ENDP

END  START

