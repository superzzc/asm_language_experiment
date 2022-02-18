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
        # 参数:cx(循环次数),bx(位移)
        dec cx
        jcxz ok
        # 修改栈上存的IP
        push bp # callee-save
        mov sp,bp
        add [bp+2],bx
        pop bp
        ok:
            iret
        done:
            nop

code ends
end install