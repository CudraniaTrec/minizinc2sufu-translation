int: n=5;  
int: m=3;  
array[1..n] of int: value=[1, 5, 2, 3, 4];  
array[1..m] of var 1..n: pos;  
  
constraint  
  forall(i in 1..m-1) (pos[i] < pos[i+1]);  
  
constraint  
  forall(i in 1..m-1) (value[pos[i]] < value[pos[i+1]]);  
  
solve satisfy;  
  
% Example data  
% n = 5; m = 2; value = [1, 3, 2, 5, 4];  
% n = 5; m = 3; value = [1, 3, 2, 5, 4];