# Pokemon prolog

Because prolog can be awesome when you have to work with databases.

## Installation

You will need [swipl](http://www.swi-prolog.org/) and [node.js](http://nodejs.org/) (for generating databases). Probably git and bash too.

If you are on linux, you should probably be able to install these tools by using your favorite package manager. On Windows, you will probably have to install them manually (sorry (a)). I strongly advise you to use Cygwin (but [not for node](http://stackoverflow.com/questions/10043177/node-js-cygwin-not-supported)) : it includes the right packages for swipl, git and bash.

Once you have all of this, just go into your home folder then type the following commands :

    $> git clone git@github.com:arcanis/trivia.pokemon-prolog
    $> cd trivia.pokemon-prolog
    $> bin/generate-database
    $> bin/start

You will have access to a new shell in which you will be able to type prolog commands. Pklib and pktools will be already loaded in the environment.

## About Prolog

### Backtracking

One of the key features of prolog is its ability to *backtrack*. It means that it will return every result which could match a predicate, replacing variables by the possible value. For example :

    foo(a).
    foo(b).

Will generate two *facts* named `foo`, which says basically that `foo(a)` is true, and `foo(b)` is true.

Now, if you try this in your terminal :

    ?- foo(X).
    X = a;
    X = b;

You will see that prolog has found two possible results for `X` : `a` or `b`.

It is a very useful feature, and it can be intensively used to iterate over almost any data providen by this library.

## Predicates API

### pkdb

Pkdb is the main data source. It contains everything about the pokeworld.

  - **pkdb:type_atomic(Type)**

    Checks if `Type` is a type. It can also be used to backtrack over every type.

  - **pkdb:type_ratio(Attack, Defense, Result)**

    Computes the ratio of an attack of type `Attack` over a pokemon of type `Defense`.

  - **pkdb:species_atomic(Species)**

    Checks if `Species` is a pokemon species. It can also be used to backtrack over every pokemon species.

  - **pkdb:species_type(Species, Type)**

    Checks if `Species` is of type `Type`. It can also be used to backtrack over every type of a species, or to get the species of a certain type.

  - **pkdb:species_evolution(Species, Evolution)**

    Checks if `Evolution` is the evolution of `Species`. It can also be used to backtrack over every next-stage evolution of a species, or to get the pre-evolution of a species.

  - **pkdb:species_stat(Species, Stat, Value)**

    Returns into `Value` the value of the stat `Stat` of the pokemon `Species`.

  - **pkdb:stat_atomic(Stat)**

    Checks if `Stat` is a valid stat name. It can also be used to backtrack over every stat name.

    The current stats are `hp`, `atk`, `def`, `spa` (spe. atk), `spd` (spe. def) and `spe` (speed).

### pklib

Pklib is a little library which gives you helper functions for some complex requests.

  - **pklib:type_ratio(Attack, Defense, Result)**

    This predicate will compute into `Result` the ratio of an attack of type `Attack` over a pokemon of type `Defense`.

    As opposed to `pkdb:type_ratio/3`, this function accepts lists as parameter (to deal with composite defense type).

    Currently `Defense` cannot have more than two items, and `Attack` a single one.

    **Example**

        ?- pklib:type_ratio(X, [water, flying], Result), Result >= 2.0.
        X = [electric],
        Result = 4.0 ;
        X = [rock],
        Result = 2.0 ;

  - **pklib:species_evolutionary_line_root(Species, Result)**

    This predicate will return into `Result` the base species of the evolutionary line `Species`.

    **Example**

        ?- pklib:species_evolutionary_line_root(ivysaur, X).
        X = bulbasaur.

  - **pklib:species_evolutionary_line(Species, Result)**

    This predicate will return into `Result` the entire evolutionary line of `Species`.

    It also works with branched evolutionary lines.

    **Example**

        ?- pklib:species_evolutionary_line(cascoon, X).
        X = [wurmple, silcoon, beautifly] ;
        X = [wurmple, cascoon, dustox] ;

  - **pklib:species_evolutions(Species, Result)**

    This predicate will return into `Result` the possible evolutions of `Species`.

    It also works with branched evolutionary lines.

    **Example**

        ?- pklib:species_evolutions(wurmple, X).
        X = [silcoon, beautifly] ;
        X = [cascoon, dustox] ;

        ?- pklib:species_evolutions(cascoon, X).
        X = [dustox] ;

  - **pklib:species_total_stats(Species, Result)**

    This predicate will compute into `Result` the sum of all the stats of a species.

    **Example**

        ?- pklib:species_total_stats(Result, 200).
        Result = magikarp ;
        Result = feebas ;

        ?- pklib:species_total_stats(Result, 700).
        Result = kyurem_black ;
        Result = kyurem_white ;

## More examples

Atk stat of all Eevee's evolutions

    ?- pkdb:species_evolution(eevee, Evolution), pkdb:species_stat(Evolution, atk, Atk).

SpAtk stat of every fully evolved fire pokemon

    ?- pkdb:species_atomic(Species), pkdb:species_type(Species, fire), \+ pkdb:species_evolution(Species, _), pkdb:species_stat(Species, spa, SpAtk).

## Future

- Add moar functions to the API. Any idea of what could be useful ? Open an issue !
- Add moves into the database. With their power and precision. Probably some effects too (such as parallizis, burning, etc), but adding more will be hard.
- Write a script to compute an optimal team when battling a specific other team (I never really played 'hardcore', so I will need help of smogon players on this).
- If you have nice examples, open an issue and I will add it in the section (and credit you :).
