
.386
.model	flat, stdcall
option	casemap:none

include		\masm32\INCLUDE\WINDOWS.INC
include		\masm32\INCLUDE\KERNEL32.INC
include		\masm32\INCLUDE\USER32.INC
include		\masm32\INCLUDE\SHELL32.INC
include		\masm32\INCLUDE\ADVAPI32.INC
include		\masm32\INCLUDE\GDI32.INC
include		..\res\resources.inc
include		macro.inc

includelib	\masm32\lib\comctl32.lib
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\gdi32.lib
includelib	\masm32\lib\shell32.lib
includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\advapi32.lib

;----------------------------------------------------------------------------------------------

MODULE_ADD_PROC			PROTO	hWnd1:DWORD, hIcon:DWORD
MODULE_MODIFY_PROC		PROTO	hWnd1:DWORD, hIcon:DWORD, hOption:DWORD
MODULE_DELETE_proc		PROTO	hWnd1:DWORD 
MODULE_DELETE_PROC		PROTO	hWnd1:DWORD

;----------------------------------------------------------------------------------------------

EXTERN		HINST:DWORD 
EXTERN		WM_PRIVATE_MESSAGE:DWORD

;----------------------------------------------------------------------------------------------
;data--data--data--data--data--data--data--data--data--data--		PROC
;----------------------------------------------------------------------------------------------
.data

stringNO			DB		"Caps/Num/Scroll LOCK выключены", 0
stringCAPS			DB		"ВКЛЮЧЕН Caps LOCK", 0
stringNUM			DB		"ВКЛЮЧЕН Num LOCK", 0
stringSCROLL		DB		"ВКЛЮЧЕН Scroll LOCK", 0
NULL_STRING			DB		0, 0, 0, 0



;----------------------------------------------------------------------------------------------
;code--code--code--code--code--code--code--code--code--code--		PROC
;----------------------------------------------------------------------------------------------
.code 
START:
;----------------------------------------------------------------------------------------------
;												ADD
;----------------------------------------------------------------------------------------------
MODULE_ADD_PROC		PROC	hWnd1:DWORD, hIcon:DWORD
	LOCAL	_icon_Notify:NOTIFYICONDATA
		
		MOV		_icon_Notify.cbSize,	SIZEOF NOTIFYICONDATA
		mMOVE	_icon_Notify.hwnd,		hWnd1
		MOV		_icon_Notify.uFlags,	NIF_ICON + NIF_MESSAGE + NIF_TIP
		MOV		_icon_Notify.uID,		10
		
		;-----  делаем подсказку
		INVOKE	RtlZeroMemory,		ADDR _icon_Notify.szTip, 64 
		INVOKE	lstrlen,			ADDR stringNO
		INVOKE	RtlMoveMemory,		ADDR _icon_Notify.szTip, ADDR stringNO, EAX
		
		mMOVE	_icon_Notify.uCallbackMessage,	WM_PRIVATE_MESSAGE
		
		INVOKE	LoadIcon,	HINST, ICON_NO
		MOV		_icon_Notify.hIcon, EAX

		INVOKE	Shell_NotifyIconA,		NIM_ADD, ADDR _icon_Notify
				
		RET		8

MODULE_ADD_PROC		ENDP
;----------------------------------------------------------------------------------------------
;											MODIFY
;----------------------------------------------------------------------------------------------
MODULE_MODIFY_PROC	PROC	hWnd1:DWORD, hIcon:DWORD, hOption:DWORD
	LOCAL	_icon_Notify:NOTIFYICONDATA
		
		MOV		_icon_Notify.cbSize,	SIZEOF NOTIFYICONDATA
		mMOVE	_icon_Notify.hwnd,		hWnd1
		MOV		_icon_Notify.uFlags,	NIF_ICON + NIF_MESSAGE + NIF_TIP
		MOV		_icon_Notify.uID,		10
		
		;-----  делаем подсказку
		INVOKE	RtlZeroMemory,	ADDR _icon_Notify.szTip,	64
		
		.IF		hOption == ICON_NO
			INVOKE	lstrlen, ADDR stringNO
			INVOKE	RtlMoveMemory, ADDR _icon_Notify.szTip, ADDR stringNO, EAX
		.ELSEIF	hOption == ICON_CAPS
			INVOKE	lstrlen, ADDR stringCAPS
			INVOKE	RtlMoveMemory, ADDR _icon_Notify.szTip, ADDR stringCAPS, EAX
		.ELSEIF	hOption == ICON_NUM
			INVOKE	lstrlen, ADDR stringNUM
			INVOKE	RtlMoveMemory, ADDR _icon_Notify.szTip, ADDR stringNUM, EAX
		.ELSEIF	hOption == ICON_SCRL
			INVOKE	lstrlen, ADDR stringSCROLL
			INVOKE	RtlMoveMemory, ADDR _icon_Notify.szTip, ADDR stringSCROLL, EAX
		.ENDIF
		
		mMOVE	_icon_Notify.uCallbackMessage,	WM_PRIVATE_MESSAGE
		
		mMOVE	_icon_Notify.hIcon,	hIcon
		
		INVOKE	Shell_NotifyIconA,		NIM_MODIFY, ADDR _icon_Notify
		
		RET		8
		
MODULE_MODIFY_PROC	ENDP
;----------------------------------------------------------------------------------------------
;											DELETE
;----------------------------------------------------------------------------------------------
MODULE_DELETE_PROC	PROC	hWnd1:DWORD
	LOCAL	_icon_Notify:NOTIFYICONDATA
		
		MOV		_icon_Notify.cbSize,	SIZEOF NOTIFYICONDATA
		mMOVE	_icon_Notify.hwnd,		hWnd1
		MOV		_icon_Notify.uFlags,	NIF_ICON
		MOV		_icon_Notify.uID,		10

		INVOKE   Shell_NotifyIconA,		NIM_DELETE, ADDR _icon_Notify
		
		RET		4
	
MODULE_DELETE_PROC	ENDP
END
