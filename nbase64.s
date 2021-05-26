	.arch armv8-a
	.data
mes:
	.ascii "as1udfjppo"
	.equ len, .-mes
errmsg1:
	.string "Usage "
	.equ    errlen1, .-errmsg1
errmsg2:
	.string " filename\n"
	.equ    errlen2, .-errmsg2
eq:
	.ascii "="
dot:
	.ascii "."
base:
	.ascii ".base64"
	.equ	blen, .-base
dict:
	.string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	.equ flen, 4
	.text
	.align 2
	.global _start
	.type	_start, %function
_start:
	ldr	x0, [sp]
	cmp	x0, #2
	beq	2f
	mov	x0, #2
	adr	x1, errmsg1
	mov	x2, errlen1
	mov	x8, #64
	svc	#0
	mov	x0, #2
	ldr	x1, [sp, #8]
	mov	x2, #0
0:
	ldrb	w3, [x1, x2]
	cbz	w3, 1f
	add	x2, x2, #1
	b	0b
1:
	mov	x8, #64
	svc	#0
	mov	x0, #2
	adr	x1, errmsg2
	mov	x2, errlen2
	mov	x8, #64
	svc	#0
	mov	x0, #1
	b 	3f
2:
	ldr 	x0, [sp, #16]
	bl 	work
3:
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
	.type	work, %function
	.text
	.align	2
	.equ	fname, 16
	.equ	fd1, 32
	
	.equ	buf1, 48
	.equ	fd2, 40
	.equ	buf2, 120

work:
	ldr	x0, [sp, #16]
	mov	x10, #0
	adr	x15, dict
	adr	x17, eq
	ldrb	w17, [x17]
	uxtw	x17, w17
	mov	x16, #220
	sub 	sp, sp, x16
	stp	x29, x30, [sp]
	mov	x29, sp
	str	x0, [x29, fname]
	mov	x0, #-100
	ldr	x1, [sp, #16]
	//adr 	x1, filename
	mov 	x2, #2
	mov	x8, #56
	svc	#0
	cmp	x0, #0
	blt	L1
	mov	x29, sp
	str	x0, [x29, fd1]
	add	x1, x29, buf1
	mov	x2, #72
	mov	x8, #63
	svc	#0
	mov	x29, sp
	mov	x19, x0 
	mov 	x9, buf2
	mov 	x5, #0
	mov	x14, #0
	mov	x21, #0
	mov	x6, #0
	b 	check
continue:
	ldr	x0, [x29, fd1]
	add	x1, x29, buf1
	mov	x2, #72
	mov	x8, #63
	svc	#0
	cbz	x0, L6
	cmp	x0, #0
	blt	L1
	mov	x19, x0
	mov	x5, #0
	mov	x14, #0
	mov	x9, buf2
	cmp	x21, #1
	beq	L3
	b	L0

check:
	adr	x18, base
	ldrb	w20, [x18]
	ldr	x8, [x29, fname]
	mov	x2, #0
	mov	x4, #0
0:
	ldrb	w3, [x8, x2]
	cbz	w3, L0
	cmp	w3, w20
	beq	1f
	add	x2, x2, #1
	b	0b
1:
	add	x4, x4, #1
	ldrb	w20, [x18, x4]
	add	x2, x2, #1
	ldrb	w3, [x8, x2]
	cbz	w3, 2f
	cbz	w20, L0
	cmp	w3, w20
	beq	1b
	b	L0
2:
	cmp	x4, blen
	beq	L3
	b 	L0
	
L0:
	add	x10, x14, buf1
	ldrb	w11, [sp, x10]
	cmp	x14, x19
	bge	createfilename
	lsr	x1, x11, #2
	uxtw	x1, w1
	add	x14, x14, #1
	lsl	x2, x11, #4
	lsl	x7, x1, #6
	sub	x2, x2, x7
	cmp	x14, x19
	bge	0f
	add	x10, x14, buf1
	ldrb	w12, [sp, x10]
	lsr	x7, x12, #4
	uxtw	x7, w7
	add	x2, x2, x7 //got 2
	lsl	x7, x7, #4
	sub 	x3, x12, x7
	lsl	x3, x3, #2
	add	x14, x14, #1
	cmp 	x14, x19
	bge	1f
	add	x10, x14, buf1
	ldrb	w13, [sp, x10]
	lsr	x8, x13, #6
	uxtw	x8, w8
	add	x3, x3, x8 //got 3
	lsl	x8, x8, #6
	sub	x4, x13, x8 //got 4
	add	x5, x5, #4
	add	x14, x14, #1
	b 	L2
0:
	add	x14, x14, #1
	mov	x3, #-1
1:
	add	x14, x14, #1
	mov	x4, #-1
	add	x5, x5, #4
	b 	L2
L2:
	ldrsb	w7, [x15, x1]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	ldrsb	w7, [x15, x2]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	cmp	x3, #-1
	beq	2f
	ldrsb	w7, [x15, x3]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	cmp	x4, #-1
	beq	1f
	ldrsb	w7, [x15, x4]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	b L0

0:
	cmp	x4, #-1
	beq	2f
	ldrsb	w7, [x15, x3]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	ldrsb	w7, [x15, x4]
	strb	w7, [x29, x9]
	add	x9, x9, #1
	b L0
2:
	mov	x29, sp
	strb	w17, [x29, x9]
	add	x9, x9, #1
1:
	mov 	x29, sp
	strb	w17, [x29, x9]
	add	x9, x9, #1
	b 	createfilename
L1:
	bl	writeerr
	b 	L6
L3:
	mov	x21, #1
	mov	x1, #1
	cmp	x14, x19
	bge	createfname2
	mov	x11, #0
	mov	x12, #0
	mov	x13, #0
	mov	x4, #0
	mov	x8, #0
4:
	add	x10, x14, buf1
	ldrb	w0, [sp, x10]
	cmp	x14, x19
	bge	createfname2
0:	
	ldrb	w7, [x15, x8]
	cmp	w0, w17
	beq	7f
	cmp 	w0, w7
	beq	5f
	cmp	x1, #1
	beq	1f
	cmp	x1, #2
	beq	2f
	cmp	x1, #3
	beq	3f
	add	x4, x4, #1
	add	x8, x8, #1
	b	0b
1:
	add	x11, x11, #1
	add	x8, x8, #1
	b	0b
2:	
	add	x12, x12, #1
	add	x8, x8, #1
	b	0b
3:
	add	x13, x13, #1
	add	x8, x8, #1
	b	0b
	
5:
	add	x14, x14, #1
	add	x1, x1, #1
	mov	x8, #0
	cmp	x1, #5
	beq	6f
	b 	4b
6:
	lsl	x1, x11, #2
	lsr	x2, x12, #4
	add	x1, x1, x2 //got 1
	lsl	x2, x2, #4
	sub	x2, x12, x2
	lsl	x2, x2, #4
	lsr	x3, x13, #2
	add	x2, x2, x3 //got 2
	lsl	x3, x3, #2
	sub	x3, x13, x3
	lsl	x3, x3, #6
	add	x3, x4, x3 //got 3
	add	x5, x5, 3
	b 	L4
7:
	cmp	x1, #3
	beq	8f
	lsl	x1, x11, #2
	lsr	x2, x12, #4
	add	x1, x1, x2 //got 1
	lsl	x2, x2, #4
	sub	x2, x12, x2
	lsl	x2, x2, #4
	lsr	x3, x13, #2
	add	x2, x2, x3 //got 2
	strb	w1, [x29, x9]
	add	x9, x9, #1
	strb	w2, [x29, x9]
	add	x5, x5, #2
	b 	createfname2
8:
	lsl	x1, x11, #2
	lsr	x2, x12, #4
	add	x1, x1, x2 //got 1
	add	x5, x5, #1
	strb	w1, [x29, x9]
	b 	createfname2
L4:
	strb	w1, [x29, x9]
	add	x9, x9, #1
	strb	w2, [x29, x9]
	add	x9, x9, #1
	strb	w3, [x29, x9]
	add	x9, x9, #1
	b L3	
createfilename:	
	cmp	x6, #1
	beq	writefile
	ldr	x1, [sp, #16]
	mov	x2, #0
3:	
	ldrb	w3, [x1, x2]
	cbz	w3, 4f
	add	x2, x2, #1
	b 	3b //go to the end of the filename
4:
	adr	x18, base
	mov	x4, #0
	add	x1, x1, x2 
5:
	cmp	x4, blen
	beq	6f
	ldrb	w3, [x18, x4]
	strb	w3, [x1]
	add	x1, x1, #1
	add	x4, x4, #1 //create new filename
	b	5b
6:
	strb	wzr, [x1]
	b	openfile
createfname2:
	cmp	x6, #1
	beq	writefile
	adr	x18, base
	ldrb	w18, [x18]
	ldr	x1, [sp, fname]
	mov	x2, #0
0:
	ldrb	w3, [x1, x2]
	cmp	w3, w18
	beq	1f
	add	x2, x2, #1
	b 	0b
1:
	strb	wzr, [x1, x2]
	b	openfile
openfile:
	mov	x0, #-100
	ldr	x1, [x29, fname]
	mov	x2, #0xc1
	mov	x3, #0600
	mov	x8, #56 //open file
	svc 	#0
	cmp	x0, #0
	blt	L1
	str	x0, [sp, fd2]
	b writefile
writefile:
	ldr	x0, [sp, fd2]
	add	x1, sp, buf2
	mov	x2, x5
	mov 	x8, #64
	svc	#0
	cmp	x0, #0
	blt	L1
	mov	x6, #1
	b 	continue
	
L6:
	ldp 	x29, x30,[sp]
	ldr	x0, [sp, fd1]
	mov	x8, #57
	svc	#0
	ldr	x0, [sp, fd2]
	mov	x8, #57
	svc	#0
	ldp	x29, x30, [sp]
	mov	x16, #220
	add	sp, sp, x16
	mov	x0, #0
	ret
	

	.data
nofile:
	.string "No sush file or directory\n"
	.equ nofilelen, .-nofile
permission:
	.string "Permission denied\n"
	.equ  permissionlen, .-permission
unknown:
	.string "Unknown error\n"
	.equ unknownlen, .-unknown
	.text
	.align 2
writeerr:
	cmp     x0, #-2
	bne     0f
	adr     x1, nofile
	mov     x2, nofilelen
	b       2f
0:
	cmp     x0, #-13
	bne     1f
	adr     x1, permission
	mov     x2, permissionlen
	b       2f
1:
	adr     x1, unknown
	mov     x2, unknownlen
2:
	mov     x0, #2
	mov     x8, #64
	svc     #0
	ret
	.size writeerr, .-writeerr
	
	
