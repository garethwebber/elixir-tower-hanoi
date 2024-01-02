# Elixir: Towers of Hanoi

An implementation of Towers of Hanoi written in Elixir. I wrote it as when
I was learning about found this version https://github.com/wouterken/towers-of-hanoi-elixir, I didn't like it. 

Why? The definition of a plate, pole and board felt very object-oriented even if they are only used for printing. I wanted to switch my mind to data and 
functions so I designed it this way.

Obviously having written this as a critique of structure - feel free to comment on what I have done. All greatfully accepted.

## Running

To run, first get dependencies, ```mix deps.get```.  

Build the executable with ```mix escript.build```.

If you want to run the tests, ```mix test```.

If you want documents, run ```mix docs``` and point your browser at documents
directory.

To run then call ```./tower_hanoi <stones>``` being careful not to set the
number too high (20 takes 20 odd seconds and each extra doubles it).

## Results

Example results

```
Tower of Hanoi

L 3 2 1
C
R

L 3 2
C
R 1

L 3
C 2
R 1

L 3
C 2 1
R

L
C 2 1
R 3

L 1
C 2
R 3

L 1
C
R 3 2

L
C
R 3 2 1

3 stones took 2 millisecond(s).
```
