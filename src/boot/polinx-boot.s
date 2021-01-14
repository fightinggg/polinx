.section .text
.global cpuHlt
.global readSector
.global printStr
.global _start
_start:
  movw %cs, %ax
  movw %ax, %ds
  movw %ax, %ss
  call printStr
  call loadPolinx
cpuHlt:
  HLT
  RET
readSector:
  RET

	.globl	printStr
	.type	printStr, @function
printStr:
.LFBPrintStr:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
  movw $rbp, %ax
  movw %ax, %bp
  movw $16, %cx
  movw $0x1301, %ax
  movw $0x000c, %bx
  movb $0x00, %dl
  int $0x10
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFEPrintStr:
	.size	printStr, .-printStr