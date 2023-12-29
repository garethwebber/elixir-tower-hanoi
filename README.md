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
19:00:37.870 [info] State:
L 1 2 3
C
R
19:00:37.871 [info] State:
L 2 3
C
R 1
19:00:37.871 [info] State:
L 3
C 2
R 1
19:00:37.871 [info] State:
L 3
C 1 2
R
19:00:37.871 [info] State:
L
C 1 2
R 3
19:00:37.871 [info] State:
L 1
C 2
R 3
19:00:37.871 [info] State:
L 1
C
R 2 3
19:00:37.871 [info] State:
L
C
R 1 2 3
```
