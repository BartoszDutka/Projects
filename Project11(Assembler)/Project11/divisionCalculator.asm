INCLUDE Irvine32.inc

.data
codeTitle		BYTE "  ---------  Iloraz dwoch liczb calkowitych binarnych  ---------  ", 0
directions		BYTE "Wprowadz 2 binarne liczby.", 0
prompt1			BYTE "Pierwsza liczba: ", 0
prompt2			BYTE "Druga liczba: ", 0
remaintxt		BYTE " reszta ", 0
divide			BYTE " / ", 0
equals			BYTE " = ", 0
num1			DWORD ?
num2			DWORD ?
total           DWORD ?
remainder		DWORD ?

.code
main PROC
	; Wypisz tytul
		mov		edx, OFFSET codeTitle
		call	WriteString
		call	CrLf

	; Zapytanie o piewsza liczbe
		mov		edx, OFFSET prompt1
		call	WriteString
		call	ReadHex
		mov		num1, eax

	; Zapytanie o druga liczbe
		mov		edx, OFFSET prompt2
		call	WriteString
		call	ReadHex
		mov		num2, eax

	; Wykonaj obliczenia metoda nierestytucyjna
		mov		eax, num1
		mov		ebx, num2
		xor		edx, edx
		idiv	ebx
		mov		total , eax
		mov		remainder , edx
		call	CrLf
		
	; Pokaz wynik metody bez restytucji
		; Pokaz num1
		mov		eax, num1
		call	WriteHex
		; Dzielenie
		mov		edx, OFFSET divide
		call	WriteString
		; Pokaz num2
		mov		eax,  num2
		call	WriteHex
		; Rownosc
		mov		edx, OFFSET equals
		call	WriteString
		; Suma
		mov		eax, total
		call	WriteHex
		mov		edx, OFFSET remaintxt
		call	WriteString
		mov        eax, remainder
		call	WriteHex
		call	CrLf
		call	CrLf

    ; Przeprowadzenie obliczen metoda restytucyjna
        mov     eax, num1
        mov     ebx, num2
        xor     edx, edx
        div     ebx
        mov     total, eax
        mov     remainder, edx
        call    CrLf

    ; Pokaz wynik metody z restytucja
        ; Pokaz num1
        mov     eax, num1
        call    WriteHex
        ; Rownosc
        mov     edx, OFFSET divide
        call    WriteString
        ; Pokaz num2
        mov     eax,  num2
        call    WriteHex
; Rownosc
mov edx, OFFSET equals
call WriteString
; Suma
mov eax, total
call WriteHex
mov edx, OFFSET remaintxt
call WriteString
mov eax, remainder
call WriteHex
call CrLf
call CrLf
exit    
main ENDP
END main