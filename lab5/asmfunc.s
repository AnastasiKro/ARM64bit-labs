	.arch armv8-a
	.data
str:
	.string "I am here"
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
	//b 		L5
	//stp		x1, x2, [sp, #-16]!
	mov		x27, x4 //new_x
	mov		x28, x5 //new_y
	mov		x26, x3 //n
	//b L5
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
	mov		x2, #0 //i
	//adr		x0, str
	//b 		L5
0:
	cmp		x2, x28
	beq		L6
	mov		x3, #-1
1:
	add		x3, x3, #1
	mul		x5, x27, x26 //new_x*n
	cmp		x3, x5
	beq		5f
	scvtf	d3, x3 //j
	fmul	d4, d1, d3 //k1 *j
	fcvtms	x6, d4 //l
	scvtf	d5, x2 //i
	fmul	d6, d5, d2 //k2*i
	fcvtms	x7, d6 //m
	mul		x8, x2, x27 //i*new_x
	madd	x8, x8, x26, x3 //index
	//ldp		x11, x12, [sp], #16
	fcvtms	x11, d0
	fcvtms	x12, d10
	mul		x17, x7, x11 //m*x
2:
	udiv	x13, x6, x26
	msub	x14, x13, x26, x6 //remainder
	cbz		x14, 3f
	add		x6, x6, #1
	b		2b
3:
	madd	x17, x17, x26, x6
	ldr		x10, [x25, x17]
	str		x10, [x0, x8]
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
	add		x8, x8, #1
	add		x17, x17, #1
	ldr		x10, [x25, x17]
	str		x10, [x0, x8]
	add		x9, x9, #1
	b		4b
5:
	add		x2, x2, #1
	b		0b
L5:
	mov		x0, x11
L6:
	ldp		x25, x26, [sp], #16
	ldp		x27, x28, [sp], #16
	ldp		x29, x30, [sp], #16
	ret
	.size Processasm, .-Processasm 







