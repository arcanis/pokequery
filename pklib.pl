pklib_foldList(Result, _, [], Result).
pklib_foldList(Start, Callable, [Head | Tail], Result) :- call(Callable, Start, Head, Temp), pklib_foldList(Temp, Callable, Tail, Result).

pklib_plus(A, B, Result) :- Result is A + B.
pklib_sumList(List, Result) :- pklib_foldList(0, pklib_plus, List, Result).

pklib_product(A, B, Result) :- Result is A * B.
pklib_productList(List, Result) :- pklib_foldList(1, pklib_plus, List, Result).

pklib_ratio([], _, 1).
pklib_ratio(_, [], 1).
pklib_ratio([Attack | Tail], Defense, Result) :- pklib_ratio(Attack, Defense, Temp1), pklib_ratio(Tail, Defense, Temp2), Result is Temp1 * Temp2.
pklib_ratio(Attack, [Defense | Tail], Result) :- pklib_ratio(Attack, Defense, Temp1), pklib_ratio(Attack, Tail, Temp2), Result is Temp1 * Temp2.
pklib_ratio(Attack, Defense, Result) :- ratio(Attack, Defense, Result).
