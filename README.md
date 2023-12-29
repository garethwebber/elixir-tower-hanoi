# TowerHanoi

To run 
get dependencies ```mix deps.get```. This is currently just the file logger 
which shows the moves to hanoi.log.

Build the executeiable with ```mix escript.build```.

To run then call ```./tower_hanoi <stones>``` being careful not to set the
number too high (20 takes 20 odd seconds and each extra doubles it).

To see the results

```
cat hanoi.log    
18:38:52.969 [info] State: %Hanoi.Board{left: [1, 2, 3], centre: [], right: []}
18:38:52.973 [info] Moving 1 from  left -> right
18:38:52.973 [info] State: %Hanoi.Board{left: [2, 3], centre: [], right: [1]}
18:38:52.973 [info] Moving 2 from  left -> centre
18:38:52.973 [info] State: %Hanoi.Board{left: [3], centre: [2], right: [1]}
18:38:52.973 [info] Moving 1 from  right -> centre
18:38:52.973 [info] State: %Hanoi.Board{left: [3], centre: [1, 2], right: []}
18:38:52.973 [info] Moving 3 from  left -> right
18:38:52.973 [info] State: %Hanoi.Board{left: [], centre: [1, 2], right: [3]}
18:38:52.973 [info] Moving 1 from  centre -> left
18:38:52.973 [info] State: %Hanoi.Board{left: [1], centre: [2], right: [3]}
18:38:52.973 [info] Moving 2 from  centre -> right
18:38:52.973 [info] State: %Hanoi.Board{left: [1], centre: [], right: [2, 3]}
18:38:52.973 [info] Moving 1 from  left -> right
18:38:52.973 [info] State: %Hanoi.Board{left: [], centre: [], right: [1, 2, 3]}
```
