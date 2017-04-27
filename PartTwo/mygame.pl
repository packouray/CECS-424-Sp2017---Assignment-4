/* SPIDER -- a sample adventure game, by David Matuszek.
   Consult this file and issue the command:   start.  */

:- dynamic at/2, i_am_at/1, alive/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

/* This defines my current location. */

i_am_at(hut).


/* Path of the game (hut -> Parking -> forest or road -> survivals camp) */

path(hut, n, parking).

path(parking, n, dark_forest) :- at(gun, in_hand).
path(parking, n, dark_forest) :-
        write('The forest might be infested of zombies, you should find and carry on a weapon!'), nl,
        !, fail.

path(parking, s, dark_road).

path(dark_road, n, closed_road).

path(dark_forest, e, survival_camp).


/* object places */

at(hut, gun).
at(dark_forest, zombie).


/* Zombie is alive */

alive(zombie).


/* These rules describe how to pick up an object. */

take(X) :-
        at(X, in_hand),
        write('You''re already holding the gun!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('You are carrying a gun.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.

/* These rules describe how to put down an object. */

drop(X) :-
        at(X, in_hand),
        i_am_at(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* These rules tell how to handle killing the lion and the spider. */

kill :-
        i_am_at(closed_road),
        write('You just felt in a Big hole and died.'), nl,
        !, die.

kill :-
        i_am_at(dark_forest),
        at(gun, in_hand),
        retract(alive(zombie)),
        write('You fired on the zombie until he felt on the floor'), nl,
        write('he seems to be dead.'),
        nl, !.

kill :-
        i_am_at(dark_forest),
        write('You entered in the forest without weapon '), nl,
        write('The zombie bit you and killed you.'), nl,
        !, die.

/* This rule tells how to die. */

die :-
        !, finish.


/* Under UNIX, the   halt.  command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final  halt.  */

finish :-
        nl,
        write('The game is over. Please enter the   halt.   command.'),
        nl, !.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.   -- to go in that direction.'), nl,
        write('take(Object).            -- to pick up an object.'), nl,
        write('drop(Object).            -- to put down an object.'), nl,
        write('kill.                    -- to attack an enemy.'), nl,
        write('look.                    -- to look around you again.'), nl,
        write('instructions.            -- to see this message again.'), nl,
        write('halt.                    -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(survival_camp) :-
        write('Congratulations!!  You arrived to the survivals camp safe'), nl,
        write('and won the game!'), nl,
        finish, !.

describe(hut) :-
        write('You are in an abandonned hut. At [n] there is a parking.'), nl,
        write('your assignment, should you decide to accept it, is to'), nl,
        write('arrive to the survivals camps safe'), nl.

describe(parking) :-
        write('You are on the parking. At [n] there is a dark forest and at [s] a dark road.'), nl,
        write('You better carry a weapon if you decide to enter the dark forest!'), nl.

describe(dark_road) :-
        write('You are now walking on a dark road. At [n] there is a closed road.'), nl,
        write('You better be careful !'), nl.

describe(closed_road) :-
        write('You passed the closed road and felt in a big hole.'), nl.
        die.

describe(dark_forest) :-
        alive(zombie),
        at(gun, in_hand),
        write('The zombie sees you and decide to attack!!!'), nl,
        write('You should use your gun!!!!'), nl.

describe(dark_forest) :-
        alive(spider),
        write('There is a zombie here! but unfortunatelly, you don''t have any weapon !'), nl.
        die.
