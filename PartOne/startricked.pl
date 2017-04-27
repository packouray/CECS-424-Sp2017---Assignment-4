person(barrada).
person(gort).
person(klatu).
person(nikto).

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

relative(balloon).
relative(clothesline).
relative(frisbee).
relative(water_tower).

solve :-
    person(Ms_Barrada), person(Ms_Gort), person(Mr_Klatu), person(Mr_Nikto),
    all_different([Ms_Barrada, Ms_Gort, Mr_Klatu, Mr_Nikto]),

    relative(BarradaRelative), relative(GortRelative),
    relative(KlatuRelative), relative(NiktoRelative),
    all_different([BarradaRelative, GortRelative, KlatuRelative, NiktoRelative]),

    Triples = [ [Ms_Barrada, BarradaRelative, tuesday],
                [Ms_Gort, GortRelative, wednesday],
                [Mr_Klatu, KlatuRelative, thursday],
                [Mr_Nikto, NiktoRelative, friday] ],

    \+ member([klatu, balloon, _], Triples),
    \+ member([klatu, frisbee, _], Triples),
    \+ member([gort, frisbee, _], Triples),
    earlier([klatu, _, _], [_, balloon, _], Triples),
    earlier([_, frisbee, _], [klatu, _, _], Triples),
    (member([barrada, _, friday], Triples);
    member([_, clothesline, friday], Triples)),
    \+ member([nikto, _, tuesday], Triples),
    \+ member([klatu, water_tower, _], Triples),


    tell(Ms_Barrada, BarradaRelative, tuesday),
    tell(Ms_Gort, GortRelative, wednesday),
    tell(Mr_Klatu, KlatuRelative, thursday),
    tell(Mr_Nikto, NiktoRelative, friday).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

earlier(X, _, [X | _]).
earlier(_, Y, [Y | _]) :- !, fail.
earlier(X, Y, [_ | T]) :- earlier(X, Y, T).

tell(X, Y, Z) :-
    write(X), write(' think that he saw a '), write(Y),
    write(' on '), write(Z), write('.'), nl.
