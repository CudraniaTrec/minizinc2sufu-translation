int: n=5;
int: m=2;
array[1..n] of int: nums=[2, 3, 1, 1, 4];

array[1..m] of var 1..n: val;

constraint val[m] == n; % 注意：MiniZinc数组索引从1开始，所以这里应该是n而不是n-1

constraint forall(i in 1..m-1) (val[i] < val[i+1]);

constraint forall(i in 1..m-1) (val[i+1] - val[i] <= nums[val[i]]);


solve satisfy;
