assume cs:code,ds:data
data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982'
	db '1983','1984','1985','1986','1987','1988','1989','1990'
	db '1991','1992','1993','1994','1995'

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends

table segment
	db 21 dup('year summ ne ??')
table ends

code segment
# data seg 
mov ax,data
mov ds,ax

# table seg
mov ax,table
mov es,ax
mov bx,0

# footstep
mov si,0
mov di,0

mov cx,21
s:
	# 年份
	mov ax,ds:[0+si]
	mov es:[bx],ax
	mov ax,ds:[0+si+2]
	mov es:[bx+2],ax

	# 收入
	mov ax,ds:[55h+si]
	mov es:[bx+5],ax
	mov ax,ds:[55h+si+2]
	mov es:[bx+7],ax

	# 雇员
	mov ax,ds:[0a8h+di]
	mov es:[bx+0ah],ax

	# 人均收入
	mov ax, es:[bx+5]
	mov dx, es:[bx+7]
	div word ptr es:[bx+0ah]
	mov es:[bx+0dh],ax

	add si,4
	add di,2
	add bx,10h
loop s
mov ax,4c00h
int 21h

code ends
end