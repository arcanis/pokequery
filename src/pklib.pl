:- use_module(library(clpq)).

pklib_type_ratio(Attack, Defense, Result) :-
    pklib_type_ratio_unroll_attack(Attack, Defense, Result).

pklib_type_ratio_unroll_attack([], _, 1.0).
pklib_type_ratio_unroll_attack([Attack | Tail], Defense, Result) :-
    pkdb_type(Attack),
    pktool_not_member(Attack, Tail),
    pktool_limit_length([Attack | Tail], 2),
    pklib_type_ratio_unroll_defense(Attack, Defense, Temp1),
    pklib_type_ratio_unroll_attack(Tail, Defense, Temp2),
    Result is Temp1 * Temp2.

pklib_type_ratio_unroll_defense(_, [], 1.0).
pklib_type_ratio_unroll_defense(Attack, [Defense | Tail], Result) :-
    pkdb_type(Defense),
    pktool_not_member(Defense, Tail),
    pktool_limit_length([Attack | Tail], 2),
    pkdb_type_ratio(Attack, Defense, Temp1),
    pklib_type_ratio_unroll_defense(Attack, Tail, Temp2),
    Result is Temp1 * Temp2.

pklib_evolutionary_line_root(Species, Result) :-
    ( pkdb_species_evolution(Preevolution, Species)
    -> pklib_evolutionary_line_root(Preevolution, Result)
     ; Result = Species).

pklib_evolutionary_line(Species, [ Root | Evolutions ]) :-
    pklib_evolutionary_line_root(Species, Root),
    pklib_evolutions(Root, Evolutions).

pklib_evolutions(Species, Result) :-
    ( pkdb_species_evolution(Species, Evolution)
    -> Result = [Evolution | PostEvolutions], pklib_evolutions(Evolution, PostEvolutions)
     ; Result = [] ).

pklib_species_total_base_stats(Species, Result) :-
    pkdb_species(Species, _),
    findall(Value, pkdb_species_base_stat(Species, _, Value), Stats),
    pktool_sum_list(Stats, Result).
