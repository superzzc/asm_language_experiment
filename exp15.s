assume cs:code,ss:stack
stack segment
    db dup 128 (0)
stack ends

code segment 
start:
# stack init
mov ax,stack
mov ss,ax
mov sp,128
# install your int_9 on 0:204h
mov ax,code
mov ds,ax
mov si,offset int_9

mov ax,0
mov es,ax
mov di,204h

mov cx offset int_9_end-offset int_9
cld
rep movsb
# save interrupt table #9 CS:IP on 0:200
push es:[9*4]
pop es:[200h]
push es:[9*4+2]
pop es:[202h]
# rewrite interrupt table #9, leading to ourself int 9 on 0:204h
cli
mov word ptr es:[9*4],204h
mov word ptr es:[9*4+2],0
sti

mov ax,4c00h
int 21h

int_9:
# save any reg if we need to rewrite it
    push ax
    push bx
    push cx
    push ds

    in al,60h
    pushf
    # DOS int 7 handler
    call dword ptr cs:[200h]
    cmp al,1Eh+80h
    jne ok
    
    mov ax,0B8000h
    mov ds,ax
    mov bx,1
    mov cx,2000
s:
    mov [bx],'A'
    add bx,2
    loop s
ok:
    pop ds
    pop cx
    pop bx
    pop ax
    iret
int_9_end:
    nop

code ends
end start