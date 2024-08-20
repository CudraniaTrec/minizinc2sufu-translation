% 输入变量定义
int: n = 3;
int: m = 3;
array[1..n] of int: a = [1, 2, 3];
array[1..m] of int: b = [1, 2, 2];

% 枚举所有操作列表
enum Operations = {copy, replace, delete, insert, twiddle, kill, empty};

% 操作数组，每个位置表示对应操作的数值
array[1..m+1] of var Operations: op;
var 1..m+1: len_op;
array[1..m+1] of var 1..n: pos_a;
array[1..m+1] of var 1..m: pos_b;

constraint pos_a[len_op] = n;
constraint pos_b[len_op] = m;
constraint forall(i in 1..len_op)(op[i] != empty);
constraint forall(i in len_op+1..m+1)(op[i] = empty);

constraint(
if op[1] = copy then a[pos_a[1]] = b[pos_b[1]] /\ pos_a[1] = 1 /\ pos_b[1] = 1
elseif op[1] = replace then pos_a[1] = 1 /\ pos_b[1] = 1
elseif op[1] = delete then pos_a[1] = 1 /\ pos_b[1] = 0
elseif op[1] = insert then pos_a[1] = 0 /\ pos_b[1] = 1
elseif op[1] = twiddle then a[1] = b[2] /\ a[2] = b[1] /\ pos_a[1] = 2 /\ pos_b[1] = 2
elseif op[1] = kill then pos_a[1] = n /\ pos_b[1] = 0
elseif op[1] = empty then n = 0 /\ m = 0
else true endif
);

constraint forall(i in 2..len_op)(
if op[i] = copy then a[pos_a[i]] = b[pos_b[i]] /\ (pos_a[i] - pos_a[i-1] = 1) /\ (pos_b[i] - pos_b[i-1] = 1)
elseif op[i] = replace then (pos_a[i] - pos_a[i-1] = 1) /\ (pos_b[i] - pos_b[i-1] = 1)
elseif op[i] = delete then (pos_a[i] - pos_a[i-1] = 1) /\ (pos_b[i] - pos_b[i-1] = 0)
elseif op[i] = insert then (pos_a[i] - pos_a[i-1] = 0) /\ (pos_b[i] - pos_b[i-1] = 1)
elseif op[i] = twiddle then pos_a[i] >= 2 /\ pos_b[i] >= 2 /\ a[pos_a[i]-1] = b[pos_b[i]] /\ a[pos_a[i]] = b[pos_b[i]-1] /\ (pos_a[i] - pos_a[i-1] = 2) /\ (pos_b[i] - pos_b[i-1] = 2)
elseif op[i] = kill then pos_a[i] = n /\ pos_b[i] = pos_b[i-1]
else true endif
);


% 最小化操作的总代价
var int: total_cost = 
sum(i in 1..m)
  (
    if op[i] = copy then 3
    elseif op[i] = replace then 1
    elseif op[i] = delete then 1
    elseif op[i] = insert then 4
    elseif op[i] = twiddle then 1
    elseif op[i] = kill then 1
    else 0
    endif
  );
  
solve minimize total_cost;

% 输出结果
output [show(total_cost), " operations: ", show(op), " len_op: ", show(len_op), " pos_a: ", show(pos_a), " pos_b: ", show(pos_b)];