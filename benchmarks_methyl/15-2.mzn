int: N;
array[1..N] of int: s;
var 1..N: len;
array[1..N] of var 1..N: pos;

% a valid subsequence
constraint pos[1] >= 1;
constraint pos[len] <= N;
constraint forall(i in 2..len)(pos[i] > pos[i - 1]); 
% palindrome
constraint forall(i in 1..len)(s[pos[i]] == s[pos[len - i + 1]]);

solve maximize len;

%output
output [show(len), " subsequence: ", show(pos)]