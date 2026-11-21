% ============================================================
%  The "Name Game"  -  ARTI 401 Lab Activity
%  Run:   swipl name_game.pl      then type:   ?- start.
%  Note:  every answer you type must end with a full stop (.)
%         e.g.  1.   or   a.
% ============================================================

:- dynamic letters/1.

% The current set of letters is stored as a list.
letters([a,b,c]).

% ---------- Entry point ----------
start :-
    retractall(letters(_)),
    assert(letters([a,b,c])),
    nl,
    write('Hi. This is the "Name Game".'), nl,
    write('You will be given a set of English letters in which you will add, delete or move to create your name.'), nl,
    menu_loop.

% ---------- Menu ----------
menu_loop :-
    nl,
    write('Choose from the following:'), nl,
    write('1- Display the current set of letters'), nl,
    write('2- Add a letter'), nl,
    write('3- Add a letter at the top'), nl,
    write('4- Add a letter at the bottom'), nl,
    write('5- Delete a letter'), nl,
    write('6- Delete all letters'), nl,
    write('7- Exit'), nl,
    write('Enter your choice....'), nl,
    read(Choice),
    (   Choice == 7
    ->  write('Goodbye!'), nl
    ;   ( act(Choice) -> true ; write('Invalid choice, please try again.'), nl ),
        menu_loop
    ).

% ---------- Actions ----------
% 1 - display
act(1) :-
    letters(L),
    show(L).

% 2 - add a letter at a position chosen by the user (this also lets
%     the user "move" a letter: delete it, then add it in a new position)
act(2) :-
    letters(L),
    length(L, N),
    write('Enter the letter to add:'), nl,
    read(X),
    (   valid_letter(X)
    ->  M is N + 1,
        format('Enter the position (1 to ~w):~n', [M]),
        read(P),
        (   integer(P), P >= 1, P =< M
        ->  I is P - 1,
            insert_at(X, I, L, NewL),
            update(NewL),
            show(NewL)
        ;   write('Invalid position.'), nl
        )
    ;   write('Please enter a single English letter.'), nl
    ).

% 3 - add at the top
act(3) :-
    write('Enter the letter to add at the top:'), nl,
    read(X),
    (   valid_letter(X)
    ->  letters(L),
        update([X|L]),
        letters(NewL), show(NewL)
    ;   write('Please enter a single English letter.'), nl
    ).

% 4 - add at the bottom
act(4) :-
    write('Enter the letter to add at the bottom:'), nl,
    read(X),
    (   valid_letter(X)
    ->  letters(L),
        append(L, [X], NewL),
        update(NewL),
        show(NewL)
    ;   write('Please enter a single English letter.'), nl
    ).

% 5 - delete a letter (first occurrence)
act(5) :-
    letters(L),
    (   L == []
    ->  write('The set is empty, nothing to delete.'), nl
    ;   write('Enter the letter to delete:'), nl,
        read(X),
        (   memberchk(X, L)
        ->  select(X, L, NewL),
            update(NewL),
            show(NewL)
        ;   write('That letter is not in the set.'), nl
        )
    ).

% 6 - delete all letters
act(6) :-
    update([]),
    write('All letters deleted.'), nl.

% ---------- Helpers ----------
update(NewL) :-
    retractall(letters(_)),
    assert(letters(NewL)).

valid_letter(X) :-
    atom(X),
    atom_length(X, 1),
    char_type(X, alpha).

insert_at(X, 0, L, [X|L]) :- !.
insert_at(X, I, [H|T], [H|R]) :-
    I1 is I - 1,
    insert_at(X, I1, T, R).

show([]) :-
    write('The set of letters is empty.'), nl.
show(L) :-
    L \== [],
    write('Current letters: '),
    print_letters(L), nl.

print_letters([]).
print_letters([H|T]) :-
    write(H), write(' '),
    print_letters(T).
