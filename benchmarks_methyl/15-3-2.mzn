%input
int: N = 5;
array[1..N] of int: y = [1, 2, 3, 4, 5];

% path[i]=0表示i分配到l_path，path[i]=1表示i分配到r_path
array[1..N] of var 0..1: path;
array[1..N] of var 1..N: l_path;
array[1..N] of var 1..N: r_path;
var int: l_len;
var int: r_len;
constraint l_len + r_len = N + 2;
constraint l_path[1] = 1 /\ r_path[1] = 1 /\ l_path[l_len] = N /\ r_path[r_len] = N;
constraint forall(i in 2..l_len-1)(path[l_path[i]] = 0 /\ l_path[i] != 1 /\ l_path[i] != N);
constraint forall(i in 2..r_len-1)(path[r_path[i]] = 1 /\ r_path[i] != 1 /\ r_path[i] != N);
constraint forall(i in 2..l_len-1)(forall(j in 2..r_len-1)(l_path[i] != r_path[j]));

var int: ans;
constraint ans = sum([(l_path[i] - l_path[i+1]) * (l_path[i] - l_path[i+1]) + (y[l_path[i]] - y[l_path[i+1]]) * (y[l_path[i]] - y[l_path[i+1]]) | i in 1..l_len-1]) + sum([(r_path[i] - r_path[i+1]) * (r_path[i] - r_path[i+1]) + (y[r_path[i]] - y[r_path[i+1]]) * (y[r_path[i]] - y[r_path[i+1]]) | i in 1..r_len-1]);

%solve
solve minimize ans;

%output
output [show(ans), " l_path: ", show(l_path), " l_len: ", show(l_len), " r_path: ", show(r_path), " r_len: ", show(r_len)];
