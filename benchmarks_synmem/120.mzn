int: n=4;
array[1..n*n] of int: value=[2, 0, 0, 0, 3, 4, 0, 0, 6, 5, 7, 0, 4, 1, 8, 3];
array[1..n] of var 1..n: pos;

constraint pos[1] == 1;

constraint forall(i in 2..n) (
    pos[i] >= pos[i - 1] /\ pos[i]<=pos[i-1]+1
);

solve maximize sum(i in 1..n) (-value[(i-1)*n + pos[i]]);
