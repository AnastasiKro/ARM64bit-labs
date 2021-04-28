.arch armv8-a
	.data
mes:
	.ascii "as1udfjppo"
	.equ len, .-mes
eq:
	.ascii "="
dict:
	.string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
filename:
	.ascii "file"
	.equ	fname, 16
	.equ	fd, 24
	.equ	buf, 32
	.text
	.align 2
	.global _start
	.type	_start, %function
_start:
	adr	x0, mes
	mov	x10, #0
	adr	x15, dict
	adr	x17, eq
	ldrb	w17, [x17]
	uxtw	x17, w17
	mov	x16, #5028
	sub 	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	mov 	x9, buf
	mov 	x5, #0
	mov	w14, #0
	b 	L0
L0:
	ldrb	w11, [x0, x10]
	cmp	w14, len
	bge	L3
	lsr	x1, x11, #2
	uxtw	x1, w1
	add	x10, x10, #1
	add	w14, w14, #1
	lsl	x2, x11, #4
	lsl	x7, x1, #6
	sub	x2, x2, x7
	cmp	w14, len
	bge	0f
	ldrb	w12, [x0, x10]
	lsr	x7, x12, #4
	uxtw	x7, w7
	add	x2, x2, x7 //got 2
	lsl	x7, x7, #4
	sub 	x3, x12, x7
	lsl	x3, x3, #2
	add	x10, x10, #1
	add	w14, w14, #1
	cmp 	w14, len
	bge	1f
	ldrb	w13, [x0, x10]
	lsr	x8, x13, #6
	uxtw	x8, w8
	add	x3, x3, x8 //got 3
	lsl	x8, x8, #6
	sub	x4, x13, x8 //got 4
	add	x5, x5, #4
	add	w14, w14, #1
	b 	L2
0:
	add	w14, w14, #1
	mov	w3, #0
1:
	add	w14, w14, #1
	mov	w4, #0
	add	x5, x5, #4
	b 	L2
L2:
	ldrsb	w6, [x15, x1]
	strb	w6, [x29, x9]
	add	x9, x9, #1
	ldrsb	w6, [x15, x2]
	strb	w6, [x29, x9]
	add	x9, x9, #1
	cbz	x3, 0f
	ldrsb	w6, [x15, x3]
	strb	w6, [x29, x9]
	add	x9, x9, #1
	cbz	x4, 1f
	ldrsb	w6, [x15, x4]
	strb	w6, [x29, x9]
	add	x9, x9, #1
	mov	x10, #0
	add	x0, x0, #3
	b L0
0:
	mov	x29, sp
	strb	w17, [x29, x9]
	add	x9, x9, #1
1:
	mov 	x29, sp
	strb	w17, [x29, x9]
	add	x9, x9, #1
	b L3
L3:	
	mov	x0, #-100
	adr	x1, filename
	mov	x2, #2
//	mov	x3, #2
	mov	x8, #56 //open file
	svc 	#0
	str	x0, [sp, fd]
	ldp 	x29, x30,[sp]
	ldr	x0, [sp, fd]
	//mov 	x0, #2
	add	x1, sp, #32
	//adr	x1, mes
	mov	x2, x5
	//ldr	x1, [sp, buf]
	mov 	x8, #64
	svc	#0
	ldr	x0, [sp, fd]
	mov 	x8, #57
	svc	#0
L6:
	ldp	x29, x30, [sp]
	mov	x16, #5028
	add	sp, sp, x16
	mov	x0, #0
	mov 	x8, #93
	svc	 #0
	.size	_start, .-_start
