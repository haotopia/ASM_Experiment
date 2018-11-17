DATAS SEGMENT
    ;此处输入数据段代码

    ;提示字
    String DB 'input:$'
    Mdigit DB 'digit:$'
    MalphaU DB 'UpperAlpha:$'
    MalphaL DB 'LowerAlpha:$'
    Mother  DB 'other:$'

    digits DB 0
    alphaU DB 0
    alphaL DB 0
    others DB 0
    
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
    lea dx,String
    mov ah,9
    int 21h
    mov cx,80

;逐字读入并计数
READ:
    mov ah,01h
    int 21h
    cmp al,0dh
    jz OVER

    cmp al,30h
    jb OTHER
    cmp al,39h
    ja ALPHA
    jmp DIGIT


ALPHA:
    cmp al,41h
    jb OTHER
    cmp al,5ah
    ja ALPHA2
    jmp UPPER

ALPHA2:
    cmp al,61h
    jb OTHER
    cmp al,7ah
    ja OTHER
    jmp LOWER
;特殊字符
OTHER:
    inc others
    loop READ
;数字
DIGIT:
    inc digits
    loop READ
;大写
UPPER:
    inc alphaU
    loop READ
;小写
LOWER:
    inc alphaL
    loop READ


;over减少代码用宏
ONOVER MACRO OP1,OP2
    call ENDLINE
    lea dx,OP1
    mov ah,9
    int 21h
    xor ax,ax
    mov al,OP2
    call DISPLAY
    ENDM

OVER:
    ONOVER Mdigit,digits
    ONOVER MalphaU,alphaU
    ONOVER MalphaL,alphaL
    ONOVER Mother,others


    MOV AH,4CH
    INT 21H
;换行
ENDLINE PROC NEAR
    mov ah,02h
    mov dl,0ah
    int 21h
    mov ah,2
    mov dl,0dh
    int 21h
    ret
ENDLINE ENDP


;输出两位数字的子程序
DISPLAY PROC NEAR
    mov bl,10
    div bl
    push ax

    ;D输出
    mov dl,al
    add dl,30h
    mov ah,02h
    int 21h
    pop ax
    mov dl,ah
    add dl,30h
    mov ah,02h
    int 21h
    ret
DISPLAY ENDP


CODES ENDS
    END START

