int: n = 20;
int: m = 3;
array[1..m] of int: L = [2, 8, 10];

% choose表示每一步拆分的位置的序号（用序号进一步从L中获取对应的坐标）
array[1..m] of var 1..m: choose;
constraint forall(i in 1..m)(choose[i] >= 1 /\ choose[i] <= m);
constraint forall(i in 1..m)(forall(j in 1..m)(i = j \/ choose[i] != choose[j]));

% partial_result记录每一步拆分的代价
array[1..m] of var int: partial_result;
% prev记录每一步拆分涉及区间的起始点的坐标，next记录每一步拆分涉及区间的终止点的坐标
array[1..m] of var int: prev;
array[1..m] of var int: next;
constraint forall(i in 1..m)(prev[i] = max([if choose[j] < choose[i] then L[choose[j]] else 1 endif | j in 1..i]));
constraint forall(i in 1..m)(next[i] = min([if choose[j] > choose[i] then L[choose[j]] else n endif | j in 1..i]));
constraint forall(i in 1..m)(partial_result[i] = next[i] - prev[i] + 1);

var int: result;
constraint result = sum(partial_result);

solve minimize result;
output ["result: ", show(result), " choose: ", show(choose), " prev: ", show(prev), " next: ", show(next), " partial_result: ", show(partial_result)];