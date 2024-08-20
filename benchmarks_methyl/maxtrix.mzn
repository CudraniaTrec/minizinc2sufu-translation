int: n;
array[1..n, 1..2] of int: matrix;
constraint forall(i in 2..n)(matrix[i-1, 2] == matrix[i, 1]);

% the list of matrices in each step 
array[1..n, 1..n, 0..1] of var int: steps;
constraint forall(i in 1..n, j in 0..1)(steps[1, i, j] == matrix[i, j+1]);

% the choice of each step
array[1..n-1] of var 1..n: choice;
constraint forall(i in 1..n-1)(choice[i] <= n - i);
constraint forall(i in 1..n-1, j in 1..n-i+1, k in 0..1)(
  j < choice[i] -> steps[i, j, k] == steps[i+1, j, k]
);
constraint forall(i in 1..n-1, j in 1..n-i+1, k in 0..1)(
  j > choice[i]+1 -> steps[i, j, k] == steps[i+1, j-1, k]
);
constraint forall(i in 1..n-1)(steps[i, choice[i], 0] == steps[i+1, choice[i], 0]);
constraint forall(i in 1..n-1)(steps[i, choice[i]+1, 1] == steps[i+1, choice[i], 1]);

% the total cost
var int: cost;
constraint cost = sum([steps[i, choice[i], 0] * steps[i, choice[i], 1] * steps[i, choice[i] + 1, 1] | i in 1..n-1]);
solve minimize cost;
output([show(cost), " choice at each step: ", show(choice)]);