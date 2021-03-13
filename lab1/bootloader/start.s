/* Real Mode Hello World */
#.code16

#.global start
#start:
#	movw %cs, %ax
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %ss
#	movw $0x7d00, %ax
#	movw %ax, %sp # setting stack pointer to 0x7d00

#loop:
#	jmp loop


/* Protected Mode Hello World */
.code16

.global start
start:
	cli
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss
	movw $0x2401, %ax
	int $0x15
	lgdt gdtdesc
	movl %cr0, %eax
	orl  $0x1, %eax
	movl %eax, %cr0
	ljmp $0x8, $start32
.code32
start32:
	movw $0x10, %ax # setting data segment selector
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %ss
	movl $0x8000, %eax
	movl %eax, %esp
	push $14
	push $message
	call print
loop32:
	jmp loop32

message:
	.string "Hello, World!\n\0"

print:
	push %ebp
	movl 0x8(%esp), %ebp   # messgae
	movl 0xc(%esp), %ecx   # len
	movl $0, %edx	       # i = 0
next:	
	movb (%ebp, %edx, 1), %al
	movb %al, 0xb8000(, %edx, 2)
	incl %edx
	loopnz next
	pop %ebp
	ret
	

.p2align 2

gdt:
	.word(0x0), (0x0)
	.byte(0x0), (0x0), (0x0), (0x0)

	.word(0xffff), (0x0)
	.byte(0x0), (0x9A), (0xCF), (0x0)

	.word(0xffff), (0x0)
	.byte(0x0), (0x92), (0xCF), (0x0)

gdtdesc:
	.word(gdtdesc - gdt - 1)
	.long(gdt)


/* Protected Mode Loading Hello World APP */

#.code16

#.global start
#start:
#	movw %cs, %ax
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %ss
#	#TODO: Protected Mode Here

#.code32
#start32:
#	movw $0x10, %ax # setting data segment selector
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %fs
#	movw %ax, %ss
#	movw $0x18, %ax # setting graphics data segment selector
#	movw %ax, %gs
	
#	movl $0x8000, %eax # setting esp
#	movl %eax, %esp
#	jmp bootMain # jump to bootMain in boot.c

#.p2align 2
#gdt: 
	#GDT definition here

#gdtDesc: 
	#gdtDesc definition here

