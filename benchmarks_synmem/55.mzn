int: n=5; 
array[1..n] of int: nums=[2, 3, 1, 1, 4]; 
array[1..n] of var 1..n: val;

% Constraint: Last element of val must be n-1
constraint val[n] == n;

% Constraint: val is non-decreasing
constraint forall(i in 1..n-1) (
    val[i] <= val[i + 1]
);
constraint forall(i in 1..n-1) (
    val[i] < val[i + 1] \/ val[i]==n
);

constraint forall(i in 1..n-1) (
    val[i + 1] - val[i] <= nums[val[i]]
);

solve satisfy; 