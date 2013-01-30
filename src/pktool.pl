:- module(pktool, [
    sum_list/2,
    not_member/2,
    limit_length/2
]).

sum_list([], 0).
sum_list([Head | Tail], Count) :-
    pktool:sum_list(Tail, Temp),
    Count is Head + Temp.

not_member(Element, List) :-
    freeze(List, pktool:not_member_iteration(Element, List)).
not_member_iteration(_, []).
not_member_iteration(Element, [Head|Tail]) :-
    dif(Element, Head),
    pktool:not_member(Element, Tail).

limit_length(List, Length) :-
    freeze(List, pktool:limit_length_iteration(List, Length)).
limit_length_iteration([], Length) :-
    Length >= 0.
limit_length_iteration([_ | Tail], Length) :-
    Length > 0,
    NextIteration is Length - 1,
    pktool:limit_length(Tail, NextIteration).
