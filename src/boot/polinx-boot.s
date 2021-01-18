.code16gcc
.section .text
.global cpuHlt
.global readSector
.global _start
_start:
  JMP toProtectedMode
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


toProtectedMode:
  cli                         # disable interrupts
  cld 
  xorw    %ax,%ax             # Segment number zero
  movw    %ax,%ds             # -> Data Segment
  movw    %ax,%es             # -> Extra Segment
  movw    %ax,%ss             # -> Stack Segment

seta20.1:
  inb     $0x64,%al               # Wait for not busy
  testb    $0x2,%al
  jnz     seta20.1
  movb    $0xd1,%al               # 0xd1 -> port 0x64
  outb    %al,$0x64
seta20.2:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.2
  movb    $0xdf,%al               # 0xdf -> port 0x60
  outb    %al,$0x60

  lgdt    gdtdesc
  movl    %cr0, %eax
  orl     $CR0_PE_ON, %eax
  movl    %eax, %cr0

gdt:
  SEG_NULLASM                             # null seg
  SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)        # code seg
  SEG_ASM(STA_W, 0x0, 0xffffffff)              # data seg

  gdt[CS].base_addr+EIP=0x0+0x7c32=0x7c32
  ljmp    $PROT_MODE_CSEG, $protcseg

  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
  movw    %ax, %ds                # -> DS: Data Segment
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS
  movw    %ax, %ss                # -> SS: Stack Segment