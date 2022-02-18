assume cs:code,ss:stack
stack segment
    db dup 16 (0)
stack ends
code segment
addr:
    db 9,8,7,4,2,0
result:
    db dup 6 (0)
ascii:
    db 'yy/mm/dd HH:MM:SS','$'
start:
# stack init
    mov ax,stack
    mov ss,ax
    mov sp,10h
# read time info into result
    mov ax,code
    mov ds,ax
    mov si,offset addr
    mov di,offset result
    mov cx,6
get_time:
    # CMOS RAM
    mov al,[si]
    out 70h,al
    in al,71h
    mov [di],al
    inc si
    inc di
    loop get_time
# translate result into ascii
    mov cx,6
    mov di,offset ascii
s:
    push cx
    mov bl,[di]
    mov bh,bl
    mov cl,4
    shr bh,cl
    and bl,00001111b

    add,bh,30h
    add bl,30h

    mov [di],bh
    mov [di+1],bl
    add di,3 # pass special char
    pop cx
    loop s
# output ascii string using DOS int 21h #9
    mov dx,offset ascii
    mov ah,9
    int 21h
# return to DOS
    mov ax 4c00h
    int 21h

code ends
end start