ORG 0x7c00+0x004200

MOV AL, 0x13
MOV AH, 0x00
INT 0x19

fin2: 
  HLT
  JMP fin2

main:
   JMP fin2
