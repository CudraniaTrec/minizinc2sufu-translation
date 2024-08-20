include "globals.mzn";

int: n=5;
int: m=2;
array[1..n] of int: value=[1, 3, 2, 5, 4];
array[1..m] of var 1..n: pos;

constraint strictly_increasing(pos);
constraint strictly_increasing([value[pos[i]] | i in 1..m]);

solve satisfy;