% N: 点的数量，M：边的数量
int: N = 3;
int: M = 3;
int: start = 1;
int: end = 3;
array[1..M, 1..3] of int: edge = 
                 [| 1, 2, 10,
                  | 1, 3, 5,
                  | 2, 3, 1 |];

% path 记录路径上经过的边的序号，path_len 记录路径的长度
array[1..N] of var 1..M: path;
var int: path_len;
constraint edge[path[1], 1] = start;
constraint edge[path[path_len], 2] = end;
constraint forall(i in 1..path_len)(forall(j in 1..path_len)(i = j \/ path[i] != path[j]));
constraint forall(i in 1..path_len-1)(edge[path[i], 2] = edge[path[i+1], 1]);

var int: result;
constraint result=sum([edge[path[i],3] | i in 1..path_len]);

solve maximize result;

%output
output [show(result), " Path: ", show(path), " path_len: ", show(path_len)];

