assume cs:code,ds:data
data segment 
	db 'welcome to masm!'
data ends

code segment
start:
	# green
	mov dh,2

	mov ax,data
	mov ds,ax
	mov bx,0

	# 找到中间的显存地址
	mov ax,0B8AA0h
	mov es,ax
	mov di,3Eh

	mov cx,10h
s:
	mov dl,[bx]
	inc bx
	mov es:[di],dx
	add di,2
	loop s

	mov ax,4c00h
	int 21h

code ends
end start