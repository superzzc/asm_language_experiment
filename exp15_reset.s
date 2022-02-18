# reset interrupt table #9 to orignal DOS int 9
# use it after exp15.s execute
# DO NOT RUN IT BEFOR YOU EXCUTE EXP15.S
assume cs:code
code segment
start:
    mov ax,0
    mov ds,ax

    mov ax,[200h]
    mov [9*4],ax

    mov ax,[202h]
    mov [9*4+2],ax

    mov ax,4c00h
    int 21h

code ends
end start
