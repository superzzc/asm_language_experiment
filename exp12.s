assume cs:code
code segment
    # 复制div0中断处理程序到0000:0200
    mov ax,cs
    mov ds,ax
    mov si,offset div0

    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset div0_end-offset div0
    cld 
    rep movsb
    # 设置中断向量表0号向量
    mov ax,0
    mov ds,ax
    mov byte ptr [0],200h
    mov byte ptr [2],0

    mov ax,4c00h
    int 21h
    # 除0中断处理程序
    div0:
        jmp short div0_start
        db 'divide error!'
    div0_start:
        # 将字符串写进显存,中断调用是字符串存在0000:0202h开始处
        mov ax,0
        mov ds,ax
        mov si,202h
        
        mov ax,0B8000h
        mov es,ax
        mov di,12*160+34*2

        mov cx,13
        cld
        rep movsb
        
        mov ax,4c00h
        int 21h
    div0_end:
        nop
code ends
end
