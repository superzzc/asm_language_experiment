assume cs:code
code segment 
start:
# install ourself int 7ch on 0:200, read or write disk
mov ax,code
mov cs,ax
mov ds,ax
mov si,offset int_7ch
mov ax,0
mov es,ax
mov di,200h
mov cx,offset int_7ch_end-offset int_7ch
cld
rep movsb
# rewrite interrupt table
mov word ptr es:[7ch*4],200h
mov word ptr es:[7ch*4+2],0

mov ax,4c00h
int 21h

# ah->function num, 0->read,1->write
# dx->block num
# es:bx->memory location read/write
int_7ch:
    jmp short func_select
    table dw read,write
    # tmp space for read/write args
    # 面号、磁道号、扇区号
    stack db 6 dup(0)
func_select:
    cmp ah,1
    ja done
    mov cl,ah
    mov ch,0
    shl cx,1
    mov si,cx
    call word ptr table[si]
done:
    iret
read:
    call translate
    mov al,1
    mov ch,stack[2]
    mov cl,stack[3]
    mov dh,stack[0]
    mov dl,0
    mov ah,2
    int 13h
    ret
write:
    call translate
    mov al,1
    mov ch,stack[2]
    mov cl,stack[3]
    mov dh,stack[0]
    mov dl,0
    mov ah,3
    int 13h
    ret
# translate block num and save on stack
# block num =(surface*80+track)*18+sector-1
translate:
    # 32-bit divide,[dx,ax]->block num
    mov ax,dx
    mov dx,0
    mov cx,1440
    # div result,ax->商,dx->余数
    div cx
    mov byte ptr stack[0],al
    # 上一步余数/18,16-bit divide
    mov ax,dx
    mov cl,18
    div cl
    mov byte ptr stack[1],al
    inc ah,1
    mov byte ptr stack[2],ah
    ret
int_7ch_end:
    nop
code ends
end start