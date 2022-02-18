assume cs:code,ds:data
data segment
	db 'Beginner's All-purpose Code',0
date ends

code segment
	start:
		mov ax,data
		mov ds,ax
		mov si,0
		call letterc

		mov ax,4c00h
		int 21h
	letterc:
		s:
			mov dl,ds:[si]
			jz ok1
			call to_upper
			mov ds:[si],dl
			inc si
		jmp short s
		ok1:
			ret
	to_upper:
		cmp dl,'a'
		jb ok2
		cmp dl,'z'
		ja ok2
		and dl,11011111b
		ok2:
			ret

code ends
end start
