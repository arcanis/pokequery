pklib_type_ratio([], _, 1).
pklib_type_ratio(_, [], 1).
pklib_type_ratio([Attack | Tail], Defense, Result) :- pklib_type_ratio(Attack, Defense, Temp1), pklib_type_ratio(Tail, Defense, Temp2), Result is Temp1 * Temp2.
pklib_type_ratio(Attack, [Defense | Tail], Result) :- pklib_type_ratio(Attack, Defense, Temp1), pklib_type_ratio(Attack, Tail, Temp2), Result is Temp1 * Temp2.
pklib_type_ratio(Attack, Defense, Result) :- pkdb_type_ratio(Attack, Defense, Result).

pklib_evolutionary_line_root(Species, Result) :- pkdb_species_evolution(Preevolution, Species), pklib_evolutionary_line_root(Preevolution, Result).
pklib_evolutionary_line_root(Species, Species) :- \+ pkdb_species_evolution(_, Species), !.

pklib_evolutionary_line(Species, Result) :- pklib_evolutionary_line_root(Species, Root), pklib_evolutions(Root, Evolutions), Result = [Root | Evolutions].

pklib_evolutions(Species, Result) :- pkdb_species_evolution(Species, Evolution), pklib_evolutions(Evolution, Rest), Result = [Evolution | Rest].
pklib_evolutions(Species, []) :- \+ pkdb_species_evolution(Species, _).

pklib_species_total_base_stats(Species, Result) :- pkdb_species(Species, _), findall(Value, pkdb_species_base_stat(Species, _, Value), Stats), pktool_sum_list(Stats, Result).
