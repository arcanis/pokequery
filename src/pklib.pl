:- module(pklib, [
    type_ratio/3,
    species_evolutionary_line_root/2,
    species_evolutionary_line/2,
    species_evolutions/2,
    species_total_stats/2
]).

:- use_module(library(clpq)).

:- use_module(src/pkdb, []).

type_ratio(Attack, Defense, Result) :-
    type_ratio_unroll_attack(Attack, Defense, Result).

type_ratio_unroll_attack([], _, 1.0).
type_ratio_unroll_attack([Attack | Tail], Defense, Result) :-
    pkdb:type_atomic(Attack),
    pktool:not_member(Attack, Tail),
    pktool:limit_length([Attack | Tail], 1),
    type_ratio_unroll_defense(Attack, Defense, Temp1),
    type_ratio_unroll_attack(Tail, Defense, Temp2),
    Result is Temp1 * Temp2.

type_ratio_unroll_defense(_, [], 1.0).
type_ratio_unroll_defense(Attack, [Defense | Tail], Result) :-
    pkdb:type_atomic(Defense),
    pktool:not_member(Defense, Tail),
    pktool:limit_length([Attack | Tail], 2),
    pkdb:type_ratio(Attack, Defense, Temp1),
    type_ratio_unroll_defense(Attack, Tail, Temp2),
    Result is Temp1 * Temp2.

species_evolutionary_line_root(Species, Result) :-
    pkdb:species_atomic(Species),
    ( pkdb:species_evolution(Preevolution, Species)
    -> species_evolutionary_line_root(Preevolution, Result)
     ; Result = Species).

species_evolutionary_line(Species, [ Root | Evolutions ]) :-
    species_evolutionary_line_root(Species, Root),
    species_evolutions(Root, Evolutions).

species_evolutions(Species, Result) :-
    pkdb:species_atomic(Species),
    pkdb:species_evolution(Species, Evolution),
    species_evolutions(Evolution, PostEvolution),
    Result = [Evolution | PostEvolution].

species_evolutions(Species, Result) :-
    pkdb:species_atomic(Species),
    \+ pkdb:species_evolution(Species, _),
    Result = [].

species_total_stats(Species, Result) :-
    pkdb:species_atomic(Species),
    findall(Value, pkdb:species_stat(Species, _, Value), Stats),
    pktool:sum_list(Stats, Result).
