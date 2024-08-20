int: n = 3;
array[1..n] of int: a = [2, 2, 2];
array[1..n+1] of int: b = [1, 1, 1, 1];

% choose记录每一步作为子树的根节点的元素在a中的序号
array[1..n] of var 1..n: choose;
constraint forall(i in 1..n)(forall(j in 1..n)(i = j \/ choose[i] != choose[j]));

% height_a记录a中每个元素的height，prev记录在a左侧并且已经被作为根节点的最邻近的点的序号，next记录在a右侧并且已经被作为根节点的最邻近的点的序号
array[1..n] of var 1..n: height_a;
array[1..n] of var 0..n+1: prev;
array[1..n] of var 0..n+1: next;
constraint forall(i in 1..n)(prev[choose[i]] = max([if choose[j] < choose[i] then choose[j] else 0 endif | j in 1..i]));
constraint forall(i in 1..n)(next[choose[i]] = min([if choose[j] > choose[i] then choose[j] else n+1 endif | j in 1..i]));
constraint forall(i in 1..n)(height_a[i] = 
if prev[i] = 0 /\ next[i] = n+1 then height_a[i] = 1
else if prev[i] = 0 then height_a[next[i]] + 1
else if next[i] = n+1 then height_a[prev[i]] + 1
else max(height_a[prev[i]], height_a[next[i]]) + 1
endif endif endif);

% height_b记录b中每个元素的height
array[1..n+1] of var 1..n+1: height_b;
constraint height_b[1] = height_a[1] + 1;
constraint height_b[n+1] = height_a[n] + 1;
constraint forall(i in 2..n)(height_b[i] = max(height_a[i-1], height_a[i]) + 1);

var int: result;
constraint result = sum(i in 1..n)(a[i] * height_a[i]) + sum(j in 1..n+1)(b[j] * height_b[j]);

solve minimize result;
output ["result: ", show(result), " choose: ", show(choose), " prev: ", show(prev), " next: ", show(next), " height_a: ", show(height_a), " height_b: ", show(height_b)];