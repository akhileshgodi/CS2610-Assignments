;strings.asm : Prompts the user to enter a string and prints 
;			   the sum of all numbers in the string. Where the sum is <=255
;Author : Akhilesh G (CS10B037)
;Date : January 2012

	.model small
	
	.stack 256
	
CR equ 13d 		;Carriage Return ASCII value
LF equ 10d		;Next Line ASCII Value

.data
	
	msg1 	db "Enter a string : " ,CR,LF,'$'	
	msg2 	db CR,LF,'The sum of numbers present in the string is : $'
	string  db  80 dup('$')
	
.code

	start:
			mov ax, @data								;Stores the address of data segment in the accumulator register sx
			mov ds, ax									;Copies the value in the accumulator to the ds register
			
			lea dx, msg1								;loads effective address of msg1 into dx
			mov ah, 09h									;In C: printf. Prints msg1
			int 21h										;Interrupt call
			
		;The lines below are equivalent to the gets() function in C. 
			mov ax, offset string						;Moves the effective address of the string to be taken into the accumulator		
			push ax										;Pushes the present values into the stack
			push bx										;Every push is accompanied by a pop at the end
			push cx					
			push dx
		
			mov bx,ax									;bx now holds the address to the first location of the string
			call getc									;Reads the first character in the input stream 
														;getc subroutine is below our main code and copies the value from input into "al" register
			mov byte ptr [bx], al						;copies the value of accumulator al to the byte pointer bx which stores the location in 														;the string
		
		get_loop:
			cmp al,CR									;compare al, CR (Computes al - CR)
			je get_fin									;if zero then jump to get_fin
			
			inc bx										;moves bx pointer to next position so that number is stored
			call getc									;reads a character from input
			mov byte ptr [bx], al						;moves al register into bx
			jmp get_loop								;loops it until carriage return
			
		get_fin:
			mov byte ptr [bx], '$'						;stores sentinel character at the end of the string
			pop dx										;Pops the values that were pushed into the stack
			pop cx
			pop bx
			pop ax
				
			lea dx, msg2								;loads eff. address of msg2 in dx
			mov ah, 09h									;call to print the string
			int 21h										;prints the string
			
			;lea dx, string
			mov ax, offset string						;moves the effective address of the string that was taken into ax
			mov bx, ax									;bx now has the address
			mov cl , 0									;cl will have the sum of the numbers
			mov al, byte ptr [bx]						;moves the address of the first byte of string to al
			
		;End of gets equivalent subroutine
			
		;Loop to sum the numbers in the string
			sum_loop:
				cmp al,'$'								;computes al-'$'
				je done									;if al=='$' then goto done
				cmp al, 57								;computes al - '9'
				jg invalid								;if it is greater than zero jump to invalid
				cmp al, 48								;computes al - '0'
				jl invalid								;if al is less than zero then jump to invalid
				add cl, al								;the loop continues if al<='9' and al>= '0'
				sub cl, 48								;subtract ascii value of '0' to store it as the corresponding number
				inc bx									;next byte in memory so increment
				mov al, byte ptr[bx]					;move the value of the memory location of bx to al
				jmp sum_loop							;keeps looping until $ is seen
			
			invalid:									;comes here if the character read is > '9' or less than '0'
				inc bx									;increment the bx register to read the next character
				mov al, byte ptr [bx]					;moves bx to al
				jmp sum_loop							;go back to the beginning of the sum loop
 		
			done:
				mov ax,0000h							;initializes ax register to 0
				
		;Printing the number in decimal format. cl has the sum
				
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
				
				;The command below says return to DOS
				mov ax, 4c00h
				int 21h
		
		
 	;Sub routine for getc used in gets equivalent	
	getc:
	
		push bx
		push cx
		push dx
		
		mov ah, 1h
		int 21h
		
		pop dx
		pop cx
		pop bx
			
	ret
		
end start											;END OF THE PROGRAM
