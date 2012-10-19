pklib_max_type_list_length(2).

pklib_type_ratio(Attack, Defense, Result) :-
    pklib_type_ratio_unroll_attack(Attack, Defense, Result).

pklib_type_ratio_unroll_attack([], _, 1.0).
pklib_type_ratio_unroll_attack([Attack | Tail], Defense, Result) :-
    pkdb_type(Attack),
    pktool_not_member(Attack, Tail),
    pktool_limit_length([Attack | Tail], 2),
    pklib_type_ratio_unroll_defense(Attack, Defense, Temp1),
    pklib_type_ratio_unroll_attack(Tail, Defense, Temp2),
    \+ member(Attack, Tail),
    Result is Temp1 * Temp2.

pklib_type_ratio_unroll_defense(_, [], 1.0).
pklib_type_ratio_unroll_defense(Attack, [Defense | Tail], Result) :-
    pkdb_type(Defense),
    pktool_not_member(Defense, Tail),
    pktool_limit_length([Attack | Tail], 2),
    pklib_max_type_list_length(MaxTypeListLength), length(Tail, TypeListLength), MaxTypeListLength >= TypeListLength,
    pkdb_type_ratio(Attack, Defense, Temp1),
    pklib_type_ratio_unroll_defense(Attack, Tail, Temp2),
    Result is Temp1 * Temp2.

pklib_evolutionary_line_root(Species, Result) :- pkdb_species_evolution(Preevolution, Species), pklib_evolutionary_line_root(Preevolution, Result).
pklib_evolutionary_line_root(Species, Species) :- \+ pkdb_species_evolution(_, Species).

pklib_evolutionary_line(Species, Result) :- pklib_evolutionary_line_root(Species, Root), pklib_evolutions(Root, Evolutions), Result = [Root | Evolutions].

pklib_evolutions(Species, Result) :- pkdb_species_evolution(Species, Evolution), pklib_evolutions(Evolution, Rest), Result = [Evolution | Rest].
pklib_evolutions(Species, []) :- \+ pkdb_species_evolution(Species, _).

pklib_species_total_base_stats(Species, Result) :- pkdb_species(Species, _), findall(Value, pkdb_species_base_stat(Species, _, Value), Stats), pktool_sum_list(Stats, Result).
