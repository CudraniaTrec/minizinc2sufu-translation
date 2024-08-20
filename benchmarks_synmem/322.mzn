int: n=3;  
int: capacity=8;  
array[1..n] of int: weight=[0, 1, 3];  
array[1..n] of var 0..1: choose;  
  
constraint  
  sum(i in 1..n) (weight[i] * choose[i]) = capacity;  
  
solve satisfy;  
