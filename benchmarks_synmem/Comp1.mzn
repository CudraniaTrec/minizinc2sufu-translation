int: n=3;  
int: capacity=2;  
array[1..n] of int: weight=[0,1,3];  
array[1..n] of var 0..1: choose;  
  
constraint  
  sum(i in 1..n) (weight[i] * choose[i]) = capacity;  
  
solve satisfy;  

  
% 另一组示例数据（可按需取消注释进行测试）  
% n = 3;  
% capacity = 8;  
% weight = [0, 1, 3];  
  
% 再一组示例数据（可按需取消注释进行测试）  
% n = 5;  
% capacity = 8;  
% weight = [1, 2, 1, 3, 4];