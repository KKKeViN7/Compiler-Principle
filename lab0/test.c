#include<stdio.h>
const float neg = -1.0;
float res = 0;
char* str= "The input n should be greater than or equal to 0!";
int a[3]={1,1,0};

int fibonacci(int n)
{
    while(n>0)
    {
        a[2] = a[0] + a[1];
        a[0] = a[1];
        a[1] = a[2];
        n = n - 1;
    }
    return a[0];
}

int main()
{
    int n;
    scanf("%d",&n);
    if(n>0 || n==0){
        res=neg*fibonacci(n);    //计算斐波那契数列
        printf("%f\n",res);
    }
    else{
        printf("%s\n",str);
    }
}