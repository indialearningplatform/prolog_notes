:- use_module('trivials.pl').
:- use_module('entityname.pl').
:- use_module('orig_jpl.pl').

:- use_module(library('heavycarbon/support/fold_support.pl')).


:- include(library('heavycarbon/support/meta_helpers_nonmodular.pl')).

recognize_atom_to_atom(In,Rest,DcgGoal,Out) :- 
   assertion(nonvar(In)),
   var(Out), % Out not yet set; transfer it back to caller in the end
   !,
   atom_codes(In,InCodes),
   compound_name_arguments(DcgGoalCompleted,DcgGoal,[Out]), % will fill Out with atom
   phrase(DcgGoalCompleted,InCodes,RestCodes),
   atom_codes(Rest,RestCodes), % this instantiates or unifies/compares
   assertion(atom(Out)).
 
recognize_atom_to_atom(In,Rest,DcgGoal,Out) :- 
   assertion(nonvar(In)),
   nonvar(Out), % Out already set; pass it to recognizer goal for checking 
   assertion(atom(Out)),
   !,
   atom_codes(In,InCodes),
   compound_name_arguments(DcgGoalCompleted,DcgGoal,[Out]), % will consult Out
   phrase(DcgGoalCompleted,InCodes,RestCodes),   
   atom_codes(Rest,RestCodes). % this instantiates or unifies/compares

recognize_atom_to_compound(In,Rest,DcgGoal,Out) :- 
   assertion(nonvar(In)),
   var(Out), % Out not yet set; transfer it back to caller in the end
   !,
   atom_codes(In,InCodes),
   compound_name_arguments(DcgGoalCompleted,DcgGoal,[Out]), % will fill Out with atom
   phrase(DcgGoalCompleted,InCodes,RestCodes),
   atom_codes(Rest,RestCodes). % this instantiates or unifies/compares
 
recognize_atom_to_compound(In,Rest,DcgGoal,Out) :- 
   assertion(nonvar(In)),
   nonvar(Out), % Out already set; pass OutCodes to recognizing goal
   !,
   atom_codes(In,InCodes),
   compound_name_arguments(DcgGoalCompleted,DcgGoal,[Out]), % will consult Out
   phrase(DcgGoalCompleted,InCodes,RestCodes),   
   atom_codes(Rest,RestCodes). % this instantiates or unifies/compares




% ---------

% :- debug(identifier_chars).

:- begin_tests(identifier_chars).

% create a list of true/false atoms, one for each position of the input list
% of character codes

maplist_java_id_start_char(ListIn,ListOut) :-
   maplist([C,T]>>reify(jpl_java_identifier_start_char(C),T),ListIn,ListOut).

maplist_java_id_part_char(ListIn,ListOut) :-
   maplist([C,T]>>reify(jpl_java_identifier_part_char(C),T),ListIn,ListOut).

test("identifier start chars") :- 
   maplist_java_id_start_char(`$abcdefghijklöüä`,R),
   debug(identifier_chars,"Result: ~q",[R]),
   all_true(R).

test("identifier nonstart chars") :- 
   maplist_java_id_start_char(`.0123456789`,R),
   debug(identifier_chars,"Result: ~q",[R]),
   all_false(R).

test("identifier part chars") :- 
   maplist_java_id_part_char(`_0123456789$abcdefghijklöüä`,R),
   debug(identifier_chars,"Result: ~q",[R]),
   all_true(R).

:- end_tests(identifier_chars).

% ---------

% :- debug(java_identifier).

:- begin_tests(java_identifier).

test("recognize Java identifier (unconstrained Out), no rest",true([Out,Rest] == [my_identifier,''])) :- 
   recognize_atom_to_atom('my_identifier',Rest,jpl_java_identifier,Out),
   debug(java_identifier,"Recognized: ~q with rest: ~q",[Out,Rest]).

test("recognize Java identifier (unconstrained Out), with rest",true([Out,Rest] == [my_identifier,'.dodododo'])) :- 
   recognize_atom_to_atom('my_identifier.dodododo',Rest,jpl_java_identifier,Out),
   debug(java_identifier,"Recognized: ~q with rest: ~q",[Out,Rest]).

test("recognize Java identifier of length 1, no rest",true([Out,Rest] == [m,''])) :- 
   recognize_atom_to_atom('m',Rest,jpl_java_identifier,Out).

test("recognize Java identifier (Out already set to result), no rest",true(Rest == '')) :- 
   recognize_atom_to_atom('my_identifier',Rest,jpl_java_identifier,'my_identifier').

