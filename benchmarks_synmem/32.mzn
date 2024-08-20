int: n=3;
array[1..n] of int: value=[1, 1, -1];

array[1..n] of var 0..1: prefix;
array[1..n] of var 0..1: suffix;
array[1..n] of var 0..1: choose;

constraint forall(i in 1..n-1)(prefix[i+1] == 0 \/ prefix[i] == 1);
constraint forall(i in 1..n-1)(suffix[i] == 0 \/ suffix[i+1] == 1);
constraint forall(i in 1..n)(suffix[i] == 0 \/ prefix[i] == 0 \/ choose[i] == 1);
constraint forall(i in 1..n)(sum(j in 1..i)(choose[j]*value[j]) >= 0);


solve maximize sum(i in 1..n)(choose[i]);