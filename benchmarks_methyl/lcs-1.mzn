% 输入变量定义
int: m = 3;
int: n = 4;
array[1..m] of int: a = [1, 2, 4];
array[1..n] of int: b = [1, 2, 3, 4];

% x和y表示选取的子序列的下标
array[1..m] of var 1..m: x;
array[1..n] of var 1..n: y;

% result 记录公共子序列的长度
var int: result;
constraint result <= m /\ result <= n;
constraint forall(i in 1..result)(x[i] >= 1 /\ x[i] <= m);
constraint forall(i in 1..result-1)(x[i] < x[i+1]);
constraint forall(i in 1..result)(y[i] >= 1 /\ y[i] <= n);
constraint forall(i in 1..result-1)(y[i] < y[i+1]);
constraint forall(i in 1..result)(a[x[i]] = b[y[i]]);

solve maximize result;
output [show(result), " x: ", show(x), " y: ", show(y)];