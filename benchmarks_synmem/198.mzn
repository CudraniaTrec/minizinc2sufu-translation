int: n=5;


array[1..n] of int: weight=[2, 7, 9, 3, 1];
array[1..n] of var 0..1: pos;

constraint forall(i in 1..n) (
  (pos[i] == 0) \/ (pos[i+1] == 0)
);

solve maximize
  sum(i in 1..n) (
    pos[i] * weight[i]
  );