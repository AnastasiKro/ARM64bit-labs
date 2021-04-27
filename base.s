	.arch armv8-a
	.data
mes:
	.ascii "as1"
	.equ len, .-mes
dict:
	.string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
filename:
	.ascii "file"
mystr:
	.skip 1024
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
	adr	x5, filename
	adr	x15, dict
	b 	L0
L0:
	ldrb	w11, [x0, x10]
	cbz	w11, L6
	lsr	x1, x11, #2
	uxtw	x1, w1
	add	x10, x10, #1
	ldrb	w12, [x0, x10]
	lsl	x2, x11, #4
	lsl	x7, x1, #6
	sub	x2, x2, x7
	lsr	x7, x12, #4
	uxtw	x7, w7
	add	x2, x2, x7 //got 2
	lsl	x7, x7, #4
	sub 	x3, x12, x7
	lsl	x3, x3, #2
	add	x10, x10, #1
	ldrb	w13, [x0, x10]
	lsr	x8, x13, #6
	uxtw	x8, w8
	add	x3, x3, x8 //got 3
	lsl	x8, x8, #6
	sub	x4, x13, x8 //got 4

L1:
	mov	x16, #5028
	sub 	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
L2:
/*	adr	x9, mystr
	ldrsb	w6, [x15, x1]
	strb	w6, [x9]
	add 	x9, x9, #1
	ldrsb	w6, [x15, x2]
	strb	w6, [x9]
	add	x9, x9, #1
	ldrsb	w6, [x15, x3]
	strb	w6, [x9]
	add	x9, x9, #1
	ldrsb	w6, [x15, x4]
	strb	w6, [x9]
*/
	//ldp	x29, x30, [sp]
	ldrsb	w6, [x15, x1]
	strb	w6, [x29, buf]
	ldrsb	w6, [x15, x2]
	strb	w6, [x29, #33]
	ldrsb	w6, [x15, x3]
	strb	w6, [x29, #34]
	ldrsb	w6, [x15, x4]
	strb	w6, [x29, #35]
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
	mov	x2, #4
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
	
	
	
	
	
