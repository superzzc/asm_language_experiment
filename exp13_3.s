# 将s1-s4的四行英文分别显示在2、4、6、8行上
assume cs:code
code segment
    s1: db 'Good,better,best,','$'
    s2: db 'Never let it rest,','$'
    s3: db 'Till good is better','$'
    s4: db 'And better ,best.','$'
    s:  dw offset s1,offset s2,offset s3,offset s4
    row:db 2,4,6,8

start:
    mov ax,cs
    mov ds,ax
    mov bx,offset s
    mov si,offset row
ok:
    # int 10h 2号子程序，置光标位置
    mov bh,0    # 显存0页
    mov dh,[si] # 取得行号
    mov dl,0    # 取得列号
    mov ah,2
    int 10h
    # int 21h 9号子程序，在光标位置显示字符串
    mov dx,[bx] # ds:dx指向字符串开头
    mov ah,9
    int 21h
    inc si
    add bx,2
    loop ok

    mov ax,4c00h
    int 21h
    
code ends
end start
