DATAS SEGMENT
    ;此处输入数据段代码

    ;提示字段 
    stringkey db 'Enter keyword:$'
    stringsen db 'Enter Sentence:$'
    stringloc db 'Match at localtion:$'
    stringnom db 'No match.$'
    stringout db 'H of the sentence.$'
    ;删除关键字
    stringnew db 'New sentence.$'
    
    ;输入字段
    inputkey label byte     ;关键词
    max1 db 10
    act1 db ?
    keyword db 10 dup(?)
    
    inputsen label byte     ;句子
    max2 db 50
    act2 db ?
    sentence db 50 dup(?)
    
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
    
    push dx
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    pop dx
    
    ;输入keyword
    lea dx,stringkey
    mov ah,09h
    int 21h
    
    lea dx,inputkey
    mov ah,0ah
    int 21h
    
    ;为空退出程序
    cmp act1,0
    je ende
    
    push dx
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    pop dx
    
    ;输入Sentence
    lea dx,stringsen
    mov ah,09h
    int 21h
    
    lea dx,inputsen
    mov ah,0ah
    int 21h
    
    ;保存关键字长度
    mov al,act1
    cbw
    mov cx,ax
    push cx
    
    ;保存句子长度，为空则跳转
    mov al,act2
    cmp al,0
    je ende
    
    ;若句子长度小于关键字长度
    sub al,act1
    js ende
    
    ;将句子首地址放进BX
    inc al
    cbw
    lea bx,sentence
    
    mov di,0
    mov si,0
    
compare:
    mov ah,[bx+di]
    cmp ah,keyword[si]
    jne next
    
    ;没遇到一个相等的字符cx-1
    inc di
    inc si
    dec cx

    cmp cx,0
    je oute
    jmp compare
    
next:
    ;bx+1清空si,di继续关键词比较
    inc bx
    dec al
    cmp al,0
    je ende
    
    mov di,0
    mov si,0
    pop cx
    push cx
    jmp compare
    
oute:
    sub bx,offset sentence
    inc bx
    
    push dx
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    pop dx
    
    lea dx,stringloc
    mov ah,09h
    int 21h
    
    ;转子程序获取关键位置，H
    call btoh
    
    lea dx,stringout
    mov ah,09
    int 21h
    jmp start
    
    ;B->H
btoh PROC NEAR
    mov ch,4
rotate:
    mov cl,4
    rol bx,cl
    mov al,bl
    and al,0fh
    add al,30h
    cmp al,3ah
    jl print
    add al,7h
print:
    mov dl,al
    mov ah,02h
    int 21h
    dec ch
    jnz rotate
    ret
btoh endp

ende:
    push dx
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    pop dx
    
    lea dx,stringnom
    mov ah,09
    int 21h
    jmp start
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

