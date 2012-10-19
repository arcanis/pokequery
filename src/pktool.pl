pktool_sum_list([], 0).
pktool_sum_list([Head | Tail], Count) :- pktool_sum_list(Tail, Temp), Count is Head + Temp.

pktool_not_member(Element, List) :-
    freeze(List, pktool_not_member_iteration(Element, List)).
pktool_not_member_iteration(_, []).
pktool_not_member_iteration(Element, [Head|Tail]) :-
    dif(Element, Head),
    pktool_not_member(Element, Tail).

pktool_limit_length(List, Length) :-
    freeze(List, pktool_limit_length_iteration(List, Length)).
pktool_limit_length_iteration([], Length) :-
    Length >= 0.
pktool_limit_length_iteration([_ | Tail], Length) :-
    Length > 0,
    NextIteration is Length - 1,
    pktool_limit_length(Tail, NextIteration).
