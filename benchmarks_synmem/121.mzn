int: n=5;

array[1..n+1] of int: value=[1, 2, 3, 0, 2, 0];
array[1..n] of var 0..1: possess;


constraint possess[1] == 0;
constraint forall(i in 2..n) (
  (possess[i] == 1) \/ (possess[i-1] == 0) \/ (possess[i+1] == 0) 
);

solve maximize
  sum(i in 1..n) (
    (possess[i] * (value[i+1] - value[i]))
  );

