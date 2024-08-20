% 输入变量定义
int: m = 3;
int: n = 4;
array[1..m] of int: a = [1, 2, 4];
array[1..n] of int: b = [1, 2, 3, 4];

% x和y表示每个元素是否选择
array[1..m] of var 0..1: x;
array[1..n] of var 0..1: y;

% pre_x, pre_y 计算 x 和 y 的前缀和
array[1..m] of var int: pre_x;
array[1..n] of var int: pre_y;
constraint forall(i in 1..m)(pre_x[i] = sum(j in 1..i)(x[j]));
constraint forall(i in 1..n)(pre_y[i] = sum(j in 1..i)(y[j]));

% result 记录公共子序列的长度
var int: result;
constraint result <= m /\ result <= n;
constraint sum(x) = result /\ sum(y) = result;

% pos_a[i] = a 中第 i 个被选择的元素的下标
array[1..m] of var 1..m: pos_a;
array[1..n] of var 1..n: pos_b;
constraint forall(i in 1..result)(pos_a[i] = min([if pre_x[j] = i then j else m endif | j in 1..m]));
constraint forall(i in 1..result)(pos_b[i] = min([if pre_y[j] = i then j else n endif | j in 1..n]));

% 判断两个子序列是否相等
constraint forall(i in 1..result)(a[pos_a[i]] = b[pos_b[i]]);

solve maximize result;
output [show(result), " x: ", show(x), " y: ", show(y), " pos_a: ", show(pos_a), " pos_b: ", show(pos_b)];