friend(grizzly_bear).
friend(moose).
friend(seal).
friend(zebra).

child(joanne).
child(lou).
child(ralph).
child(winnie).

relative(circus).
relative(rock_band).
relative(spaceship).
relative(train).

solve :-
    friend(JoanneFriend), friend(LouFriend), friend(RalphFriend), friend(WinnieFriend),
    all_different([JoanneFriend, LouFriend, RalphFriend, WinnieFriend]),

    relative(JoanneRelative), relative(LouRelative),
    relative(RalphRelative), relative(WinnieRelative),
    all_different([JoanneRelative, LouRelative, RalphRelative, WinnieRelative]),

    Triples = [ [joanne, JoanneFriend, JoanneRelative],
                [lou, LouFriend, LouRelative],
                [ralph, RalphFriend, RalphRelative],
                [winnie, WinnieFriend, WinnieRelative] ],


    \+ member([_, seal, spaceship], Triples),
    \+ member([_, seal, train], Triples),
    \+ member([joanne, seal, _], Triples),
    \+ member([lou, seal, _], Triples),
    \+ member([joanne, grizzly_bear, _], Triples),
    member([joanne, _, circus], Triples),
    \+ member([_, grizzly_bear, circus], Triples),
    member([winnie, zebra, _], Triples),

    tell(joanne, JoanneFriend, JoanneRelative),
    tell(lou, LouFriend, LouRelative),
    tell(ralph, RalphFriend, RalphRelative),
    tell(winnie, WinnieFriend, WinnieRelative).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write(X), write(' and his/her imaginary friend '), write(Y),
    write(' did the adventure  '), write(Z), write('.'), nl.
