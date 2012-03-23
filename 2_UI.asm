;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;	Author : Akhilesh Godi (CS10B037)																		  ;;;;
;;;;	CS2610 - Assignment 2																					  ;;;;
;;;;	This program takes a an alphanumeric string from the user and prints the sum of the numbers in the string.;;;;
;;;;	Emphasis is given on the use of procedures/sub-routines. Graphics/Colours have been used to "prettify"	  ;;;;
;;;;	the program. 																							  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.model small	
	.stack 256

CR equ 13d 		;Carriage Return ASCII value
LF equ 10d		;Next Line ASCII Value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;											DATA SEGMENT														   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
	
	msg1 	db "Enter a string : ",'$'	
	msg2 	db 'The sum of numbers present in the string is : $'
	msg3    db "Press any key to terminate.$"
	string  db  80 dup('$')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;											CODE SEGMENT														   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code
	start:
		
	  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;Going into the text mode and setting background and font colors. Yo! :D
		mov al, 03h						; Text Mode
		mov ah, 0						; Set Video Mode
		int 10h     					; Do it!
		
		mov ax,0600h					;06h for clearing the screen, 00h for full screen
		mov bh,31h						;0h for black background, 7h for white foreground
		mov cx,0000h					;top left coordinates
		mov dx,184fh					;bottom right coordinates
		int 10h							;Interrupt \m/	
		
		;Positioning my cursor to the desired location. Centre is awesome
		mov dh, 10						;Row Number 10
		mov dl, 20						;Column Number 20
		mov bh, 0						;Page number 0
		mov ah, 2						;Position my cursor
		int 10h							;Gooo!!!
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;Load Data Segment and the Main Program begins here!
		mov ax, @data					;Stores the address of data segment in the accumulator register sx
		mov ds, ax						;Copies the value in the accumulator to the ds register
		
		lea dx, msg1					;loads effective address of msg1 into dx
		mov ah, 09h						;In C: printf. Prints msg1
		int 21h							;Interrupt call
		
		mov dh, 11
		mov dl, 20
		mov bh, 00
		mov ah, 02
		int 10h
		
		;Go read and store the string!
		call gets			
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;Loop to sum the numbers in the string
			
		mov ax, offset string		;moves the effective address of the string that was taken into ax
		mov bx, ax					;bx now has the address
		mov cl , 0					;cl will have the sum of the numbers
		mov al, byte ptr [bx]		;moves the address of the first byte of string to al
		
		sum_loop:
			cmp al,'$'				;computes al-'$'
			je done					;if al=='$' then goto done
			cmp al, 57				;computes al - '9'
			jg invalid				;if it is greater than zero jump to invalid
			cmp al, 48				;computes al - '0'
			jl invalid				;if al is less than zero then jump to invalid
			add cl, al				;the loop continues if al<='9' and al>= '0'
			sub cl, 48				;subtract ascii value of '0' to store it as the corresponding number
			inc bx					;next byte in memory so increment
			mov al, byte ptr[bx]	;move the value of the memory location of bx to al
			jmp sum_loop			;keeps looping until $ is seen
		
		invalid:					;comes here if the character read is > '9' or less than '0'
				inc bx					;increment the bx register to read the next character
				mov al, byte ptr [bx]	;moves bx to al
				jmp sum_loop			;go back to the beginning of the sum loop
 		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;cl has the sum. We're moving out cursor below the previous line but aligned
		done:
				
			mov dh, 12
			mov dl, 20
			mov bh, 00
			mov ah, 02
			int 10h
				
			lea dx, msg2			;loads eff. address of msg2 in dx
			mov ah, 09h				;call to print the string
			int 21h					;prints the string
				
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;Printing the number in decimal format. cl has the sum
				
		call display_number
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
	
		mov dh, 17
		mov dl, 20
		mov bh, 00
		mov ah, 02
		int 10h
		
		lea dx, msg3
		mov ah, 09h
		int 21h
		
		call getc
		
		mov ax,0003h
		int 10h
		
		;Clear Screen. Go back to the normal mode!
		mov ax,0600h				;06h for clearing the screen, 00h for full screen
		mov bh,07h					;0h for black background, 7h for white foreground
		mov cx,0000h				;top left coordinates
		mov dx,184fh				;bottom right coordinates
		int 10h						;Interrupt \m/	
				
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
		;The command below says return to DOS
		mov ax, 4c00h
		int 21h
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
;;;;																												 ;;;;
;;;;						 				PROCEDURES ARE LISTED BELOW											     ;;;;
;;;;																												 ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	;Sub routine for getc used in gets equivalent	
	
         getc PROC
	
			push bx
			push cx
			push dx
			
			mov ah, 1h
			int 21h
			
			pop dx
			pop cx
			pop bx
			
			ret
	    getc ENDP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Start of gets Procedure
		gets PROC	
			
			mov ax, offset string			;Moves the effective address of the string to be taken into the accumulator		
			push ax							;Pushes the present values into the stack
			push bx							;Every push is accompanied by a pop at the end
			push cx					
			push dx
		
			mov bx,ax						;bx now holds the address to the first location of the string
			call getc						;Reads the first character in the input stream 
											;getc subroutine is below our main code and copies the value from input into "al" register
			mov byte ptr [bx], al			;copies the value of accumulator al to the byte pointer bx which stores the location in 										;the string
		
			get_loop:
				cmp al,CR					;compare al, CR (Computes al - CR)
				je get_fin					;if zero then jump to get_fin
				
				inc bx						;moves bx pointer to next position so that number is stored
				call getc					;reads a character from input
				mov byte ptr [bx], al		;moves al register into bx
				jmp get_loop				;loops it until carriage return
			
			get_fin:
				mov byte ptr [bx], '$'		;stores sentinel character at the end of the string
			
			pop dx						;Pops the values that were pushed into the stack
			pop cx
			pop bx
			pop ax
			ret
			
		gets ENDP
		;End of gets equivalent subroutine
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	display_number PROC
				
				mov ax,0000h
				;Gives the decimal number in the hundredth position
				mov al, cl								;moves the stored value into al register				
				mov bl, 100								;move bl by 100
				div bl									;divide the value in al by 100
				mov bh,ah								;ah stores the remainder. Move it to bh (Has remainder).
				mov bl,al								;al stores the quotient. Move it to bl.
				
				add bl, 48								;adds '0' to get the character equivalent of the number in bl
				mov dl,bl								;moves the value in bl to the data register
				mov ah,02h								;In C: putc equivalent
				int 21h									;Interrupt
			
				;Printing the value in the tens place now				
				mov ax,0000h							;Loads 0 into the accumulator again
				
				mov al, bh								;Moves the remainder to al
				mov bl, 10								;move bl by 10
				div bl									;Divide accumulator by 10 		
				mov bh,ah								;Moves ah to bh - Has the remainder
				mov bl,al								;Moves al to bl - Has the quotient i.e Tens place
				
				add bl, 48								;adds '0' to get the character equivalent of the number in bl
				mov dl,bl								;moves the value in bl to the data register
				mov ah,02h								;In C: putc equivalent
				int 21h									;Interrupt
				
				;Printing Zero's place
				add bh, 48
				mov dl,bh
				mov ah, 02h
				int 21h 
				ret
				 
	display_number ENDP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	end start 
