.code16gcc
.section .text
.global cpuHlt
.global readSector
.global _start
_start:
  movw %cs, %ax
  movw %ax, %ds
  movw %ax, %ss
  call printStr
  call sleep
cpuHlt:
  HLT
  RET
readSector:
  RET
sleep:
  call cpuHlt
  jmp sleep

	.globl	printStr
	.type	printStr, @function
printStr:

  movw $hello, %ax
  movw %ax, %bp
  movw $16, %cx
  movw $0x1301, %ax
  movw $0x000c, %bx
  movb $0x00, %dl
  int $0x10
  ret

.global hello
hello:
  .ascii "polinx start! "
