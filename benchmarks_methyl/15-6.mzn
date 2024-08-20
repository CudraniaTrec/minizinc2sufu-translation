int: n;
array[1..n] of 0..n: left_child;
array[1..n] of 0..n: right_sibling;
array[1..n] of int: rating;

% check for a valid left-child right-sibling representation
constraint forall(i in 1..n)(
  left_child[i] > i \/ left_child[i] == 0
);
constraint forall(i in 1..n)(
  right_sibling[i] > i \/ right_sibling[i] == 0
);

function int: ref_count(int: node) =
  count(i in 1..n)(left_child[i] == node) +
  count(i in 1..n)(right_sibling[i] == node);
  
constraint ref_count(1) == 0;
constraint forall(i in 2..n)(ref_count(i)==1);

% whether the ith employee is invited
array[1..n] of var bool: invited;

% whether any empolyee in the right-sibling chain is invited
predicate sibling_invited(int: node) =
  if node == 0 then false else (invited[node] \/ sibling_invited(right_sibling[node])) endif;

constraint forall(i in 1..n)(invited[i] -> not sibling_invited(left_child[i]));

% total rating 
var int: tot;
constraint tot = sum([if invited[i] then rating[i] else 0 endif | i in 1.. n]);

solve maximize tot;
output [show(tot), " invited: ", show(invited)]