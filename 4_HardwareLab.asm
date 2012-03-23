;Author : Akhilesh Godi (CS10B037)
;Hardware Lab Assignment - Matrix Inverse for an nxn matrix

	.model small 
	.stack 256h
	
	
CR equ 13d 		;Carriage Return ASCII value
LF equ 10d		;Next Line ASCII Value


.data

	nrow	dw	3			;8600
	ncol 	dw 	3			;8602
	mrow	dw	6			;Augmented matrix no. of rows	;8604
	mcol	dw 	24			;2*(4)*ncol						;8606
	matrix	dw 	1,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,0,1,1,1 ;8608 - 864F
	;matrix	dw 	1,1, 3,1, 1,1,   1,1, 0,1, 0,1,   1,1, 1,1, 2,1,	 0,1, 1,1, 0,1,		2,1, 3,1, 4,1,	 0,1, 0,1, 1,1	;Numerator,Denominator
	i		dw	0			;8650					        
	j		dw	0			;8652
	r		dw	0			;8654
	c		dw	0			;8656
	mii_num     dw  0		;8658
	mii_denom	dw  0		;865A
	mri_num 	dw	0		;865C
	mri_denom	dw 	0		;865E
	mic_num		dw	0		;8660
	mic_denom	dw  0		;8662
	mrc_num		dw	0		;8664
	mrc_denom	dw	0		;8666
	prod_num	dw	0		;8668
	prod_denom	dw	0		;866A
	factor_num	dw	0		;866C			;Dummy variable
	facor_denom	dw	0		;866E			;Dummy variable
	mi0		dw	0			;8670 ;Only Address
	mr0		dw	0			;8672
	mrc		dw	0			;8674
