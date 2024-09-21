	.arch armv7-a		@定义目标架构，使用 ARMv7-a 指令集
	.text				@代码区
	.align	2
	.section .rodata	@rodata数据区，定义两个格式化字符串常量
	.align	2
_str0:
	.ascii	"%d"
	.align	2
_str1:
	.ascii	"%d\n"
	.align	2

	.global factorial	@定义全局变量factorial 并实现factorial函数
	.type factorial, %function
factorial:				@ function int factorial(int n)
	str lr, [sp,#-4]! 	@ sp = sp -4, Push lr 将链接寄存器（lr）的值存储到栈指针（sp）指向的内存地址中，并在存储后更新栈指针
    str r0, [sp,#-4]!  	@ Push r0 ，int n
	mov	r1, #1		    @ int r1=sum=1
	b	.L2	
.L2:		            @ while
	cmp r0,	#0	        @ compare n ? 0
	ble	.L3		        @ n <= 0
	mul	r1,	r0	        @ sum=sum*n
	sub	r0,	r0,	#1	    @ n=n-1
	b	.L2
.L3:
	add	sp,	sp, #4		@ drop n
	ldr	lr,	[sp], #4	@ recover lr
	bx	lr				@ return
	
	.global main
	.type main, %function
main:
    str lr, [sp,#-4]!   @ push lr
    sub sp, sp, #4    	@ open space for int n
	mov r1, sp			@ r1 = &n
	ldr	r0,	_bridge		@ r0 = "%d"
	bl	__isoc99_scanf	@ scanf("%d", &n)

	ldr	r0, [sp]		@ load para
	bl	factorial		@ call factorial

	ldr r0, _bridge+4	@ r0 = "%d\n"
	bl	printf			@ printf("%d\n", r1)

	add	sp,	sp,	#4		@ release space for n
	ldr	lr,	[sp], #4	@ recover lr
	mov r0, #0			@ 将main函数返回值设置为0
	bx	lr				@ quit

_bridge:
	.word	_str0
	.word	_str1