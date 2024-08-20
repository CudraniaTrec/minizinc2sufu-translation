int: n=6;

array[1..n+1] of int: value=[7, 1, 5, 6, 3, 4, 0];
array[1..n] of var 0..1: pos;

constraint pos[1] >= 0;

solve maximize
  sum(i in 1..n) (
    pos[i] * (value[i+1] - value[i])
  );
  