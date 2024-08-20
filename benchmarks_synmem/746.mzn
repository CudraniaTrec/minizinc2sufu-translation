int: n=10;  
array[1..n+1] of int: value=[0, 1, 100, 1, 1, 1, 100, 1, 1, 100, 1];  
array[1..n+1] of var 0..1: pos;  
  
constraint pos[1] == 1;  
constraint pos[n+1] == 1;  
constraint forall(i in 1..n-1) (  
  pos[i] == 0 \/ pos[i+1] == 1 \/ pos[i+2] == 1  
);  
  
solve maximize sum(i in 1..n+1) (-pos[i] * value[i]);  
  
% Example data  
% n = 3; value = [0, 10, 15, 20];  