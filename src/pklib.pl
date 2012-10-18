pklib_type_ratio([Attack | []], [Defense | []], Result) :-
    pkdb_type_ratio(Attack, Defense, Result).
pklib_type_ratio([Attack | Tail], Defense, Result) :- pkdb_type(Attack),
    pklib_type_ratio(Attack, Defense, Temp1),
    pklib_type_ratio(Tail, Defense, Temp2),
    \+ member(Attack, Tail),
    Result is Temp1 * Temp2.
pklib_type_ratio(Attack, [Defense | Tail], Result) :- pkdb_type(Defense),
    pklib_type_ratio(Attack, Defense, Temp1),
    pklib_type_ratio(Attack, Tail, Temp2),
    \+ member(Defense, Tail),
    Result is Temp1 * Temp2.

pklib_type_interactions(Types, X0_00, X0_25, X0_50, X1_00, X2_00, X4_00) :-
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 0.00), X0_00),
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 0.25), X0_25),
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 0.50), X0_50),
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 1.00), X1_00),
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 2.00), X2_00),
    findall(pkdb_type(Type), pklib_type_ratio(Types, Type, 4.00), X4_00).

pklib_evolutionary_line_root(Species, Result) :- pkdb_species_evolution(Preevolution, Species), pklib_evolutionary_line_root(Preevolution, Result).
pklib_evolutionary_line_root(Species, Species) :- \+ pkdb_species_evolution(_, Species).

pklib_evolutionary_line(Species, Result) :- pklib_evolutionary_line_root(Species, Root), pklib_evolutions(Root, Evolutions), Result = [Root | Evolutions].

pklib_evolutions(Species, Result) :- pkdb_species_evolution(Species, Evolution), pklib_evolutions(Evolution, Rest), Result = [Evolution | Rest].
pklib_evolutions(Species, []) :- \+ pkdb_species_evolution(Species, _).

pklib_species_total_base_stats(Species, Result) :- pkdb_species(Species, _), findall(Value, pkdb_species_base_stat(Species, _, Value), Stats), pktool_sum_list(Stats, Result).
