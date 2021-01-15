.section .text
.global cpuHlt
.global readSector
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
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	addq	$1, -8(%rbp)
	addq	$1, -8(%rbp)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	printStr, .-printStr