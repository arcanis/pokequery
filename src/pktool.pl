pktool_sum_list([], 0).
pktool_sum_list([Head | Tail], Count) :- pktool_sum_list(Tail, Temp), Count is Head + Temp.
