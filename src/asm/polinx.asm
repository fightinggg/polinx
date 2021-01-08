
ORG 0x7c00

JMP main

main: 
    MOV AX,0 ; accumulator
    MOV SS,AX ; stack segment
    MOV DS,AX ; data segment
    MOV ES,AX ; extra segment
    MOV SP,0x7c00 ; stack pointer
    MOV SI,msg ; source index
    JMP putloop ; to loop

putloop:
    MOV AL,[SI]
    ADD SI,1

    CMP AL,0
    JE fin

    MOV AH,0x0e
    MOV BX,15
    INT 0x10
    JMP putloop

fin:
    HLT
    JMP fin

msg: 
    DB "polinx start..."
    DB 0x0a
    DB 0

times 510 - ($ - $$) db 0
dw 0xaa55