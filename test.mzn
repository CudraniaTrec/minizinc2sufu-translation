int: n=6;
int: m=3;

array[1..m] of var 0..n: value;

constraint sum(i in 1..m) (value[i] * value[i]) == n;

solve satisfy;