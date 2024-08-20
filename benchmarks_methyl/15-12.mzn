int: n;
int: p;
int: X;
array[1..p] of 1..n: pos;
array[1..p] of int: cost;
array[1..p] of int: war;

% whetehr to sign a player
array[1..p] of var bool: is_signed;

% the total cost should not be larger than X
constraint X >= sum([if is_signed[i] then cost[i] else 0 endif | i in 1..p]);

% All signed players should be at different positions
constraint forall(i in 1..p, j in 1..p)(
  (i != j /\ is_signed[i] /\ is_signed[j]) -> pos[i] != pos[j]
);

% Maximize the total war
var int: tot;
constraint tot == sum([if is_signed[i] then war[i] else 0 endif | i in 1..p]);
solve maximize tot;
output ([show(tot), " is signed: ", show(is_signed)]);