test("recognize Java identifier (Out already set to result), with rest",true(Rest == '.dodododo')) :- 
   recognize_atom_to_atom('my_identifier.dodododo',Rest,jpl_java_identifier,'my_identifier').

test("not a Java identifier",fail) :- 
   recognize_atom_to_atom('-my',_,jpl_java_identifier,_).

test("empty atom is not a Java identifier",fail) :- 
   recognize_atom_to_atom('',_,jpl_java_identifier,_).

test("valid identifier with differing Out",fail) :- 
   recognize_atom_to_atom('my',_,jpl_java_identifier,'notmy').

:- end_tests(java_identifier).

% --------

:- begin_tests(java_type_identifier).

test("recognize Java type identifier",true([Out,Rest] == [my_identifier,''])) :- 
   recognize_atom_to_atom('my_identifier',Rest,jpl_java_type_identifier,Out).

test("reject bad Java type identifier 'var'",fail) :-
   recognize_atom_to_atom('var',_,jpl_java_type_identifier,_).

test("java type identifier DOES NOT stop at '$'",true([Out,Rest] == ['foo$bar',''])) :-
   recognize_atom_to_atom('foo$bar',Rest,jpl_java_type_identifier,Out).

:- end_tests(java_type_identifier).

% -------

:- begin_tests(jpl_typeterm_entityname).

test("entityname is just 'int': integer primitive",true(Out == primitive(int))) :-
   recognize_atom_to_compound('int','',jpl_typeterm_entityname,Out).

test("entityname is just 'void': void primitive",true(Out == primitive(void))) :-
   recognize_atom_to_compound('void','',jpl_typeterm_entityname,Out).

test("entityname is actually 'integer', which is a class called 'integer', which is ok!",true(Out == class([],[integer]))) :-
   recognize_atom_to_compound('integer','',jpl_typeterm_entityname,Out).

:- end_tests(jpl_typeterm_entityname).

% ------

:- begin_tests(messy_dollar_split).

test(1,true(Runs == [alfa])) :-
   messy_dollar_split(alfa,Runs).

test(2,true(Runs == [a])) :-
   messy_dollar_split(a,Runs).

test(3,true(Runs == ['$'])) :-
   messy_dollar_split('$',Runs).

test(4,true(Runs == ['alfa$'])) :-
   messy_dollar_split('alfa$',Runs).

test(5,true(Runs == [alfa,bravo])) :-
   messy_dollar_split('alfa$bravo',Runs).

test(6,true(Runs == ['$alfa'])) :-
   messy_dollar_split('$alfa',Runs).

test(7,true(Runs == ['alfa','$bravo'])) :-
   messy_dollar_split('alfa$$bravo',Runs).

test(8,true(Runs == ['$alfa','bravo','charlie$'])) :-
   messy_dollar_split('$alfa$bravo$charlie$',Runs).

test(9,true(Runs == ['$$alfa','$bravo','$$charlie','$$$'])) :-
   messy_dollar_split('$$alfa$$bravo$$$charlie$$$$',Runs).

:- end_tests(messy_dollar_split).

% ------

:- begin_tests(jpl_binary_classname_without_dollar).

test("simple classname",true(Out == class([],[foo]))) :-
   recognize_atom_to_compound('foo','',jpl_tt_en_binary_classname,Out).

test("qualified classname",true(Out == class([alfa,bravo,charlie],[foo]))) :-
   recognize_atom_to_compound('alfa.bravo.charlie.foo','',jpl_tt_en_binary_classname,Out).

:- end_tests(jpl_binary_classname_without_dollar).

% ------

% Note that "splitting at a dollar is ill-defined and pointless and
% should eventually disappear

:- begin_tests(jpl_binary_classname_with_dollar).

test("qualified inner member type",true(Out == class([alfa,bravo,charlie],[foo,bar]))) :-
   recognize_atom_to_compound('alfa.bravo.charlie.foo$bar','',jpl_tt_en_binary_classname,Out).

test("qualified inner anonymous type",true(Out == class([alfa,bravo,charlie],[foo,'01234']))) :-
   recognize_atom_to_compound('alfa.bravo.charlie.foo$01234','',jpl_tt_en_binary_classname,Out).

test("qualified inner local class",true(Out == class([alfa,bravo,charlie],[foo,'01234bar']))) :-
   recognize_atom_to_compound('alfa.bravo.charlie.foo$01234bar','',jpl_tt_en_binary_classname,Out).

test("qualified inner member type, deep",true(Out == class([alfa,bravo,charlie],[foo,bar,baz,quux]))) :-
   recognize_atom_to_compound('alfa.bravo.charlie.foo$bar$baz$quux','',jpl_tt_en_binary_classname,Out).

