int: n=7;  
int: m=6;  
array[1..n] of int: value=[1, 2, 3, 3, 3, 4, 5];  
array[1..m] of int: value2=[1, 2, 3, 3, 4, 5];  
array[1..m] of var 1..n: pos;  
  
constraint  
  forall(i in 1..m-1) (pos[i] < pos[i+1]);  
  
constraint  
  forall(i in 1..m) (value[pos[i]] == value2[i]);  
  
solve satisfy;  
  
% Example data
% n = 7; m = 3; value = [1, 2, 1, 3, 1, 2, 3]; value2 = [1, 2, 3];