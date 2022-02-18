
assume cs:code
code segment 
start:
# install int 7ch to 0:200h
mov ax,code
mov cs,ax
mov ds,ax
mov si,offset int_7ch

mov ax,0
mov es,ax
mov si,200h

cld
mov cx,offset int_7ch_end-offset int_7ch
rep movsb
# rewrite interrupt table
mov word ptr es:[7ch*4],200h
mov word ptr es:[7ch*4+2],0

mov ax,4c00h
int 21h

# arg: ah->function number
#      al->forgound/background color
int_7ch:
    jmp short func_select
# sub function table
    table dw sub1,sub2,sub3,sub4
func_select:
    cmp ah,3
    ja done
    mov bh,0
    mov bl,ah
    shl bx,1
    call word ptr table[bx]
done:
    iret
# clear screen
sub1:
    push bx
    push ds
    push cx

    mov bx,0b8000h
    mov ds,bx
    mov bx,0
    mov cx,2000
sub1s:
    mov byte ptr [bx],' '
    add bx,2
    loop sub1s

    pop cx
    pop ds
    pop bx
    ret
# set forground
sub2:
    push bx
    push ds
    push cx

    mov bx,0b8000h
    mov ds,bx
    mov bx,1
    mov cx,2000
sub2s:
    and byte ptr [bx],11111000b
    or byte ptr [bx],al
    add bx,2
    loop sub2s

    pop cx
    pop ds
    pop bx
    ret
# set background
sub3:
    push bx
    push ds
    push cx

    mov bx,0b8000h
    mov ds,bx
    mov bx,1
    mov cx 2000
sub3s:
    push cx
    mov cl,4
    and byte ptr [bx],10001111b
    shl al,cl
    or byte ptr [bx],al
    pop cx
    loop sub3s

    pop cx
    pop ds
    pop bx
    ret
# scroll up one line
sub4:
    push ds
    push si
    push es
    push di
    push cx

    mov si,0b8000h
    mov ds,si
    mov es,si
    mov si,160
    mov di,0
    mov cx,24
sub4s:
    push cx
    mov cx,160
    cld
    rep movsb
    pop cx
    loop sub4s
    # clear last line
    mov cx,80
clear:
    mov [si],' '
    add si,2
    loop clear

    pop cx
    pop di
    pop es
    pop si
    pop ds
    ret
int_7ch_end:
    nop

code ends
end start