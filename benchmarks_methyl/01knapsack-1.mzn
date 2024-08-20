% 输入变量定义
int: n = 3;
array[1..n] of int: w = [1, 2, 3];
array[1..n] of int: v = [1, 2, 4];
int: capacity = 3;

% choose 记录每个物品是否选择
array[1..n] of var 0..1: choose;
constraint sum(i in 1..n)(w[i] * choose[i]) <= capacity;
var int: result;
constraint result = sum(i in 1..n)(v[i] * choose[i]);

solve maximize result;
output [show(result), " choose: ", show(choose)];