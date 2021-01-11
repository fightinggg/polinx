
ORG 0x7c00 ; boot  0x7c00-0x7dff

call main

main: 
    ; reg init
    MOV AX,0 ; accumulator
    MOV SS,AX ; stack segment
    MOV DS,AX ; data segment
    MOV ES,AX ; extra segment
    MOV SP,0x7c00 ; stack pointer

    MOV SI,startMessage ; source index
    call printStr 

    MOV SI,startMessage ; source index
    call printStr 

    MOV SI,startMessage ; source index
    call printStr 
    
    call fin
    ret


printStr:
    MOV AL,[SI]
    ADD SI,1

    CMP AL,0
    JE printStrLeave

    MOV AH,0x0e
    MOV BX,15
    INT 0x10
    JMP printStr
printStrLeave:
    ret


readDisk:
    MOV AX,0x0820
    MOV ES,AX
    MOV CH,0 ; 柱面0
    MOV DH,0 ; 磁头0
    MOV CL,2 ; 扇区2

    MOV SI,0
    JMP readDiskLoop

readDiskLoop:
    MOV AH,0x02			; AH=0x02 : 读入磁盘
    MOV AL,1			; 1个扇区
    MOV BX,0
    MOV DL,0x00			; A驱动器
    INT 0x13			; 调用磁盘BIOS
    JNC next			; 没出错则跳转到next
    ADD SI,1			; 往SI加1
    CMP SI,5			; 比较SI与5
    JAE error			; SI >= 5 跳转到error
    MOV AH,0x00
    MOV DL,0x00			; A驱动器
    INT 0x13			; 重置驱动器
    JMP readDiskLoop

next:
   HLT
   JMP next

error:
   HLT
   JMP error

fin:
    HLT
    JMP fin

startMessage: 
    DB "polinx start..."
    DB 0x0a
    DB 0

times 510 - ($ - $$) db 0 ; fill with 0 untill arrive 512 bytes
dw 0xaa55