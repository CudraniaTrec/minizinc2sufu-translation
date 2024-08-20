int: n = 3;
array[1..n] of int: d = [2, 2, 2];
int: D = sum(d);
int: m = 1;
int: c = 2;
array[1..D] of int: h = [1, 2, 3, 4, 5, 6];

% pre_d记录数组d的前缀和（从起始到某个月的总需求）
array[1..n] of var int: pre_d;
constraint forall(i in 1..n)(pre_d[i] = sum(j in 1..i)(d[j]));

% make记录每个月额外生产的数量
array[1..n] of var 0..D: make;
array[1..n] of var int: pre_make;
constraint forall(i in 1..n)(pre_make[i] = sum(j in 1..i)(m + make[j]));
constraint forall(i in 1..n)(pre_make[i] >= pre_d[i]);

var int: cost;
constraint cost = sum(i in 1..n)(make[i] * c + h[pre_make[i] - pre_d[i] + 1]);

solve minimize cost;
output ["cost: ", show(cost), " D: ", show(D), " make: ", show(make), " pre_d: ", show(pre_d), " pre_make: ", show(pre_make)];