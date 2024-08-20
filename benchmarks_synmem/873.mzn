int: n=8;  
int: m=5;  
array[1..n] of int: value=[1, 2, 3, 4, 5, 6, 7, 8];  
array[1..m] of var 1..n: pos;  
  
constraint forall(i in 1..m-1) (  
  pos[i] < pos[i+1]  
);  
  
constraint forall(i in 1..m-2) (  
  value[pos[i]] + value[pos[i+1]] = value[pos[i+2]]  
);  
  
solve satisfy;  
  
% Example data
% n = 7;  
% m = 3;  
% value = [1, 3, 7, 11, 12, 14, 18];