;Implements a Clock in MM:SS format
;Author : Akhilesh Godi(CS10B037)
	.model small 
	.stack 256h
	

	
CR equ 13d 		;Carriage Return ASCII value
LF equ 10d		;Next Line ASCII Value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;											DATA SEGMENT														   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data 

minutes_left    dw      0
minutes_right   dw      0
seconds_left    dw      0
seconds_right   dw      0
min_left_num    dw      0
min_right_num   dw      0
sec_left_num    dw      0
sec_right_num   dw      0
num          	dw      0
address_row     dw      0
address_col     dw      0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DrawPixel macro color,row,col
	        push ax
	        push cx
	        push dx
	        mov al,color
	        
	        mov dx,row
	        mov cx,col
	        mov ah,0ch
	        int 10h     ; Set the Pixel
	        
	        pop dx
	        pop cx
	        pop ax
    ENDM
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	
.code	
	START:
	
		
		mov ax, @data					;Stores the address of data segment in the accumulator register sx
		mov ds, ax						;Copies the value in the accumulator to the ds register
		
        mov al, 13h
        mov ah, 0
        int 10h                         ; set graphics video mode.
        
        mov ax,0
        call HourImplementation
        
        mov ah,01h
        int 21h
        
        mov ax,4c00h
        int 21h
        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
 HourImplementation PROC
    
    push ax
    push bx
    push cx
    push dx
    
    
    loopMinutes:  mov dx,min_left_num
                  cmp dx,6
                  jge resetMinutesLeft
                  mov min_left_num,dx
                  call PrintMinutesLeft
                  inc dx
                  mov min_left_num,dx
                loopMinutesRight:
                    mov cx,min_right_num
                    cmp cx,10
                    jge resetMinutesRight
                    mov min_right_num,cx
                    call PrintMinutesRight
                    inc cx
                    mov min_right_num,cx
                    loopSecondsLeft:
                            mov bx,sec_left_num
                            cmp bx,6
                            jge resetSecondsLeft
                            mov sec_left_num,bx
                            call PrintSecondsLeft
                            inc bx
                            mov sec_left_num,bx
                        loopSecondsRight:   
                                    mov ax,sec_right_num
                                    cmp ax,10
                                    jge resetSecondRight
                                    mov sec_right_num,ax
                                    call PrintSecondsRight
                                    inc ax
                                    mov sec_right_num,ax
                                    call Delay
                                    jmp loopSecondsRight 
                    


    resetSecondRight : mov ax,0
                       mov sec_right_num,ax
                       jmp loopSecondsLeft
                       
    resetSecondsLeft : mov bx,0
                       mov sec_left_num,bx
                       mov sec_right_num,bx
                       jmp loopMinutesRight
                
     resetMinutesRight: mov cx,0
                        mov min_right_num,cx
                        mov sec_right_num,cx
                        mov sec_left_num,cx
                        jmp loopMinutes
                        
     resetMinutesLeft : 
                        mov dx,0
                        mov min_right_num,dx
                        mov min_left_num,dx
                        mov sec_right_num,dx
                        mov sec_left_num,dx
                        jmp loopMinutes
