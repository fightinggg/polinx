.code16gcc
.section .text
.global cpuHlt
.global readSector
.global _start
_start:
  call loadPolinx

	.globl	printStr
printStr:
	pushl	%ebp
	movl	%esp, %ebp
  pushw %ax
  pushw %bx
  pushw %cx
  pushw %dx
  pushw %bp
 
  movw 12(%ebp), %cx
	movw 8(%ebp), %bp
  movw $0x1301, %ax
  movw $0x000c, %bx
  movb $0x00, %dl
  int $0x10

  popw %bp
  popw %dx
  popw %cx
  popw %bx
  popw %ax

  popl %ebp
  ret
