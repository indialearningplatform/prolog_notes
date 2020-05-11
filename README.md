# prolog_notes

Some notes taken while working on Prolog

## The Logic Programming Landscape

![The Logic Programming Landscape](pics/quick_map_of_lp_landscape/quick_map_of_lp_landscape.png)

## A Tradition

![Hiroshige: Shinagawa Station](pics/various/Hiroshige_Shinagawa_Station.jpg)

From [The Fifty-three Stations of the Tōkaidō](https://en.wikipedia.org/wiki/The_Fifty-three_Stations_of_the_T%C5%8Dkaid%C5%8D) by Utagawa Hiroshige, 1832.

## External Resources

- [The first page of the SWI-Prolog manual has a large comment with pointers to resources](https://eu.swi-prolog.org/pldoc/doc_for?object=manual)
- [Extensive list at klaussinani's github account](https://github.com/klaussinani/awesome-prolog#resources)

## Papers of Interest

- 1991-01 [Applying Techniques to Skeletons](https://www.researchgate.net/publication/220986744_Applying_Techniques_to_Skeletons) (Leon Sterling, Marc Kirschenbaum)
- 1995-XX [Higher-order logic programming in Prolog](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.34.9690) (Lee Naish)
- 1991-02 [A type system for logic programs](https://www.sciencedirect.com/science/article/pii/074310669180002U) (Eyal Yardeni, Ehud Shapiro. In: _The Journal of Logic Programming_ Volume 10, Issue 2)
- 1991-XX [Uniform Proofs as a Foundation for Logic Programming](http://www.lix.polytechnique.fr/~dale/papers/apal91.pdf) (Dale Miller, Gopalan Nadathur, Frank Pfenning, Andre Scedrov) --- the Lambda-Prolog way
- 2001-04 [Logic Programming, Functional Programming, and Inductive Definitions](https://www.researchgate.net/publication/1880293_Logic_Programming_Functional_Programming_and_Inductive_Definitions) (Lawrence Paulson, Andrew W. Smith)
- 2003-10 [The Essence of Strategic Programming](https://www.researchgate.net/publication/277289331_The_Essence_of_Strategic_Programming) (Ralf Lämmel, Eelco Visser, Joost Visser) --- generic programming with the use of strategies
- 2009-11 [Coding Guidelines for Prolog](https://arxiv.org/abs/0911.2899) (Michael A. Covington, Roberto Bagnara, Richard A. O'Keefe, Jan Wielemaker, Simon Price)
- 2015-10 [The Inductive Constraint Programming Loop](https://arxiv.org/abs/1510.03317) (
Christian Bessiere, Luc De Raedt, Tias Guns, Lars Kotthoff, Mirco Nanni, Siegfried Nijssen, Barry O'Sullivan, Anastasia Paparrizou, Dino Pedreschi, Helmut Simonis). Appears in modified form in _IEEE Intelligent Systems_, September/October 2017.
- 2017-09 [plspec – A Specification Language for Prolog Data](https://www.krin.gs/publication/koerner-plspec-declare17/koerner-plspec-declare17.pdf) (Philipp Körner, Sebastian Krings, _DECLARE 2017_)
- 2019-09 [Prolog Coding Guidelines: Status and Tool Support](https://arxiv.org/abs/1909.08230v1) (Falco Nogatz, Philipp Körner, Seastuan Krings, ICLP 2019
- 2020-01 [Drawing Prolog Search Trees. A Manual for Teachers and Students of Logic Programming](https://arxiv.org/abs/2001.08133v1) (Johan Bos)

## Packages of Interest

- https://github.com/shonfeder/tokenize - "A modest tokenization library for SWI-Prolog, seeking a balance between simplicity and flexibility."

## Pages in this repository

### Code grabbag

Some predicates which may be of general use can be found in the [Code grabbag](code/README.md)

- [`vector_nth0/3`](code/vector_nth0.pl): Retrieve in a list on multiple positions, by index.
- [`splinter0/5`](code/splinter0.pl): Break a list into three parts based on index.
- [`replace0/5`](code/splinter0.pl): Replace in a list based on index.
- [`rotate_list/3`](code/rotate_list.pl): Rotate a list left or right.
- [`vector_replace0/4`](code/vector_replace0.pl): Replace in a list on multiple positions, by index.

### Notes on Prolog & SWI-Prolog

#### SWI-Prolog's tree of datatypes

- [Tree of Types of SWI-Prolog](swi_prolog_types)
   
#### Naming and graphing

Being often confused by Prolog naming and concepts, my way to name & graphically represent terms

- [Naming and Symbols](naming_and_symbols/)
- ![Naming and Symbols](naming_and_symbols/pics/Symbols.png)

#### Difference List Explainer

An surprisingly large explainer on difference lists (or list differences). With illustrations. Contains code to
compute the length of a difference list.

- [Difference Lists](difflists/)
   
#### Notes on `maplist/N`

Questions on `maplist/N` are recurrent (not only on Stack Overflow), so these page collecte notes & examples:

- [maplist_2_examples.md](maplist/maplist_2_examples.md): Examples and major explainer for [`maplist/2`](https://www.swi-prolog.org/pldoc/man?predicate=maplist%2f2)
- [maplist_3_examples.md](maplist/maplist_3_examples.md): Examples for [`maplist/3`](https://www.swi-prolog.org/pldoc/doc_for?object=maplist/3)
- [maplist_4_examples.md](maplist/maplist_4_examples.md): Examples for [`maplist/4`](https://www.swi-prolog.org/pldoc/doc_for?object=maplist/4)

#### Linear `foldl` and `foldr` in Prolog

- [`foldl` and `foldr`](foldl_foldr/), Explainer and code

#### Various

These are notes on specific subjects taken while working with Prolog in general and SWI-Prolog in particular.

- [Loading a library (the lynx library in this case)](swipl_notes/loading_lynx_library.md)
- [Use of the caret ^ in` bagof/3`, `setof/3`](swipl_notes/notes_on_the_caret_used_in_bagof_goals.md)
- [Predicates for printing & formatting](swipl_notes/output_formatting.md)
- [SWI-Prolog string modes](swipl_notes/swipl_string_modes.md)

