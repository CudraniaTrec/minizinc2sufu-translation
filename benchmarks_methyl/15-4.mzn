int: n;
array[1..n] of int: l;
int: m;

% number of slices
var 1..n: num;
% left most index of each slice
array[0..n] of var 0..n: left;

% indices should be a increasing subsequence of 1..n
constraint left[0] == 0;
constraint left[num] == n;
constraint forall(i in 1..num)(left[i] > left[i - 1]);

% length of each slice
array[1..n] of var int: len;
constraint forall(i in 1..num)(
  len[i] == sum([l[j] | j in left[i-1]+1..left[i]]) + left[i] - left[i - 1] - 1
);

% length of each slice shouldn't be larger than m
constraint forall(i in 1..num)(len[i] <= m);

% total cost 
var int: total_cost;
constraint total_cost == sum([m - len[i] | i in 1..num - 1]);

solve minimize total_cost;
output [show(total_cost), " indices: ", show(left)];