:- end_tests(jpl_binary_classname_with_dollar).

% ------

:- begin_tests(jpl_entity_is_array).

test("array of double",true(Out == array(primitive(double)))) :-
   recognize_atom_to_compound('[D','',jpl_typeterm_entityname,Out).

test("array of array of integer",true(Out == array(array(primitive(int))))) :-
   recognize_atom_to_compound('[[I','',jpl_typeterm_entityname,Out).

test("array of void",fail) :-
   recognize_atom_to_compound('[[V','',jpl_typeterm_entityname,_).

test("array of java.lang.String",true(Out == array(array(class([java, lang], ['String']))))) :-
   recognize_atom_to_compound('[[Ljava.lang.String;','',jpl_typeterm_entityname,Out).

:- end_tests(jpl_entity_is_array).

% -----

% :- debug(java_identifier).


deprimitive(primitive(X),X) :- !.

deprimitive(X,X) :- 
   atomic(X),!.

deprimitive(X,Y) :- 
   compound(X), 
   compound_name_arguments(X,N,Args), 
   maplist([I,O]>>deprimitive(I,O),Args,ArgsNew), 
   compound_name_arguments(Y,N,ArgsNew).

run_both(X,OutNew,OutOld) :- 
   reify(recognize_atom_to_compound(X,'',jpl_typeterm_entityname, StructNew),SuccessNew),
   reify(recognize_atom_to_compound(X,'',jpl_type_classname_1,    StructOld),SuccessOld),
   if_then((SuccessNew == true),(deprimitive(StructNew,StructNewDP))),
   outcome(SuccessNew,StructNewDP,OutNew),
   outcome(SuccessOld,StructOld,OutOld),
   if_then_else(
      call(SuccessNew),
      (debug(cmp_old_new,"~q : New   : ~q",[X,StructNew]),
       debug(cmp_old_new,"~q : NewDP : ~q",[X,StructNewDP])),
      (debug(cmp_old_new,"~q : New failed",[X]))),
   if_then_else(
      call(SuccessOld),
      (debug(cmp_old_new,"~q : Old   : ~q",[X,StructOld])),
      (debug(cmp_old_new,"~q : Old failed",[X]))).

outcome(true,Struct,success(Struct)).
outcome(false,_,    failure).

:- debug(cmp_old_new).

:- begin_tests(comparing_old_and_new).

test("comparing 1" ,[blocked("Old response makes no sense"),true(OutNew == OutOld)]) :- run_both('int',OutNew,OutOld).    % Old: class([],[int])   ???
test("comparing 2" ,[blocked("Old response makes no sense"),true(OutNew == OutOld)]) :- run_both('float',OutNew,OutOld).  % Old: class([],[float]) ???
test("comparing 3" ,[blocked("Old response makes no sense"),true(OutNew == OutOld)]) :- run_both('void',OutNew,OutOld).   % Old: class([],[void])  ???
test("comparing 4" ,true(OutNew == OutOld)) :- run_both('java.lang.Integer',OutNew,OutOld).
test("comparing 5" ,true(OutNew == OutOld)) :- run_both('integer',OutNew,OutOld). % The class called "integer"

test("comparing 6" ,true(OutNew == OutOld)) :- run_both('[D',OutNew,OutOld).
test("comparing 7" ,true(OutNew == OutOld)) :- run_both('[[[[[I',OutNew,OutOld).
test("comparing 8" ,true(OutNew == OutOld)) :- run_both('[[J',OutNew,OutOld).
test("comparing 9" ,true(OutNew == OutOld)) :- run_both('[[Ljava.lang.String;',OutNew,OutOld).
test("comparing 10",true(OutNew == OutOld)) :- run_both('java.lang.String',OutNew,OutOld).
test("comparing 11",true(OutNew == OutOld)) :- run_both('Foo',OutNew,OutOld).
test("comparing 12",true(OutNew == OutOld)) :- run_both('foo.bar.baz.Foo',OutNew,OutOld).
test("comparing 13",true(OutNew == OutOld)) :- run_both('foo.bar.baz.Foo$Quux',OutNew,OutOld).

test("comparing 14") :- run_both('foo.bar.baz.Foo$',success(OutNew),success(OutOld)),
                        OutNew == class([foo,bar,baz],['Foo$']), 
                        OutOld == class([foo,bar,baz],['Foo','']). % WRONG

test("comparing 15") :- run_both('foo.bar.baz.$Foo',success(OutNew),failure), % OLD FAILS
                        OutNew == class([foo,bar,baz],['$Foo']).

:- end_tests(comparing_old_and_new).



