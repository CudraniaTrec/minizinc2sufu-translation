int: n=4;

array[1..n] of int: value=[1,2,3,1];
array[1..n] of var 0..1: pos;

constraint forall(i in 1..n-1) (
  pos[i] == 0 \/  pos[i+1] == 0
);
constraint pos[1] == 0 \/  pos[n] == 0;

solve maximize
  sum(i in 1..n) (
    pos[i] * value[i]
  );
  