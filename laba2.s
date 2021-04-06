	.arch armv8-a
//	HeapSort
	.data
	.align	1
n:
	.short	5
m:
	.short 3
matrix:
	.short 8, 7, 1, 14, 10
	.short 9, 5, 2, -3, 20
	.short 6, 0, 4, 3, 100 
	.text
	.align	2
	.global _start	
	.type	_start, %function
_start:
	adr	x0, n
	ldrsh	w0, [x0]
	adr     x10, m
	ldrsh   w10, [x10]
	adr	x1, matrix
	mov     w11, #0
	//lsr	w2, w0, #1
	//sub	w3, w0, #1
M0:
	cmp     w11, #3
	beq     L6
	lsr     w2, w0, #1
	sub     w3, w0, #1
	mul     w20, w0, w11
L0:
	cbz	w2, L1
	sub	w2, w2, #1
	b	L2
L1:
	cbz	w3, M6
	//mul     x14, x0, x11
	add     w12, w20, w2
	add     w13, w20, w3
	ldrsh	w7, [x1, x12, lsl #1]
	ldrsh	w8, [x1, x13, lsl #1]
	strh	w7, [x1, x13, lsl #1]
	strh	w8, [x1, x12, lsl #1]
	sub	w3, w3, #1
	cbz	w3, M6
L2:
	mov	w4, w2
	lsl	w5, w2, #1
	add     w12, w20, w2
	ldrsh	w7, [x1, x12, lsl #1] //w7 - our element
L3:
	add	w5, w5, #1
	cmp	w5, w3
	bgt	L5
	add     w15, w20, w5
	ldrsh	w8, [x1, x15, lsl #1] // child 1
	beq	L4
	add	w6, w5, #1
	add     w16, w20, w6
	ldrsh	w9, [x1, x16, lsl #1] //child 2
	cmp	w8, w9
	blt	L4
	add	w5, w5, #1
	mov	w8, w9
L4:
	cmp	w7, w8
	blt	L5
	add     w14, w20, w4
	strh	w8, [x1, x14, lsl #1]
	mov	w4, w5
	lsl	w5, w5, #1
	b	L3
L5:
	add     w14, w20, w4
	strh	w7, [x1, x14, lsl #1]
	b	L0
M6:
	add     w11, w11, #1
	b M0
L6:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
