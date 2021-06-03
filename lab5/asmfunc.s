	.arch armv8-a
	.data
	.text
	.align 2
	.global Processasm
	.type	Processasm, %function
Processasm:
	stp		x29, x30, [sp, #-16]!
	stp		x27, x28, [sp, #-16]!
	stp		x25, x26, [sp, #-16]!
	cbz		x0, L5
	mov		x25, x0
	mov		x27, x4 //new_x
	mov		x28, x5 //new_y
	mov		x26, x3 //n
	scvtf	d0, x1 //x
	scvtf	d1, x4 //new_x
	scvtf	d10, x2 //y
	scvtf	d3, x5 //new_y
	fdiv	d1, d0, d1 //k1
	fdiv	d2, d10, d3 //k2
	mul		x0, x4, x5
	mul		x0, x0, x3 //size
	bl		malloc
	cbz		x0, L5
	fcvtms	x11, d0
	fcvtms	x12, d10
	mov		x2, #0 //i
	mul		x5, x27, x26 //new_x*n
0:
	cmp		x2, x28
	beq		L6
	mov		x3, #-1
	scvtf	d5, x2//i
	fmul	d6, d5, d2 //k2*i
	fcvtms	x7, d6 //m
	mul		x17, x7, x11//m*x
	mul		x8, x2, x27 //i*new_x
1:
	add		x3, x3, #1
	cmp		x3, x5
	beq		5f
	scvtf	d3, x3 //j
	fmul	d4, d1, d3 //k1 *j
	fcvtms	x6, d4 //l
	madd	x18, x8, x26, x3 //index
2:
	udiv	x13, x6, x26
	msub	x14, x13, x26, x6 //remainder
	cbz		x14, 3f
	add		x6, x6, #1
	b		2b
3:
	madd	x15, x17, x26, x6
	ldr		x10, [x25, x15]
	str		x10, [x0, x18]
	mov		x9, #1
/*2:
	udiv	x13, x6, x26
	msub	x14, x13, x26, x6 //remainder
	cbz		x14, 3f
	add		x6, x6, #1
	b		2b
*/	
4:
	cmp		x9, x26
	beq		1b
	add		x3, x3, #1
	add		x18, x18, #1
	add		x15, x15, #1
	ldr		x10, [x25, x15]
	str		x10, [x0, x18]
	add		x9, x9, #1
	b		4b
5:
	add		x2, x2, #1
	b		0b
L5:
	mov		x0, #0
L6:
	ldp		x25, x26, [sp], #16
	ldp		x27, x28, [sp], #16
	ldp		x29, x30, [sp], #16
	ret
	.size Processasm, .-Processasm 







