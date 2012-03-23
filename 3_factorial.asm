;@Author : Akhilesh Godi (CS10B037) - Assignment 5.2
;Take a number as input and print its factorial (32 bit).
    .model small	
	.stack 256

CR equ 13d 		;Carriage Return ASCII value
LF equ 10d		;Next Line ASCII Value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;											DATA SEGMENT														   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
	
	number      dw  0
	factorial_right   dw  1
	factorial_left 	  dw  0
	temp        dw  0
	msg1 	db "Enter a number to find its factorial: ",'$'	
	msg2	db "Error. Cannot compute. Out of bounds.",'$'
	msg3	db "You entered a negative number. Factorial does not exist.",'$'
	msg4	db "Factorial of the number you typed is : ",'$'
	msg5	db "Press any key to exit.",'$'
	i   db  1
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;											CODE SEGMENT														   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.code

	START:	
		
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
		
		mov ax, @data					;Stores the address of data segment in the accumulator register ax
		mov ds, ax						;Copies the value in the accumulator to the ds register
		
 	
		lea dx, msg1					;loads effective address of msg1 into dx
		mov ah, 09h						;In C: printf. Prints msg1
		int 21h							;Interrupt call
		
		call readNumber					;Reads the number entered by the user. 
										;The program does not allow the user to enter a number more than 2 digits		
    	
    	mov dx, LF						
		mov ah, 02h						;Printing next line character
		int 21h							;Do it.
		
		
		mov cx,number					;cx now has the inputted number
		
		cmp cx,13						;Factorial of a 13 is more than 32 bits
		jge dontdo						;For any number greater than 12 Dont compute factorial
		
		cmp cx,0
		jl	finish
			
		mov temp,cx						;If it is in our range then temp has cx
	
		call fact						;Compute the factorial and store it in factorial_left:factorial_right
		
		push dx
		push cx
		push bx
		push ax
		
		mov dh, 12
		mov dl, 20
		mov bh, 00
		mov ah, 02
		int 10h
				
		lea dx, msg4			;loads eff. address of msg2 in dx
		mov ah, 09h				;call to print the string
		int 21h					;prints the string
			
		pop ax
		pop bx
		pop cx
		pop dx
		
		mov dx,factorial_left			;
		mov ax,factorial_right			;DX:AX will now have the factorial value
		
		call Print				;Print the 32 bit number
    	
    	mov dx, LF
		mov ah, 02h						;Print new line character
		int 21h							;Do it
	
	
		finish:
			mov dh, 17
			mov dl, 20
			mov bh, 00
			mov ah, 02
			int 10h
		
			lea dx, msg5
			mov ah, 09h
			int 21h
		
			mov ah,01h
			int 21h
			
			mov ax,0003h
			int 10h
		
			;Clear Screen. Go back to the normal mode!
			mov ax,0600h				;06h for clearing the screen, 00h for full screen
			mov bh,07h					;0h for black background, 7h for white foreground
			mov cx,0000h				;top left coordinates
			mov dx,184fh				;bottom right coordinates
			int 10h						;Interrupt \m/	
	
			
    		mov ax, 4c00h				;Return to DOS
			int 21h						;Do it

		dontdo: 
			lea dx,msg2					;Comes here if number entered is more than 12
			mov ah,09h					;Print an error message
			int 21h						;Do it.
			jmp finish					;jump to finish
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
;;;;																												 ;;;;
;;;;						 				PROCEDURES ARE LISTED BELOW											     ;;;;
;;;;																												 ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	   fact PROC
	    
	        push ax						;Save the previous values by pushing them on the stack
	        push bx		
	        push cx
	        push dx
	        
	        cmp number,0				;Compare number and zero
	        jl retflag					;If the number is less than zero, then dont do anything. 
	        
	        cmp i,1						;Compares i and 1. Is it the first time that fact is being called?
	        je flag1					;If yes. Initialize factorial value to 1.
	        	
   flagback:cmp temp,1					;temp has the number to be multiplied.	
            jle retflag					;If temp has gone to 1. Dont multiply anymore and return from this procedure.
            dec temp
            mov cx,temp
            push cx
            call fact
            pop cx
            mov temp,cx
            inc temp
            mov dx,0
            mov ax,factorial_right	
            mov cx, temp	
            mul cx	
            mov factorial_right,ax		;factorial_right will have the lower 16 bytes of the factorial 
            push ax	
            push dx	
            mov ax,factorial_left		
            mov bx,temp	
            mul bx	
            pop dx	
            add dx,ax	
            pop ax
            mov factorial_left,dx		;factorial_left will have the higher 16 bytes of the factorial
            	
		retflag :   pop dx
		            pop cx
		            pop bx
		            pop ax
		            ret
		
		flag1 : mov factorial_right,1		;Comes here the first time when fact is called
		        dec i
		        jmp flagback
		fact ENDP
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
     	readNumber PROC   
     		
     		push ax
     		push bx
     		push cx
     		push dx
     		
     		mov ah,01h
			int 21h
			mov ah,0
			sub ax,48
			mov number,ax
		
     		mov ah,01h
     		int 21h
     		cmp al,CR
     		je doneread
     		cmp al,LF
     		je doneread
     		mov ah,0
     		sub ax,48
     		mov cx,ax
     		mov ax,number
     		mov bx,10
     		mul bx
     		add ax,cx
     		mov number,ax
     		
     		
     		doneread : 	pop dx
     					pop cx
     					pop bx
     					pop ax
     					ret
     		readNumber ENDP
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Print PROC
				; SI:DI has the divisor
			  	; BP has the character count
	  		push ax
	  		push bx
	  		push cx
	  		push dx
	  		push di
	  		push si
	  		push bp    
	  
	  		mov si,03B9Ah   ;Divisor (SI:DI)
	  		mov di,0CA00h   ;[si:di] = 10^10 in decimal. (Initial divisor)
	  		mov bp,0        ;Also mov bp,0
	
			loop1:               			;Main Loop : for each number
	  			mov cx,si       
	  			mov bx,di       			;[cx:bx] should have the divisor. 
	  
	  			CALL Divide   			
	  			;[dx:ax] has the quotient. [cx:bx] has the remainder.
	 			
	 			cmp ax,0	      
	  			jne putchar     ;If it is non zero, we need to write it
	  
	  			cmp bp,0        
	  			jne putchar     ;If there has already been a non zero char, we need to write it
	  
	  			cmp si,0         			  ;Is this the last character?
	  			jne checkIfUnitsPlace         ;If not, we don't need to write it
	  
	  			cmp di,1        ;Is this the last character?
	  			jne checkIfUnitsPlace         ;If so, we need to write it
				;*******************************************************************
				putchar:            ;Need to write this character
	  				inc bp          ;Increment character counter
	  				add  al,'0'     
	  				
					push dx
	 				push ax
	  
				    mov dl,al
	  				mov ah,02h 
	  				int 21h
	  
	 				pop ax
	  				pop dx
				;******************************************************************	
				checkIfUnitsPlace:               
	  				;Check if divisor has become 1
	  				cmp si,0         
	  				jne nextNumber   
	  				cmp di,1         
	  				je doneloop1     
	
					;If divisor has still not become 1 then:
					nextNumber:         
	  					mov dx,si       
	  					mov ax,di       ;Current Divisor is moved to [dx:ax]
	  					push cx
	  					push bx         
	  					mov cx,0        
	  					mov  bx,10       
	  					CALL Divide   ;Do the division
	  					mov si,dx       
	 				    mov di,ax        ;[si:di]  New Divisor
	  					pop bx
	  					pop cx       
	  					mov ax,bx
	  					mov dx,cx		 ;[dx:ax] will now have New Dividend
	  					jmp loop1         
	
				doneloop1:               
	  				pop bp
	  				pop si
	  				pop di
	  				pop dx
	  				pop cx
	  				pop bx
	  				pop ax
	  			ret
		Print ENDP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;The idea of optimization is adapted from Art of Assembly by Randall Hydel.
	;Pseudo code
			comment /*
						Quotient := Dividend;
						Remainder := 0;
						for i:= 1 to NumberBits do
							Remainder:Quotient := Remainder:Quotient SHL 1;
							if Remainder >= Divisor then
								Remainder := Remainder - Divisor;
								Quotient := Quotient + 1;
							endif
						endfor
					/*
	
	Divide PROC
		
			;  DX:AX = Dividend
			;  CX:BX = Divisor
			;  SI:DI = Remainder
		
	  	cmp cx,0    		;
	  	jne sixtbitloop2     		;If the number of bits in divisor is less than 32
	  	
	  	;Comes here if cx is zero
	  	cmp dx,bx    		;
	  	jl sixtbitloop1	      	;If dx < bx , jump to handle it
	  
	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;32 bit by 16 bit division;;
	  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  	;cx can be used for division here
	  	mov cx,ax    		
	  	mov ax,dx 		
	  	mov dx,0 		   
	  	div bx
	  	xchg ax,cx    	;cx = Quotient_higher order bits, ax = Dividend-Lower order bits
	  	;TODO : Learn how xchg works internally! Very good for swapping. So which register is being effected while swapping? Or is it inplace?
	  	
	  	sixtbitloop1:          	 
	  		div bx      	  ;ax = Quotient-Lower order
	  		mov bx,dx   	  ;bx = Remainder-Low order
	  		mov dx,cx   	  ;dx = Quotient-High order
	  		mov cx,0    	  ;cx = Remainder-High order
	  		jmp finished      	 
	
	  	sixtbitloop2:        ;Divisor is 32 bits
	  		push di
	  		push si
	  		push bp
	  		mov bp,32   	   ;bp has no. of bits
	  		mov si,0
	  		mov di,0
	  
	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;32 bit by 32 bit division;;
	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  
	  	thirtytwobitmainloop:            	
	  		shl ax,1     	
	  		rcl dx,1     	
	  		rcl di,1     	
	  		rcl si,1     	
	  		cmp si,cx    	
	  		ja ifpart      				
	  		jb thirtytwobitloop1      	;;Why is jb different from jl???? :O and ja different from jg?
			
	    	cmp di,bx    				;Is Remainder Lower Order word more than Divisor LO word
	  		jb thirtytwobitloop1     	;If not, we're done with this bit
	
	  	ifpart:
	  		sub di,bx    				;Remainder :=
	  		sbb si,cx    				; Remainder - Divisor
	  		inc ax       				;Increment Quotient
		
	  	thirtytwobitloop1:            ;Go to the next bit
	  		dec bp       				;Decrement Loop Counter
	  		jne thirtytwobitmainloop    ;If not 0 yet, keep looking
	  		mov cx,si    				;Put Remainder
	  		mov bx,di    				;In CX:BX for the return
	  		pop bp
	  		pop si
	  		pop di
	  
	
		finished:            
  			ret
	Divide ENDP
  
  
END START
