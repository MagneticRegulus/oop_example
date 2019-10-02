# Approach

The classical approach to object oriented programming is:

1. Write a textual description of the problem or exercise.
2. Extract the major nouns and verbs from the description.
3. Organize and associate the verbs with the nouns.
4. The nouns are the classes and the verbs are the behaviors or methods.

---

## Description

Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

## Extraction

Nouns: player, move, rule
Verbs: choose, compare

**Note:** 'Rock', 'Paper', and 'Scissors' are all variations (or instances) on
a move, hence why they are ignored in extraction.

## Organization

Player
- choose
Move
Rule


- compare

**Note:** Where should the 'compare' behavior go?

---

## Orchestration Engine

The procedural program flow should be in an engine which can orchestrate the
objects.

`RPSGame.new.play` is an easy interface to start the program. The engine,
therefore, is a class with a method to initialize the game.

---

## Notes on 3rd iteration

> Is this design, with Human and Computer sub-classes, better? Why, or why not?

I believe this design is better. Firstly, rather than using `if this...then that`
thinking in the design, the code explicitly states what type of player is being
initialized. This ultimately creates more legible code.

> What is the primary improvement of this new design?

Again, I think is about legibility. Before these changes, there was quite a lot
of logic in one space which was difficult to read. Now there's a clear distinction
between the two player types which can be seen at a high level, without needing
to look too closely at the code.

> What is the primary drawback of this new design?

As stated above, all the logic relating to the name-setting and move choice
was in the same place. While it was not legible, once you found where the logic
was, you did not need to search any further. Now we need to look at two different
places.

---

## Notes on 4th iteration

> What is the primary improvement of this new design?

As per the 3rd iteration, I believe this version provides even better legibility
in the code. Up until this point, I had been thinking how wonderful it would be
to simply compare the 2 moves as this would make more logical sense from a
visual perspective. Now there is much less repitition (huge bug-bear for me) and
and the code "reads well".

> What is the primary drawback of this new design?

Again, this pull lots of logic from one place and destributes it differently.
Okay, so now we know that the moves are comparable, but how so? What beats what?
First, you will probably search for this logic in the `Player` class and its
subclasses. Then you will realize that `move` is it's own logic elsewhere.

There are also now quite a lot of methods floating around in the `Move` class.
While they are all used, it take much more reading to figure out where so.
