int: n;
array[1..n] of int: value;

% the number of slices and each length
var 1..n: num;
array[1..n] of var 1..n: len;

% total length should be n
constraint n == sum([len[i] | i in 1..num]);

% maximize the total value 
var int: tot;
constraint tot == sum([value[len[i]] | i in 1..num]);
solve maximize tot;
output([show(tot), " ", show(num), " slices: ", show(len)]);