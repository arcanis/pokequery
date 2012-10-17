pklib_ratio([], _, 1).
pklib_ratio(_, [], 1).
pklib_ratio([Attack | Tail], Defense, Result) :- pklib_ratio(Attack, Defense, Temp1), pklib_ratio(Tail, Defense, Temp2), Result is Temp1 * Temp2.
pklib_ratio(Attack, [Defense | Tail], Result) :- pklib_ratio(Attack, Defense, Temp1), pklib_ratio(Attack, Tail, Temp2), Result is Temp1 * Temp2.
pklib_ratio(Attack, Defense, Result) :- ratio(Attack, Defense, Result).

pklib_evolutionary_line_root(Species, Result) :- pkdb_evolution(Preevolution, Species), pklib_evolutionary_line_root(Preevolution, Result).
pklib_evolutionary_line_root(Species, Species) :- \+ pkdb_evolution(_, Species), !.

pklib_evolutionary_line(Species, Result) :- pklib_evolutionary_line_root(Species, Root), pklib_evolutions(Root, Evolutions), Result = [Root | Evolutions].

pklib_evolutions(Species, Result) :- pkdb_evolution(Species, Evolution), pklib_evolutions(Evolution, Rest), Result = [Evolution | Rest].
pklib_evolutions(Species, []) :- \+ pkdb_evolution(Species, _).
