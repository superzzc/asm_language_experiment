# 将dataseg段中每个单词的前四个字母变成大写
assume cs:codeseg,ss:stackseg,ds:dataseg
stackseg segment
    dw 0,0,0,0,0,0,0,0
stackseg ends
dataseg segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
dataseg ends
codeseg segment
start:
    mov ax,stackseg
    mov ss,ax
    mov sp,16

    mov ax,dataseg
    mov ds,ax
    mov bx,0
    mov cx,4
s:
    push cx
    mov cx,4
    mov si,0
s0:
    and byte ptr [bx+3+si],11011111b
    inc si
    loop s0
    
    pop cx
    add bx,16
    loop s

mov ax,4c00h
int 21h

codeseg ends
end start