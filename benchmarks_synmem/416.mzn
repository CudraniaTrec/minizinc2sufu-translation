int: n=5;  
int: capacity=6;  
array[1..n] of int: weight=[1, 2, 1, 3, 4];  
  
array[1..n] of var 0..1: choose;  
  
constraint  
  sum(i in 1..n) (weight[i] * choose[i]) = capacity;  
  
solve satisfy;  
  
% Example data  
% n = 3; capacity = 2; weight = [0, 1, 3];