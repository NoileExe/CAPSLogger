
; --------- Стандартные константы (Windows API совместимый стиль) ---------

NULL    EQU		0
TRUE    EQU		1
FALSE   EQU		0

;--------------------------------------------------------------------------

; Копирование
mMOVE	MACRO	M1, M2
	
	PUSH	M2
	POP		M1
	
ENDM

;--------------------------------------------------------------------------

; Сравнение
mCMP	MACRO	M1, M2
	
	MOV		EAX,  M2
	CMP		M1,   EAX
	
ENDM

;--------------------------------------------------------------------------

; Сложение M1 + M2. Результат в M1
mADD	MACRO	M1, M2
	
	MOV		EAX,  M2
	ADD		M1,   EAX
	
ENDM

;--------------------------------------------------------------------------

; Разница M1 - M2. Результат в M1
mSUB	MACRO  M1, M2
	
	MOV		EAX,  M2
	SUB		M1,   EAX
	
ENDM

;--------------------------------------------------------------------------

; Разница M1 - M2. Результат в EAX
mSUBeax	MACRO	M1, M2
	
	PUSH	ECX
	PUSH	M1
	PUSH	M2
	POP		ECX
	POP		EAX
	SUB		EAX,  ECX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

; Сложение M1 + M2. Результат в EAX
mADDeax	MACRO	M1, M2
	
	MOV		EAX,  M1
	ADD		EAX,  M2
	
ENDM

;--------------------------------------------------------------------------

;  Сдвиг содержимого M1 вправо на M2 бит. Результат в M1
mSHR	MACRO	M1, M2
	
	PUSH	ECX
	MOV		EAX,  M1
	MOV		ECX,  M2
	SHR		EAX,  CL
	MOV		M1,   EAX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

;  Сдвиг содержимого M1 влево на M2 бит. Результат в M1
mSHL	MACRO	M1, M2
	
	PUSH	ECX
	MOV		EAX,  M1
	MOV		ECX,  M2
	SHL		EAX,  CL
	MOV		M1,   EAX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

;  Сдвиг содержимого M1 вправо на M2 бит. Результат в EAX
mSHReax	MACRO	M1, M2
	
	PUSH	ECX
	MOV		EAX,  M1
	MOV		ECX,  M2
	SHR		EAX,  CL
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

;  Сдвиг содержимого M1 влево на M2 бит. Результат в EAX
mSHLeax	MACRO	M1, M2
	
	PUSH	ECX
	MOV		EAX,  M1
	MOV		ECX,  M2
	SHL		EAX,  CL
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

; Умножение M1 * M2. Результат в M1
mMUL	MACRO	M1, M2
	
	PUSH	ECX
	MOV		ECX,  M2
	XOR		EDX,  EDX
	MOV		EAX,  M1
	MUL		ECX
	MOV		M1,   EAX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

; Деление M1 / M2. Результат в M1
mDIV	MACRO	M1, M2
	
	PUSH	ECX
	MOV		ECX,  M2
	XOR		EDX,  EDX
	MOV		EAX,  M1
	DIV		ECX
	MOV		M1,	  EAX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

; Умножение M1 * M2. Результат в EAX
mMULeax	MACRO	M1, M2

	PUSH	ECX
	MOV		ECX,  M2
	XOR		EDX,  EDX
	MOV		EAX,  M1
	MUL		ECX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------

; Деление M1 / M2. Результат в EAX
mDIVeax	MACRO	M1, M2
	
	PUSH	ECX
	MOV		ECX, M2
	XOR		EDX, EDX
	MOV		EAX, M1
	DIV		ECX
	POP		ECX
	
ENDM

;--------------------------------------------------------------------------
