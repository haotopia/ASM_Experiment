DATAS SEGMENT
    ;此处输入数据段代码 
    stringnote  db 'Whill show stings form ASCII 10H To 100h$'
    
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    lea dx,stringnote
    mov ah,09h
    int 21h
    mov dl,0dh
	mov ah,02h
	int 21h
	mov dl,0ah
	mov ah,02h
	int 21h
    
    
    
    mov ch,0f0h		;15*16=240 -> 0f
    mov dl,10h		;数据寄存存数据
    mov bl,10h		;基址寄存控制一行16个
    
f:
	mov ah,02h		;调用2号功能调用输出现在的dl
	int 21h			
	
	push dx			;数据压栈输出空格
	mov dl,0h		
	mov ah,02h
	int 21h
	pop dx
	
	dec bl			;减1
	jnz g
	
	mov bl,10h		;一行输出完成重置bl为10h
	
	push dx			;压栈换行		
	mov dl,0dh
	mov ah,02h
	int 21h
	mov dl,0ah
	mov ah,02h
	int 21h
	pop dx
	
g:
	inc dl			;DL加一进入下一个字符ASC
	dec ch			;计数器减1
	jnz f
	
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
