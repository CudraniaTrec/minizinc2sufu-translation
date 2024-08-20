int: n=5;  
int: m=3;  
array[1..n] of int: fir=[1, 5, 2, 3, 4];  
array[1..n] of int: sec=[5, 4, 1, 2, 3];  
  
array[1..m] of var 1..n: pos;  
  
constraint forall(i in 1..m-1) (pos[i] < pos[i+1]);  
constraint forall(i in 1..m-1) (sec[pos[i]] < fir[pos[i+1]]);  
  
solve satisfy;  
  
% Example data  
% n = 3; m = 2; fir = [1, 2, 3]; sec = [2, 3, 4];  
% n = 5; m = 2; fir = [1, 5, 2, 3, 4]; sec = [5, 4, 1, 2, 3];  