/* Assembler macros to create x86 segments */

/* Normal segment */
#define SEG_NULLASM \
    .word 0, 0;     \
    .byte 0, 0, 0, 0

#define SEG_ASM(type, base, lim)                    \
    .word(((lim) >> 12) & 0xffff), ((base)&0xffff); \
    .byte(((base) >> 16) & 0xff), (0x90 | (type)),  \
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)

/* Application segment type bits */
#define STA_X 0x8 // Executable segment
#define STA_E 0x4 // Expand down (non-executable segments)
#define STA_C 0x4 // Conforming code segment (executable only)
#define STA_W 0x2 // Writeable (non-executable segments)
#define STA_R 0x2 // Readable (executable segments)
#define STA_A 0x1 // Accessed


# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
.set CR0_PE_ON,             0x1                     # protected mode enable flag

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # ss=ds=es=ax=0
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # ss=ds=es=fs=gs=ax=PROT_MODE_DSEG
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call printStr
spin:
    jmp spin

# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt

	.globl	printStr
printStr:
	pushl	%ebp
	movl	%esp, %ebp
    pushw %ax
    pushw %bx
    pushw %cx
    pushw %dx
    pushw %bp
    
    # ES:BP 字符串地址
    movw $10,%ax
    # mul dh
    addw $s, %ax
    movw %ax, %bp
    # ES:BP 字符串地址
    movw %ds,%ax
    movw %ax,%es
    
    movw $10,%cx #  字符串长度
    movw $0x1301, %ax # 
    movw $0x0007, %bx # 页号0, 白底黑字
    movw $0x0000, %dx # 0行 0列
    int $0x10

    popw %bp
    popw %dx
    popw %cx
    popw %bx
    popw %ax

    popl %ebp
    ret