finished:     
     pop dx
     pop cx
     pop bx
     pop ax               
     ret
    HourImplementation ENDP             
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintMinutesLeft PROC
    
    push ax
    push bx
    push cx
    push dx
    
    mov ax,min_left_num
    mov num,ax
    mov address_row,70
    mov address_col,60
    call DrawNumber
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintMinutesLeft ENDP
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintMinutesRight  PROC
    
    push ax
    push bx
    push cx
    push dx
    
    mov ax,min_right_num
    mov num,ax
    mov address_row,70
    mov address_col,110
    call DrawNumber
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintMinutesRight ENDP
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintSecondsLeft  PROC
    
    push ax
    push bx
    push cx
    push dx
    
    mov ax,sec_left_num
    mov num,ax
    mov address_row,70
    mov address_col,170
    call DrawNumber
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintSecondsLeft ENDP
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PrintSecondsRight  PROC
    
    push ax
    push bx
    push cx
    push dx
    
    mov ax,sec_right_num
    mov num,ax
    mov address_row,70
    mov address_col,220
    call DrawNumber
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintSecondsRight ENDP
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawNumber PROC
    
    push ax
    push bx
    push cx
    push dx
    
    
    mov si,address_row
    mov di,address_col
    
    DrawA:
        mov dx,si
        mov cx,di
        mov bp,cx
        add bp,30
   		
   		cmp num,1
        je AOff
        cmp num,4
        je AOff
            
        AOn:
            DrawPixel 0010,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne AOn
   		    jmp DrawG
   		    
   		AOff:
   		    DrawPixel 0000,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne AOff
   		    
   	
 	DrawG:
        mov dx,si
        add dx,30
        mov cx,di
        mov bp,cx
        add bp,30
   		
   		cmp num,0
        je GOff
        cmp num,1
        je GOff
        cmp num,7
        je GOff
        
            
        GOn:
            DrawPixel 0010,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne GOn
   		    jmp DrawD
   		    
   		GOff:
   		    DrawPixel 0000,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne GOff
   	 
    DrawD:
        mov dx,si
        add dx,60
        mov cx,di
        mov bp,cx
        add bp,30
   		
   		cmp num,1
        je DOff
        cmp num,4
        je DOff
        cmp num,7
        je DOff
        
            
        DOn:
            DrawPixel 0010,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne DOn
   		    jmp DrawF
   		    
   		DOff:
   		    DrawPixel 0000,dx,cx
   		    inc cx
   		    cmp cx,bp
   		    jne DOff
    
    
    DrawF:
        mov dx,si
        mov cx,di
        mov bp,dx
        add bp,30
   		
   		cmp num,1
        je FOff
        cmp num,2
        je FOff
        cmp num,3
        je FOff
        cmp num,7
        je FOff
        
            
        FOn:
            DrawPixel 0010,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne FOn
   		    jmp DrawE
   		    
   		FOff:
   		    DrawPixel 0000,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne FOff
    
    DrawE:
        mov dx,si
        add dx,30
        mov cx,di
        mov bp,dx
        add bp,30
   		
   		cmp num,1
        je EOff
        cmp num,3
        je EOff
        cmp num,4
        je EOff
        
        cmp num,9
        je EOff
        
        cmp num,7
        je EOff
        cmp num,5
        je EOff
                    
        EOn:
            DrawPixel 0010,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne EOn
   		    jmp DrawB
   		    
   		EOff:
   		    DrawPixel 0000,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne EOff
   		    
   
    DrawB:
        mov dx,si
        mov cx,di
        add cx,30
        mov bp,dx
        add bp,30
   		
   		cmp num,5
        je BOff
        cmp num,6
        je BOff
                    
        BOn:
            DrawPixel 0010,dx,cx
   		    inc dx
   		    cmp dx,bp
    
   		    jne BOn
   		    jmp DrawC
   		    
   		BOff:
   		    DrawPixel 0000,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne BOff
   
   DrawC : 
        
        mov dx,si
        add dx,30
        mov cx,di
        add cx,30
        mov bp,dx
        add bp,30
   		
   		cmp num,2
        je COff
                    
        COn:
            DrawPixel 0010,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne COn
   		    jmp finish
   		    
   		COff:
   		    DrawPixel 0000,dx,cx
   		    inc dx
   		    cmp dx,bp
   		    jne COff
   		    
   		    
        finish:
            pop dx
            pop cx
            pop bx
            pop ax
            ret
            
DrawNumber ENDP

Delay PROC

    push ax
    push bx
    push cx
    push dx
    
    mov dx,0000H
    mov cx,0000H
    delaying:   
            inc dx
        
        delaying1:   
                inc cx
                cmp cx,7FEEH
                jl delaying1
    	    cmp dx,2FFFH
            jl delaying
        		
    mov dx,0
    delaying2:   
                inc dx
                NOP
                cmp dx,0FFFFH
                jl delaying2    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 
 Delay ENDP       
 END START
       
 
      

