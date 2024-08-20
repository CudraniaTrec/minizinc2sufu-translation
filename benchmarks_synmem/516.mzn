int: n=5;  
int: m=3;  
int: k=3;  
  
array[1..n] of int: value1=[0, 1, 2, 3, 4];  
array[1..m] of int: value2=[0, 1, 3];  
  
array[1..k] of var 1..n: pos1;  
array[1..k] of var 1..m: pos2;  
  
constraint forall(i in 1..k-1) (pos1[i] < pos1[i+1]);  
constraint forall(i in 1..k-1) (pos2[i] < pos2[i+1]);  
constraint forall(i in 1..k) (value1[pos1[i]] == value2[pos2[i]]);  
  
solve satisfy;  
  
% Example data  
% n = 3; m = 3; k = 3; value1 = [0, 1, 2]; value2 = [0, 1, 2];