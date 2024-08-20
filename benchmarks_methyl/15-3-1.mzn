% N：点的个数，y：每个点的纵坐标
int: N = 5;
array[1..N] of int: y = [1, 2, 3, 4, 5];

% l_path记录第一条路线上的横坐标，r_path记录第二条路线上的横坐标
array[1..N] of var int: l_path;
array[1..N] of var int: r_path;
var int: l_len;
var int: r_len;
constraint l_path[1] = 1;
constraint r_path[1] = 1;
constraint l_path[l_len] = N;
constraint r_path[r_len] = N;
constraint forall(i in 1..N)(l_path[i]>=1 /\ l_path[i]<=N);
constraint forall(i in 1..N)(r_path[i]>=1 /\ r_path[i]<=N);
constraint forall(i in 1..N)(forall(j in 1..N)(i=j \/ l_path[i]!=l_path[j]));
constraint forall(i in 1..N)(forall(j in 1..N)(i=j \/ r_path[i]!=r_path[j]));
constraint forall(i in 2..l_len-1)(forall(j in 2..r_len-1)(l_path[i]!=r_path[j]));

var int: ans;
constraint ans = sum([(l_path[i] - l_path[i+1]) * (l_path[i] - l_path[i+1]) + (y[l_path[i]] - y[l_path[i+1]]) * (y[l_path[i]] - y[l_path[i+1]]) | i in 1..l_len-1]) + sum([(r_path[i] - r_path[i+1]) * (r_path[i] - r_path[i+1]) + (y[r_path[i]] - y[r_path[i+1]]) * (y[r_path[i]] - y[r_path[i+1]]) | i in 1..r_len-1]);

%solve
solve minimize ans;

%output
output [show(ans), " l_path: ", show(l_path), " r_path: ", show(r_path)];
