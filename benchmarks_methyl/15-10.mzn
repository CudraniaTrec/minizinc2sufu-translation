int: years;
int: invests;
int: f1;
int: f2;
array[1..years, 1..invests] of int: r;
constraint f2 > f1;

% the choice of the ith year
array[1..years] of var 1..invests: choice;

% the number of money at the end of each year
array[0..years] of var int: money;
constraint money[1] == 10000 * r[1, choice[1]];
constraint forall(i in 2..years)(
  if choice[i] == choice[i-1] then
    money[i] == (money[i-1] - f1) * r[i, choice[i]]
  else 
    money[i] == (money[i-1] - f2) * r[i, choice[i]]
  endif
);

solve maximize money[years];
output([show(money[years]), " choices: ", show(choice)]);