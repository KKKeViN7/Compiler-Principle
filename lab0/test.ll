;设置了目标三元组指定目标平台为x86-64架构的Linux操作系统
target triple = "x86_64-pc-linux-gnu"
;全局常量声明 const float neg = -1.0;
@neg = constant float -1.000000e+00, align 4

;全局变量声明 float res = 0;
@res = global float 0.000000e+00, align 4

;定义全局变量str，是一个长度为50的字符串
@str = global i8* getelementptr inbounds ([50 x i8], [50 x i8]* @.str, i32 0, i32 0), align 8

;定义全局变量数组a[3] int a[3]={0,1,0};
@a = global [3 x i32] [i32 0, i32 1, i32 0], align 4

;定义全局字符串常量，分别是错误输入的字符串和输入输出格式控制字符
@.str = private unnamed_addr constant [50 x i8] c"The input n should be greater than or equal to 0!\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

;定义函数fibonacci，返回值类型为整形，有一个整型的参数
define i32 @fibonacci(i32 %0) {
  ;传递参数，先通过%0，再赋值给%2
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4  ;%2=n
  br label %3

3: 
  %4 = load i32, i32* %2, align 4
  ;循环条件判定，决定进入循环体还是直接返回
  %5 = icmp sgt i32 %4, 0
  br i1 %5, label %6, label %14

6:  ;while循环体
  ;a[2] = a[0] + a[1];
  ;getelementptr inbounds是获取元素指针的指令，inbounds表示在边界内进行访问，即不会越界
  ;arg: 类型 指针 元素索引（行/列）
  ;nsw是add指令的一个修饰符，表示进行有符号整数加法时，不进行溢出检查（no signed wrap）
  %7 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 0), align 4
  %8 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 1), align 4
  %9 = add nsw i32 %7, %8
  store i32 %9, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 2), align 4
  
  ;a[0] = a[1];
  %10 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 1), align 4
  store i32 %10, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 0), align 4

  ;a[1] = a[2];
  %11 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 2), align 4
  store i32 %11, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 1), align 4

  ;n = n - 1;
  %12 = load i32, i32* %2, align 4
  %13 = sub nsw i32 %12, 1
  store i32 %13, i32* %2, align 4
  br label %3

14:
  ;return a[0];
  %15 = load i32, i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i64 0, i64 0), align 4
  ret i32 %15
}

define i32 @main() {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  ;int n;scanf("%d",&n);
  %2 = alloca i32, align 4
  %3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i32* %2)
  ;if语句判断 if(n>0)
  %4 = load i32, i32* %2, align 4
  %5 = icmp sgt i32 %4, 0
  br i1 %5, label %9, label %6

6:
  ;if语句判断 if(n==0)
  %7 = load i32, i32* %2, align 4
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %17

9:
  ;res=neg*fibonacci(n);
  %10 = load i32, i32* %2, align 4
  %11 = call i32 @fibonacci(i32 %10)
  ;将fibonacci()的返回值隐式转换成float
  %12 = sitofp i32 %11 to float
  %13 = fmul float -1.000000e+00, %12
  store float %13, float* @res, align 4

  ;printf("%f\n",res);
  %14 = load float, float* @res, align 4
  ;%f = double 所以这里把float类型的res转换成double类型
  %15 = fpext float %14 to double
  %16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), double %15)
  br label %20

17:
  ;printf("%s\n",str);
  %18 = load i8*, i8** @str, align 8
  %19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i8* %18)
  br label %20

20:
  ;默认return 0
  %21 = load i32, i32* %1, align 4
  ret i32 %21
}

;函数声明
declare i32 @__isoc99_scanf(i8*, ...)
declare i32 @printf(i8*, ...)