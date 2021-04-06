	.arch armv8-a
//(a*b*c-c*d*e)/(a/b+c/d)
	.data
	.align 3
res:
	.skip 8
a:
	//.long -100
	.long 2147483647
b:
	//.short 20
	.short 32767
c:
	//.short 30
	.quad 9223372036854775807
	//.short 32767
d:
	//.short 10
	.short -32768
e:
	//.long 40
	.long 2147483647
	.text
	.align 2
	.global overflow
	.global exit
	.type exit, %function
	.type overflow, %function
	.global _start
	.type _start, %function
overflow:
	mov     x0, #1
//	b     exit
exit:
	mov     x8, #93
	svc     #0
	.size   _start, .-_start
_start:
	adr     x0, a
	ldrsw   x1, [x0]
	adr     x0, b
	ldrsh   w2, [x0]
	adr     x0, c
	ldr     x3, [x0]
	//ldrsh   w3, [x0]
	adr     x0, d
	ldrsh   w4, [x0]
	adr     x0, e
	ldrsw   x5, [x0]
	mul   x6, x2, x3
	mul   x6, x1, x6
	mul     x7, x3, x4
	mul   x7, x7, x5
	subs    x6, x6, x7
	bvs     overflow
	sdiv    x1, x1, x2
	sxtw   x4, w4
	sdiv    x3, x3, x4
	adds    x1, x1, x3
	bvs     overflow
	sdiv    x8, x6, x1
	adr     x0, res
	str     x8, [x0]
	mov     x0, #0
	B     exit

