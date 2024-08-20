% 输入变量定义
int: n = 3;
array[1..n] of int: w = [1, 2, 3];
array[1..n] of int: v = [1, 2, 4];
int: capacity = 3;

% choose 记录所选物品的下标
array[1..n] of var 1..n: choose;
var 0..n: choose_len;
constraint forall(i in 1..choose_len)(choose[i] >= 1);
constraint forall(i in 1..choose_len)(forall(j in 1..choose_len)(i = j \/ choose[i] != choose[j]));

constraint sum(i in 1..choose_len)(w[choose[i]]) <= capacity;

var int: result;
constraint result = sum(i in 1..choose_len)(v[choose[i]]);

solve maximize result;
output [show(result), " choose: ", show(choose), " choose_len: " , show(choose_len)];