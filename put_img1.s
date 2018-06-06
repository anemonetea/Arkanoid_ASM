.global main
.balign 4

main:
	push {lr}
	ldr r0, =frameBufferInfo 	// frame buffer information structure
	bl initFbInfo			// from the C file

	ldr r0, =img
	mov r1, #608
	mov r2, #812
	mov r3, #16
	bl draw_img

	ldr r0, =img
	mov r1, #600
	mov r2, #212
	mov r3, #16
	bl draw_img
	
	pop {lr}
	bx lr

width .req r4
height .req r5

fb_ptr .req r6
fb_offset .req r7
i_r .req r8
img_size .req r9
addr .req r11
j_r .req r12

s_wid: .string "%d\n"
s_hi: .string "%d\n"

// Agrs:
//	r0 = address of image
//	r1 = width (x)
//	r2 = height (y)
//	r3 = image size in pixels
draw_img: 
	push {width, height, fb_ptr, fb_offset, i_r, addr, j_r, lr}

	mov addr, r0
	mov img_size, r3

	ldr r0, =frameBufferInfo
	ldr fb_ptr, [r0]
	ldr width, [r0, #4]
	ldr height, [r0, #8]
/*	
	ldr r0, =s_wid
	mov r1, width
	bl printf
	ldr r0, =s_hi
	mov r1, height
	bl printf
*/

// element fb_offset = (y * width) + x
	mul fb_offset, r2, width
	add fb_offset, r1

// physical fb_offset *= 4 (each pixel is 4 bytes in size)
	lsl fb_offset, #2

	mov j_r, #0
	mov i_r, #0

loop:
	ldr r0, [addr]
	str r0, [fb_ptr, fb_offset]
	add i_r, #1	
	add fb_offset, #4		// increment fb horizontally (by 4 bytes ie 1 px) 
	add addr, #4			// increment address to load from to the next image pixel in img
	cmp i_r, img_size		// if i_r < 16*4 (image length in bytes),
	blo loop
	
	add fb_offset, width, lsl #2
	sub fb_offset, img_size, lsl #2 
	mov i_r, #0
	add j_r, #1			// increment vertically
	cmp j_r, img_size
	blt loop


	pop {width, height, fb_ptr, fb_offset, i_r, addr, j_r, lr}
	bx lr


@ Data section
.section .data

.align 2
//.globl frameBufferInfo

frameBufferInfo:
	.word	0		@ frame buffer pointer
	.word	0		@ screen width
	.word	0		@ screen height

.align 4

img: .ascii "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000!!!#!!!\177\"\"&\275\"\"%\350\"\"%\350\"\"&\275"
.ascii "!!!\177!!!#\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000!!!g"
.ascii "\036\036U\35622\271\376[[\371\377qq\376\377nn\376\377YY\371\37777\276\376\037\037Y\356!!!g\000\000\000\000"
.ascii "\000\000\000\000\000\000\000\000\000\000\000\000!!!\005!!!\245\031\030\215\374PP\374\377\202\202\377\377\221\221\377\377\234\234\377\377"
.ascii "\223\223\377\377\205\205\377\377xx\377\377WW\376\377!!\226\374!!!\245!!!\005\000\000\000\000\000\000\000\000!!!\202"
.ascii "\017\017~\374;;\353\377]]\377\377\205\205\377\377\224\224\377\377\232\232\377\377\224\224\377\377\207\207\377\377vv\377\377bb\377\377"
.ascii "BB\362\377\023\023\213\373!!!\177\000\000\000\000!!!)\030\027R\362\006\006\266\377**\334\377MM\377\377rr\377\377"
.ascii "\177\177\377\377\203\203\377\377\177\177\377\377ss\377\377ee\377\377TT\377\37777\351\377\021\021\301\377\030\027R\362!!!&"
.ascii "!!!\202\006\006\217\376\004\004\267\377\031\031\316\37766\353\377QQ\377\377cc\377\377hh\377\377cc\377\377[[\377\377"
.ascii "OO\377\377>>\363\377%%\332\377\014\014\277\377\006\006\217\376!!!\177\037\0375\315\002\002\247\377\001\001\270\377\007\007\276\377"
.ascii "\032\032\323\37700\351\377AA\372\377JJ\377\377JJ\377\377BB\373\37766\357\377$$\335\377\022\022\312\377\002\002\271\377"
.ascii "\002\002\247\377\037\0375\312\033\033D\353\001\001\245\377\001\001\262\377\001\001\262\377\003\003\274\377\023\023\315\377\037\037\332\377''\342\377"
.ascii "))\344\377$$\337\377\031\031\324\377\015\015\307\377\002\002\273\377\001\001\262\377\001\001\245\377\033\033F\345!!$\341\014\014\231\377"
.ascii "\001\001\250\377\001\001\253\377\001\001\262\377\002\001\265\377\003\003\277\377\010\010\304\377\012\012\307\377\011\011\305\377\005\005\301\377\001\001\265\377"
.ascii "\001\001\253\377\001\001\250\377\014\014\231\377!!$\333!!!\306\272\272\272\376tt\241\377\011\011\222\377\001\001\246\377\001\001\255\377"
.ascii "\002\002\241\377\230\230\311\377\230\230\311\377\002\002\241\377\001\001\255\377\001\001\246\377\011\011\222\377rr\242\377\272\272\272\376!!!\300"
.ascii "!!!\205yyy\370\363\363\363\377\355\355\355\377\251\251\251\377OO\210\377  Z\377\343\343\343\377\343\343\343\377  Z\377"
.ascii "OO\210\377\251\251\251\377\355\355\355\377\363\363\363\377yyy\370!!!\202!!!),,,\347\337\337\337\377\373\373\373\377"
.ascii "\373\373\373\377\366\366\366\377\232\232\232\377\134\134\134\377\134\134\134\377\232\232\232\377\366\366\366\377\373\373\373\377\373\373\373\377\334\334\334\377"
.ascii ",,,\347!!!)\000\000\000\000!!!\205\134\134\134\363\362\362\362\377\373\373\373\377\375\375\375\377\371\371\371\377\326\326\326\377"
.ascii "\326\326\326\377\371\371\371\377\375\375\375\377\374\374\374\377\362\362\362\377\134\134\134\363!!!\202\000\000\000\000\000\000\000\000!!!\005"
.ascii "!!!\245OOO\362\325\325\325\377\370\370\370\377\373\373\373\377\375\375\375\377\375\375\375\377\373\373\373\377\370\370\370\377\327\327\327\377"
.ascii "OOO\362!!!\245!!!\005\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000!!!g---\342\211\211\211\371"
.ascii "\303\303\303\376\364\364\364\377\364\364\364\377\303\303\303\376\211\211\211\371---\342!!!g\000\000\000\000\000\000\000\000\000\000\000\000"
.ascii "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000!!!#!!!\177!!!\273!!!\346!!!\346!!!\273"
.ascii "!!!\177!!!#\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