.code

	START:
		mov ax, @data					;Stores the address of data segment in the accumulator register sx
		mov ds, ax						;Copies the value in the accumulator to the ds register
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		lea si,matrix				;si has the address of m[0][0]'s num   ; 8400 : 8D 36 08 86                             
		mov i,0						;Outer loop iterator                   ; 8404 : C7 06 50 86 00 00
		mov ax,0000h                                                       ; 840A : C7 C0 00 00 ;or B8 00 00
  outerloop:mov di,si					                                   ; 840E : 89 F7
			add di,ax				;di has the address of m[i][0]'s num   ; 8410 : 03 F8
			mov mi0,di                                                     ; 8412 : 89 3E 70 86
			mov ax,4                                                       ; 8416 : C7 C0 04 00
			mul i                                                          ; 841A : F7 26 50 86
			add di,ax				;di has the address of m[i][i]'s num   ; 841E : 03 F8 
			mov ax,[di]                                                    ; 8420 : 8B 05
			mov mii_num,ax                                                 ; 8422 : A3 58 86
			mov ax,[di+2]                                                  ; 8425 : 8B 45 02 
			mov mii_denom,ax                                               ; 8428 : A3 5A 86
			mov j,0                                                        ; 842B : C7 06 52 86 00 00
			mov ax,0                                                       ; 8431 : C7 C0 00 00 
	innerloop1: mov bx,mi0                                                 ; 8435 : 8B 1E 70 86
			    mov ax, 4                                                  ; 8439 : C7 C0 04 00
			    mul j                                                      ; 843D : F7 26 52 86
			    add bx,ax                                                  ; 8441 : 03 D8
			    mov ax, mii_num                                            ; 8443 : A1 58 86
			    mov dx,[bx+2]                                              ; 8446 : 8B 57 02 
			    mul dx                                                     ; 8449 : F7 EA (or) F7 E2
			    mov bp,ax                                                  ; 844B : 8B E8
			    mov ax,mii_denom                                           ; 844D : A1 5A 86 
			    mov dx,[bx]                                                ; 8450 : 8B 17
			    mul dx													   ; 8452 : F7 EA (or) F7 E2
			    mov [bx], ax											   ; 8454 : 89 07
			    mov [bx+2],bp											   ; 8456 : 89 6F 02
				inc j													   ; 8459 : FF 06 52 86
				cmp j,6	;6 = mcol 	REMEMBER : cmp is always Signed!       ; 845D : 83 3E 52 86 06 
				jne innerloop1											   ; 8462 : 75 D1
			mov ax,0000h												   ; 8464 : B8 00 00
			mov r,0														   ; 8467 : C7 06 54 86 00 00
		innerloop2: mov bx,si											   ; 846D : 8B DE
					add bx,ax		;bx has the address of m[r][0]'s num   ; 846F : 03 D8
					mov mr0,bx											   ; 8471 : 89 1E 72 86
					mov ax,4											   ; 8475 : B8 04 00
					mul i												   ; 8478 : F7 2E 50 86 (or) F7 26 50 86
					add bx,ax		;bx has the address of m[r][i]'s num   ; 847C : 03 D8
					mov ax,[bx]											   ; 847E : 8B 07
					mov mri_num,ax										   ; 8480 : A3 5C 86
					mov ax,[bx+2]										   ; 8483 : 8B 47 02
					mov mri_denom,ax									   ; 8486 : A3 5E 86
					mov ax,i										       ; 8489 : A1 50 86
					cmp r ,ax											   ; 848C : 39 06 54 86
					je outtoinnerloop2flag								   ; 8490 : 74 3E
					mov c,0												   ; 8492 : C7 06 56 86 00 00
		innerinnerloop: mov bx,mi0	;bx has the address of m[i][0]'s num   ; 8498 : 8B 1E 70 86
						mov ax,4										   ; 849C : B8 04 00 
						mul c								          	   ; 849F : F7 2E 56 86 (or) F7 26 56 86
						add	bx,ax	;bx has the address of m[i][c]'s num   ; 84A3 : 03 D8
						mov ax,[bx]										   ; 84A5 : 8B 07
						mov mic_num,ax									   ; 84A7 : A3 60 86
						mov ax,[bx+2]									   ; 84AA : 8B 47 02
						mov mic_denom,ax								   ; 84AD : A3 62 86
						mov bx,mr0										   ; 84B0 : 8B 1E 72 86
						mov ax,4										   ; 84B4 : B8 04 00
						mul c											   ; 84B7 : F7 2E 56 86 (or) F7 26 56 86
						add bx,ax										   ; 84BB : 03 D8
						mov mrc,bx										   ; 84BD : 89 1E 74 86
						mov ax,[bx]										   ; 84C1 : 8B 07 
						mov mrc_num,ax									   ; 84C3 : A3 64 86
						mov ax,[bx+2]									   ; 84C6 : 8B 47 02
						mov mrc_denom,ax								   ; 84C9 : A3 66 86
					    jmp down1										   ; 84CC : EB 06
	   innerloop2flag:jmp innerloop2									   ; 84CE : EB 9D
    outtoinnerloop2flag:jmp outtoinnerloop2                                ; 84D0 : EB 59
	innerinnerloopflag:jmp innerinnerloop								   ; 84D2 : EB C4
				down1:  mov ax,mri_num									   ; 84D4 : A1 5C 86
						mov cx,mic_num								       ; 84D7 : 8B 0E 60 86
						mul cx											   ; 84DB : F7 E9 (or) F7 E1
						mov prod_num,ax									   ; 84DD : A3 68 86 
					    mov ax,mri_denom								   ; 84E0 : A1 5E 86
						mov cx,mic_denom								   ; 84E3 : 8B 0E 62 86
						mul cx											   ; 84E7 : F7 E9 (or) F7 E1
						mov prod_denom,ax								   ; 84E9 : A3 6A 86
						mov ax,mrc_denom								   ; 84EC : A1 66 86 
						mov cx,prod_num									   ; 84EF : 8B 0E 68 86 
						mul cx											   ; 84F3 : F7 E9 (or) F7 E1
						mov bp,ax						       			   ; 84F5 : 8B E8
						mov ax,mrc_num									   ; 84F7 : A1 64 86
						mov cx,prod_denom								   ; 84FA : 8B 0E 6A 86
						mul cx											   ; 84FE : F7 E9 (or) F7 E1
						sub ax,bp										   ; 8500 : 2B C5 
						mov mrc_num,ax									   ; 8502 : A3 64 86
						mov ax,mrc_denom								   ; 8505 : A1 66 86
						mov cx,prod_denom								   ; 8508 : 8B 0E 6A 86
						mul cx											   ; 850C : F7 E1
						mov mrc_denom,ax								   ; 850E : A3 66 86
						mov bx,mrc										   ; 8511 : 8B 1E 74 86
						mov ax,mrc_num									   ; 8515 : A1 64 86
						mov [bx],ax										   ; 8518 : 89 07
						mov ax, mrc_denom								   ; 851A : A1 66 86
						mov [bx+2],ax									   ; 851D : 89 47 02
						inc c											   ; 8520 : FF 06 56 86
		    			cmp c, 6										   ; 8524 : 83 3E 56 86 06
						jne innerinnerloopflag							   ; 8529 : 75 A7
	outtoinnerloop2:inc r												   ; 852B : FF 06 54 86
		    		mov ax,24											   ; 852F : B8 18 00
		    		mul r												   ; 8532 : F7 26 54 86
		    		cmp r, 3											   ; 8536 : 83 3E 54 86 03
					jne innerloop2flag									   ; 853B : 75 91
			inc i														   ; 853D : FF 06 50 86
		    mov ax,24    ;24 = (4)*mcol If you change mcol, change here too; 8541 : B8 18 00
		    mul i														   ; 8544 : F7 26 50 86 
		    cmp i, 3     ; 3 = nrow. If you change nrow change here too    ; 8548 : 83 3E 50 86 03
			je done														   ; 854D : 74 03
			jmp outerloop												   ; 854F : E9 FE BC
	done: mov ax,4c00h													   ; 8552 :
		  int 21h														   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;USE IT FOR CHECKING THE MATRIX AFTER INVERSE
	;INVERSE IN alternate 3
	PRINTS PROC
		
		    push ax
			push bx
			push cx
			push dx
				
				mov ax, offset matrix		;moves the effective address of the string to si
				mov bx,ax
				mov ax,[bx] 
	   			mov cx,18
	    		loopcpy:
	    			mov dx, ' '
	    			mov ah,02h
	    			int 21h	
	    			
	    			mov ax, [bx]			;moves the address of the first byte of string to al
					mov dx,ax
					add dx,48
					mov ah,02h
					int 21h
					
					mov dx,'/'
					mov ah,02h
					int 21h
					
					mov ax, [bx+2]			;moves the address of the first byte of string to al
					mov dx,ax
					add dx,48
					mov ah,02h
					int 21h
					
					dec cx
					cmp cx,0
					je exit
	    			add bx,4
	    			jmp loopcpy
	    			
	   exit:
	   		mov dl,10
	   		mov ah,02h
	   		int 21h
	   		pop dx
		    pop cx
			pop bx
			pop ax
			ret
	PRINTS ENDP
	;*****************************************************************************************************
	END START
			
