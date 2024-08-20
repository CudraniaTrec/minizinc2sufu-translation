int: n;
int: m;
array[1..n, 1..m] of int: cost;

% index of the removed pixel in each row
array[1..n] of var 1..m: removed;
constraint forall(i in 2..n)(removed[i-1] >= removed[i] - 1 /\ removed[i-1] <= removed[i] + 1);

% total cost
var int: tot;
constraint tot == sum([cost[i, removed[i]] | i in 1..n]);

solve minimize tot;
output [show(tot), " remove: ", show(removed)];