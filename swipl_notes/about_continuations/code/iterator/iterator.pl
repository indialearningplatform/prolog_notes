% =============================================================================
% "Coroutines" using Delimited Continuations
% =============================================================================
% Code inspired by:
%
%  "Delimited Continuations for Prolog" (2013)
%  Tom Schrijvers, Bart Demoen, Benoit Desouter, Jan Wielemaker
%  https://www.swi-prolog.org/download/publications/iclp2013.pdf
%  (the "iterator coroutine" example is on page 4)
% =============================================================================

% ~~~~~~
% At page 4 of the cited paper, we read [text below has been adapted]:
%
% Coroutines that suspend in order to output data are called "iterators".
% They use the "yield" keyword (in SWI-Prolog this calls the shift/1 predicate)
% in order to suspend & return a next value to their context-providing
% "master coroutine"
%
% In a sense yield/1 called by the iterator coroutine generalizes Prolog's
% write/1 built-in: the iterator coroutine runs in a context that consumes
% its output in a _user-defined_ way.
% ~~~~~~~

% ===
% The "master coroutine": It writes the values yielded by "Goal" to stdout.
% ===

with_write(Goal) :-
  reset(Goal,Loot,Cont),       % "Loot" is the term yieled by the "iterator", should be "yield(X)".
  tag_cont(Cont,TaggedCont),   % This just tags the continuation term "Cont".
  branch(TaggedCont,Loot).     % This will result in success or a tail-recursive call.

branch(zero,_).                % Successful "end of loop" because "Goal" succeeded.

branch(cont(Cont),yield(X)) :-
   write(X),write('.'),        % Iterator yielded X; do something with it.
   with_write(Cont).           % Tail-recursive call into a new context where Cont is the new Goal.

% ===
% Tag the continuation "Cont" for easy pattern-directed branching.
% "zero" vs. "cont(_)" is better to make a branching descision than
% "0" vs "some unknown structure that can be used as a goal"
% ===

tag_cont(0,zero) :- !.
tag_cont(Cont,cont(Cont)).

% ===
% Two example "iterators"
% ===

% ---
% yield/1 is just a shift/1 of the "yield term" carrying the value that
% that shall be communicated to the master coroutine.
% ---

yield(X) :- shift(yield(X)).

% ---
% An "iterator" that consist in a predicate yielding values from a list.
%
% 1) "cut* in order to make sure that the system knows it can reclaim the
%    stack space during a possibly infinite iteration.
% 2) "yield" the head element of the list. This calls shift/1 and thus passes
%    control to the master coroutine with predicate with_write/1. It knows how
%    to actually output that element. Control flow continues as if it was
%    returning from the call to reset/3.
% 3) After return to to this iterator (i.e. after the matser predicate called
%    reset/3 with the appropriate continuation), whereby control flow continues
%    as if it was returning from shift/1, perform a recursive call to set a new
%    context to continue with the tail of the list.
% ---

from_list([X|Xs]) :-
   !,           % the cut is not really needed because only one clause ever matches
   yield(X),
   from_list(Xs).

from_list([]).

% ---
% An "iterator" that consist in a predicate that yields the values [L..U-1],L>=0
% ---

from_interval(L,U) :-
   L<U,
   !,          % if you don't cut you WILL get "ERROR: Stack limit exceeded" for large intervals
   yield(L),
   succ(L,Lp),
   from_interval(Lp,U).

from_interval(X,X).

% ===
% Run it
% ===

run(interval) :-
   with_write(from_interval(0,100)).

run(list) :-
   with_write(from_list([a,b,c,d,e,f])).
