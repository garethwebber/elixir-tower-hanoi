# Elixir: Towers of Hanoi

An implementation of Towers of Hanoi written in Elixir. I wrote it as when
I was learning about found this version https://github.com/wouterken/towers-of-hanoi-elixir, I didn't like it. 

Why? The definition of a plate, pole and board felt very object-oriented even if they are only used for printing. I wanted to switch my mind to data and 
functions so I designed it this way.

Obviously having written this as a critique of structure - feel free to comment on what I have done. All greatfully accepted.

## Building

To run, first get dependencies, ```mix deps.get```.  

Build with ```mix compile```.

If you want to run the tests, ```mix test```.

If you want documents, run ```mix docs``` and point your browser at documents
directory.

## Running GenServer

To start run ```iex -S mix```.

```
Interactive Elixir (1.16.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> {:ok, pid} = Hanoi.TowerState.start_link(%{"name" => "hello"})
{:ok, #PID<0.186.0>}
iex(2)> Hanoi.TowerState.get_state(pid)
%Hanoi.Board{left: [1, 2, 3], centre: [], right: []}
iex(3)> Hanoi.TowerState.move_stone(pid, :left, :centre)
:ok
iex(4)> Hanoi.TowerState.move_stone(pid, :left, :right)
:ok
iex(5)> Hanoi.TowerState.get_state(pid)
%Hanoi.Board{left: [3], centre: [1], right: [2]}
```

## Running from command line

Build the executable with ```mix escript.build```.

To run then call ```./tower_hanoi <stones>``` being careful not to set the
number too high (20 takes 20 odd seconds and each extra doubles it).

### Results

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
