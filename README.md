Отчёт
1) Маланьин Артём Денисович
2) БПИ212
3) 32 вариант
Разработать программу, определяющую корень уравнения 2^(x^2+1) + x^2 − 4 = 0 методом половинного деления с точностью от 0,001 до
0,00000001 в диапазоне [0;1]. Если диапазон некорректен, то подобрать корректный диапазон.
Предполагаемая оценка - 6.
4) приведено решение задачи на языке С(foo.c).
5) получена и скомпилирована соответствующая ассемблерная программа, добавлены комметарии(foo.s)
gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./foo.c \
    -S -o ./foo.s

6) представлено полное тестовое покрытие дающее одинаковый резальтат на обоих программах.
tests/test1.in test1.out
Использование: gcc ./foo.c(или ./foo.s) -o ./foo.exe, ./foo.exe < tests/test1.in, 
а зачем сравниваем со значением cat tests/test1.out
7) были произведены изменения с удалением "бесполезных участков кода"
Например, в функции F я заменил строчки 
        subsd   xmm0, xmm1                      # xmm0 -= 4
        movq    rax, xmm0                       # rax := xmm0
        movq    xmm0, rax                       # xmm0 := rax
на строчки 
	subsd   xmm0, xmm1                      # xmm0 -= 4
        movq    xmm0, rax                       # xmm0 := rax

а в FindRoot: я заменил 
        movsd   xmm0, QWORD PTR -8[rbp]         # xmm0 := c
        movsd   QWORD PTR -32[rbp], xmm0        # a := xmm0
на 	
	movsd   QWORD PTR -32[rbp], QWORD PTR -8[rbp]   # a := с
а также 
        movsd   xmm0, QWORD PTR -8[rbp]         # xmm0 := c
        movsd   QWORD PTR -40[rbp], xmm0        # b := xmm0
на
	movsd   QWORD PTR -32[rbp], QWORD PTR -8[rbp]   # a := с
8) в программе использованы локальные и глобальные переменные, строки, числа с плавающей точкой, а так же функции для работы с ними.
9) добавлены комментарии описывающие связь между параметрами языка си и регистрами
10) оптимизация через использование дополнительных регистров не представляется возможной по причине того, что команды с постфиксом sd требуют использования хотя бы одного SSE регистра в качестве входного параметра, что приводит к ошибке