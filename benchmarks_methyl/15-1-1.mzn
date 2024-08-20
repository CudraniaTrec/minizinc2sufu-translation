int: N = 5;
int: start = 1;
int: end = 5;
array[1..N,1..N] of int: edge = 
                  [| 0, 10, 0, 5, 0,
                  | 0, 0, 1, 2, 0,
                  | 0, 0, 0, 0, 4,
                  | 0, 3, 9, 0, 2,
                  | 7, 0, 6, 0, 0 |];

% path 记录路径上经过的点，path_len 记录路径的长度
array[1..N] of var 1..N: path;
var int: path_len;
constraint path[1] = start;
constraint path[path_len] = end;
constraint forall(i in 1..path_len)(forall(j in 1..path_len)(i=j \/ path[i]!=path[j]));
constraint forall(i in 1..path_len-1)(edge[path[i],path[i+1]]!=0);

var int: result;
constraint result=sum([edge[path[i],path[i+1]] | i in 1..path_len-1]);

solve maximize result;

%output
output [show(result), " Path: ", show(path)];

