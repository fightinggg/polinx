; ORG 0x7c00 ; boot  0x7c00-0x7dff

; ; call dword main
; ; main: 
;     ; reg init
;     MOV EAX,0 ; accumulator
;     MOV SS,EAX ; stack segment
;     MOV DS,EAX ; data segment
;     MOV ES,EAX ; extra segment
;     MOV ESP,0x7c00 ; stack pointer


;     ; PUSH dword  0x8200/16 ; 
;     ; PUSH dword  17
;     ; PUSH dword  0
;     ; PUSH DWORD  0
;     ; call dword  _readSector
;     ; ADD ESP,4*4


;     ; PUSH dword  0x8200/16 ; 
;     ; PUSH dword  0
;     ; PUSH dword  0
;     ; call dword  _readHead
;     ; ADD ESP,3*4

;     ; PUSH dword  0xB3400/16 ; 
;     ; PUSH dword  40
;     ; call dword  _readCylinder
;     ; ADD ESP,2*4


;     PUSH dword  0x7e00/16 ; 
;     call dword  _readI82078
;     ADD ESP,1*4

    
;     ; CALL DWORD printMem

;     ; MOV ESI,0x00010000
;     ; CMP ESI,0xB3200
;     ; JB fin
    
;     call dword fin
;     ; RETF


; printMem:
;    MOV ESI,0x7e00
; ;    JMP printMemLoop
; printMemLoop:
;    MOV EAX,ESI
;    SHR EAX,16
;    CALL DWORD printAXHex
;    MOV EAX,ESI
;    CALL DWORD printAXHex
;    MOV EBX,[ESI]
;    MOV AL,BL
;    CALL DWORD printAXHex

;    MOV AL,'-'
;    CALL DWORD printALChar
;    ADD ESI,0x200
;    CMP ESI,0xFF00
;    JB printMemLoop
;    RETF
   



; ; void printChar(char ch);
; printALChar:
;     PUSH EAX
;     PUSH EBX

;     MOV AH,0x0e
;     MOV BX,15
;     INT 0x10

;     POP EBX
;     POP EAX
;     RETF

; ; void printBytesHex(char ch);
; printALHex:
;     PUSH ESI
;     PUSH EAX

;     MOV AX,[ESP]
;     MOV AH,0
;     SHR AL,4
;     MOV SI,hex
;     ADD SI,AX
;     MOV AX,[SI]
;     call dword printALChar

;     MOV AX,[ESP]
;     MOV AH,0
;     SHL AL,4
;     SHR AL,4
;     MOV SI,hex
;     ADD SI,AX
;     MOV AX,[SI]
;     call dword printALChar

;     POP EAX
;     POP ESI
;     RETF
    
; printAXHex:
;     PUSH EAX

;     SHR AX,8
;     call dword printALHex
    
;     MOV AX,[ESP]
;     CALL dword printALHex

;     POP EAX
;     RETF


; ; printEAXHex:
; ;    PUSH EAX
; ;    SHR EAX,16
; ;    CALL dword printAXHex
; ;    MOV EAX,[ESP]
; ;    CALL dword printAXHex
; ;    POP EAX
; ;    RETF


; ; C0-H0-S2 -> C0-H0-S18 
; ; another page    C0-H1-S1 -> C0-H1-S18
; ; ahother circle  C1-H0-S1 -> C1-H0-S18




; ; void readI82078(int targetAddr)
; ; {
; ;     for (int i = 0; i < 10; i++,targetAddr+=2 * 18 * 512 / 16)
; ;     {
; ;         readCylinder(i, targetAddr);
; ;     }
; ; }
; _readI82078:
;     PUSH dword  EAX
;     PUSH dword  EDX
;     MOV EDX,[ESP+4+8]
; _readI82078ForInit:
;     MOV EAX,0 ; int i = 0
;     JMP _readI82078ForCmp
; _readI82078ForCmp:
;     CMP EAX,30 ; i<80
;     JB _readI82078ForBody
;     JMP _readI82078ForLeaf
; _readI82078ForNext:
;     ADD EAX,1 ; i++
;     ADD EDX,2*18*512/16 ;targetAddr+=2*18*512/16
;     JMP _readI82078ForCmp
; _readI82078ForBody:
;     PUSH dword  EDX ;targetAddr
;     PUSH dword  EAX ;cylinder
;     call dword _readCylinder
;     ADD ESP,2*4
;     JMP _readI82078ForNext
; _readI82078ForLeaf:
;     POP dword EDX
;     POP dword EAX
;     RETF




