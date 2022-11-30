#include <stdio.h>
#include <math.h>
//Функция для полинома:
double F(double x) {
    return pow(2, x*x+1) + x*x-4;
}
//Функция поиска корня:
double FindRoot(double (*f)(double),double a,double b,double eps){
    double c;
    while((b-a)/2>eps){
        c=(a+b)/2;
        if((f(a)*f(c))>0) a=c;
        else b=c;
    }
    return c;
}
    int main(){
    //Интервал, погрешность и корень:
    double a = 0, b = 1, eps = 0.001, x;
    //Поиск решения:
    for(;eps>=0.00000001; eps/=10){
        x = FindRoot(F,a,b,eps);
        printf("eps = %.10f => x = %.10f\n", eps, x);        
    }
    return 0;
}
