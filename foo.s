        .intel_syntax noprefix                  #

        .text                                   #  начинает секцию

        .globl  F                               # / объявляет функцию F
        .type   F, @function                    # \
F:
        push    rbp                             # сохраняем rbp на стек
        mov     rbp, rsp                        # rbp := rsp
        sub     rsp, 16                         # rsp -= 16
	movsd	QWORD PTR -8[rbp], xmm0		# x
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := x
	movapd	xmm1, xmm0			# xmm1 := x
	mulsd	xmm1, xmm0			# xmm1 := x*x
	movsd	xmm0, QWORD PTR .LC0[rip]	# xmm0 := 1
	addsd	xmm0, xmm1			# xmm0 := x*x + 1
	mov	rax, QWORD PTR .LC1[rip]	# rax := 2
	movapd	xmm1, xmm0			# xmm1 := xmm0
	movq	xmm0, rax			# xmm0 := rax
	call	pow@PLT				# pos(2, x*x+1)
	movapd	xmm1, xmm0			# xmm1 := xmm0
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := x;
	mulsd	xmm0, xmm0			# xmm0 := x*x
	addsd	xmm0, xmm1			# xmm0 := pow(2, x*x+1) + x*x
	movsd	xmm1, QWORD PTR .LC2[rip]	# xmm1 := 4
	subsd	xmm0, xmm1			# xmm0 -= 4
	movq	rax, xmm0			# rax := xmm0
	movq	xmm0, rax			# xmm0 := rax
	leave					# / return xmm0;
	ret					# \
	.size	F, .-F

	.globl	FindRoot			# / объявление фукнции FindRoot
	.type	FindRoot, @function		# \
FindRoot:
	push	rbp				# сохраняем rbp на стек
	mov	rbp, rsp			# rbp := rsp
	sub	rsp, 64				# rsp -= 64
	mov	QWORD PTR -24[rbp], rdi		# f
	movsd	QWORD PTR -32[rbp], xmm0	# a
	movsd	QWORD PTR -40[rbp], xmm1	# b
	movsd	QWORD PTR -48[rbp], xmm2	# eps
	jmp	.L4
.L7:
	movsd	xmm0, QWORD PTR -32[rbp]	# xmm0 := a
	addsd	xmm0, QWORD PTR -40[rbp]	# xmm0 := a + b
	movsd	xmm1, QWORD PTR .LC1[rip]	# mxx1 := 2
	divsd	xmm0, xmm1			# (a+b)/2
	movsd	QWORD PTR -8[rbp], xmm0		# c = xmm0
	mov	rax, QWORD PTR -32[rbp]		# rax := a
	mov	rdx, QWORD PTR -24[rbp]		# rdx := f
	movq	xmm0, rax			# xmm0 = a
	call	rdx				# f(a)
	movsd	QWORD PTR -56[rbp], xmm0	# f(a)
	mov	rax, QWORD PTR -8[rbp]		# rax := c
	mov	rdx, QWORD PTR -24[rbp]		# rdx = f
	movq	xmm0, rax			# xmm0 = c
	call	rdx				# f(c)
	mulsd	xmm0, QWORD PTR -56[rbp]	# xmm0 := f(a) * f(c)
	pxor	xmm1, xmm1			# xmm1 := 0
	comisd	xmm0, xmm1			# if(f(a)*f(c)>0)
	jbe	.L10
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := c
	movsd	QWORD PTR -32[rbp], xmm0	# a := xmm0
	jmp	.L4
.L10:
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 = c
	movsd	QWORD PTR -40[rbp], xmm0	# b = xmm0
.L4:
	movsd	xmm0, QWORD PTR -40[rbp]	# xmm0 := b
	subsd	xmm0, QWORD PTR -32[rbp]	# xmm0 := b-a
	movsd	xmm1, QWORD PTR .LC1[rip]	# mxx1 := 2
	divsd	xmm0, xmm1			# (b-a)/2
	comisd	xmm0, QWORD PTR -48[rbp]	# (b-a)/2 > eps
	ja	.L7
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := c
	movq	rax, xmm0			# rax := xmm0
	movq	xmm0, rax			# xmm0 := c
	leave					# / return c;
	ret					# \
	.size	FindRoot, .-FindRoot
	.section	.rodata
.LC5:
	.string	"eps = %.10f => x = %.10f\n"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp				# сохраняем rbp на стек
	mov	rbp, rsp			# rbp := rsp
	sub	rsp, 32				# rsp -= 32
	pxor	xmm0, xmm0			# xmm := 0 
	movsd	QWORD PTR -16[rbp], xmm0	# a := 0
	movsd	xmm0, QWORD PTR .LC0[rip]	# xmm0 := 1
	movsd	QWORD PTR -24[rbp], xmm0	# b := 1
	movsd	xmm0, QWORD PTR .LC4[rip]	# xmm0 := 0.001
	movsd	QWORD PTR -8[rbp], xmm0		# eps := 0.001
	jmp	.L12
.L13:
	movsd	xmm1, QWORD PTR -8[rbp]		# xmm1 := eps
	movsd	xmm0, QWORD PTR -24[rbp]	# xmm0 := b
	mov	rax, QWORD PTR -16[rbp]		# rax := a
	movapd	xmm2, xmm1			# xmm2 := eps
	movapd	xmm1, xmm0			# xmm1 := b
	movq	xmm0, rax			# xmm0 := a
	lea	rax, F[rip]			# rax := F
	mov	rdi, rax			# rdi := F
	call	FindRoot			# FindRoot(F, a, b, eps);
	movq	rax, xmm0			# rax := FindRoot
	mov	QWORD PTR -32[rbp], rax		# x = FindRoot
	movsd	xmm0, QWORD PTR -32[rbp]	# xmm0 := x
	mov	rax, QWORD PTR -8[rbp]		# rax := eps
	movapd	xmm1, xmm0			# xmm1 := x
	movq	xmm0, rax			# xmm0 := eps
	lea	rax, .LC5[rip]			# .string "eps = %.10f => x = %.10f\n"
	mov	rdi, rax			# rdi := rax
	mov	eax, 2				# eax := 2
	call	printf@PLT			# print("eps = %.10f => x = %.10f\n")
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := eps
	movsd	xmm1, QWORD PTR .LC6[rip]	# xmm1 := 10
	divsd	xmm0, xmm1			# eps /= 10
	movsd	QWORD PTR -8[rbp], xmm0		# eps = eps/10
.L12:
	movsd	xmm0, QWORD PTR -8[rbp]		# xmm0 := eps
	comisd	xmm0, QWORD PTR .LC7[rip]	# eps >= 0.00000001
	jnb	.L13
	mov	eax, 0				# /
	leave					# | return 0;
	ret					# \
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:						# 1
	.long	0
	.long	1072693248
	.align 8
.LC1:						# 2
	.long	0
	.long	1073741824
	.align 8
.LC2:						# 4
	.long	0
	.long	1074790400
	.align 8
.LC4:						# 0.001
	.long	-755914244
	.long	1062232653
	.align 8
.LC6:						# 10
	.long	0
	.long	1076101120
	.align 8
.LC7:						# 0.00000001
	.long	-500134854
	.long	1044740494
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
