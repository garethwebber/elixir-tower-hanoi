# How to Run 

To run, first get dependencies, ```mix deps.get```.  

Build with ```mix compile```.

If you want to run the tests, ```mix test```.

If you want documents, run ```mix docs``` and point your browser at documents
directory.

## Running in web-server

Run ```iex -S mix phx.server``` and then point your web-browser at http://localhost:4000

## Running GenServer

To start run ```iex -S mix```.

```
Interactive Elixir (1.16.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Hanoi.TowerGame.start_link(%{name: :hello, stones: 3})
{:ok, #PID<0.186.0>}
iex(2)> Hanoi.TowerGame.get_board_state(:hello)
%Hanoi.Board{left: [1, 2, 3], centre: [], right: []}
iex(3)> Hanoi.TowerGame.get_moves(:hello)
[
  left: :right,
  left: :centre,
  right: :centre,
  left: :right,
  centre: :left,
  centre: :right,
  left: :right
]
iex(4)> Hanoi.TowerGame.move_stone(:hello, :left, :centre)
:ok
iex(5)> Hanoi.TowerGame.move_stone(:hello, :left, :right)
:ok
iex(6)> Hanoi.TowerGame.get_board_state(:hello)
%Hanoi.Board{left: [3], centre: [1], right: [2]}
```

## Running from command line

Build the executable with ```mix escript.build```.

To run then call ```./hanoi <stones>``` being careful not to set the
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

## References

[1] https://github.com/wouterken/towers-of-hanoi-elixir
