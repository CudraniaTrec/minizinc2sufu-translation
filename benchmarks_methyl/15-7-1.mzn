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

% path：路径上的每个点的序号
array[1..k+1] of var int: path;
var 1..k+1: path_len;
constraint path[1] = start;
constraint forall(i in 1..path_len-1)(exists(j in 1..m)(E[j,1] = path[i] /\ E[j,2] = path[i+1] /\ E[j,3] = s[i]));

solve maximize path_len;
output ["path_len: ", show(path_len), " path: ", show(path)];