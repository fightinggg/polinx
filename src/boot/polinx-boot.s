.code16gcc
.section .text
.global cpuHlt
.global readSector
.global _start
_start:
  movw %cs, %ax
  movw %ax, %ds
  movw %ax, %ss

  call loadPolinx
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
printAl:
  pushw %ax
  pushw %bx
  movb $0x0e,%ah
  movw $0x0f,%bx
  int $0x10
  popw %bx
  popw %ax
  ret

printStr:
  pushw %ax
  pushw %bx
  pushw %cx
  pushw %dx
  pushw %bp

	movl s, %eax
  movw %ax, %bp
  movw $16, %cx
  movw $0x1301, %ax
  movw $0x000c, %bx
  movb $0x00, %dl
  int $0x10

  popw %bp
  popw %dx
  popw %cx
  popw %bx
  popw %ax

  ret

.global hello
hello:
  .ascii "polinx start! "
