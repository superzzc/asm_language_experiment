assume cs:code
code segment
    install:
        # es:[di]==>0:200h
        mov ax,0
        mov es,ax
        mov di,200h
        # ds:[si]==>cs:offset int_7ch
        mov ax,code
        mov ds,ax
        mov di,offset int_7ch
        mov cx,offset done-offset int_7ch
        cld
        rep movsb
        # 设置中断向量表
        mov ax,0
        mov ds,ax
        mov word ptr [7ch*4],200h
        mov word ptr [7ch*4+2],0 

        mov ax,4c00h
        int 21h

    int_7ch:
        # 参数:dh(行号),dl(列号),cl(颜色),ds:si字符串首地址
        # 找到显存地址
        mov ax,0B8000h # 注意不能以字母开头，前面要加0
        mov es,ax
        mov bx,dh*160+dl*2
        # 写显存
        s:
            mov ch,[si]
            mov al,cl
            jcxz ok
            mov cl,al
            mov es:[di],ch
            mov es:[di+1],cl
            inc si
            add di,2
        jmp short s
        ok:
            iret
        done:
            nop

code ends
end install
