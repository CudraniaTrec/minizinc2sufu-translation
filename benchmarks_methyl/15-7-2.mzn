% n：顶点数量，m：边的数量，k：要求的路径的长度，s：要求的路径
int: n = 3;
int: m = 3;
int: k = 2;
array[1..n] of int: V = [1, 2, 3];
% E中每个元素（边的起始点，边的终止点，边的tag）
array[1..m, 1..3] of int: E =
[|1, 3, 1,
|3, 2, 2,
|3, 1, 3 |];
int: start = 1;
array[1..k] of int: s = [1, 2];

% path：经过的边的序号
array[1..k] of var 1..m: path;
var 1..k: path_len;
constraint E[path[1], 1] = start;
constraint forall(i in 1..path_len)(E[path[i], 3] = s[i]);
constraint forall(i in 1..path_len-1)(E[path[i], 2] = E[path[i+1], 1]);

solve maximize path_len;
output ["path_len: ", show(path_len), " path: ", show(path)];