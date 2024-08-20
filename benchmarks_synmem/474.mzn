int: n=5;  
int: capacity1=5;  
int: capacity2=3;  
array[1..n] of int: weight1=[1, 3, 2, 0, 1];  
array[1..n] of int: weight2=[1, 1, 4, 1, 0];  
  
array[1..n] of var 0..1: choose;  
  
constraint  
  sum(i in 1..n) (weight1[i] * choose[i]) = capacity1;  
  
constraint  
  sum(i in 1..n) (weight2[i] * choose[i]) = capacity2;  
  
solve satisfy;  
  