; ; void readCylinder(int cylinder, int targetAddr)
; ; {
; ;     readHead(cylinder, 0, targetAddr);
; ;     targetAddr+= 18 * 512 / 16
; ;     readHead(cylinder, 1, targetAddr);
; ; }
; _readCylinder:
;     PUSH dword  EBX
;     PUSH dword  ECX

;     MOV EBX,[ESP+4+8] ; cylinder
;     MOV ECX,[ESP+8+8] ; targetAddr

;     PUSH dword  ECX
;     PUSH dword  0
;     PUSH dword  EBX
;     CALL dword _readHead
;     ADD ESP,3*4

;     ADD ECX,18*512/16

;     PUSH dword  ECX
;     PUSH dword  1
;     PUSH dword  EBX
;     CALL dword _readHead
;     ADD ESP,3*4

;     POP dword ECX
;     POP dword EBX
;     RETF


; ; void readHead(int cylinder, int head, int targetAddr)
; ; {
; ;     for (int i = 1; i <= 18; i++,targetAddr+=512/4)
; ;     {
; ;         readSector(cylinder, head, i, targetAddr);
; ;     }
; ; }
; _readHead:
;     PUSH dword  EAX
;     PUSH dword  EBX
;     PUSH dword  ECX
;     PUSH dword  EDX

;     MOV EBX,[ESP+4+16] ; cylinder
;     MOV ECX,[ESP+8+16] ; head
;     MOV EDX,[ESP+12+16] ; targetAddr
; _readHeadForInit:
;     MOV EAX,1 ; int i = 1
;     JMP _readHeadForCmp
; _readHeadForCmp:
;     CMP EAX,18 ; i<=18
;     JBE _readHeadForBody
;     JMP _readHeadForLeaf
; _readHeadForNext:
;     ADD EAX,1 ; i++
;     ADD EDX,512/16 ;targetAddr+=512/16   512byte
;     JMP _readHeadForCmp
; _readHeadForBody:
;     PUSH dword  EDX ;targetAddr
;     PUSH dword  EAX ;sector
;     PUSH dword  ECX ;head
;     PUSH dword  EBX ;cylinder
;     call dword _readSector
;     ADD ESP,4*4 ; pop
;     JMP _readHeadForNext
; _readHeadForLeaf:
;     POP dword EDX
;     POP dword ECX
;     POP dword EBX
;     POP dword EAX
;     RETF


; ; void readSector(int cylinder, int head, int sector, int targetAddr);
; _readSector:
;     PUSH dword  EAX
;     PUSH dword  EBX
;     PUSH dword  ECX
;     PUSH dword  EDX

;     MOV CH,[ESP+4+16]  ; 柱面 C0
;     MOV DH,[ESP+8+16]  ; 磁头 H0
;     MOV CL,[ESP+12+16] ; 扇区 S2
;     MOV ES,[ESP+16+16]

;     MOV AH,0x02         ; AH=0x02 : 读入磁盘
;     MOV AL,1            ; 1个扇区
;     MOV BX,0
;     MOV DL,0x00         ; A驱动器
;     INT 0x13            ; 调用磁盘BIOS
;     JNC _readSectorLeaf    ; 没出错则跳转到next
;     JMP error           ; 否则跳转到失败
; _readSectorLeaf:
;     POP dword EDX
;     POP dword ECX
;     POP dword EBX
;     POP dword EAX
;     RETF


; error:
;    MOV AL,"E"
;    CALL DWORD printALChar
;    JMP sleep

; fin:
;    MOV AL,"S"
;    CALL DWORD printALChar
;    JMP sleep
;    JMP 0x7c00+0x004200

; sleep:
;     HLT
;     JMP sleep

; hex:
;     DB "0123456789ABCDEF"

; times 510 - ($ - $$) db 0 ; fill with 0 untill arrive 512 bytes
; dw 0xaa55

; ; times 80*2*18*512 - ($ - $$) db 0 ; fill with 0 untill arrive 512 bytes



