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
19:06:48.419 [info] State:
L 3 2 1
C
R
19:06:48.419 [info] State:
L 3 2
C
R 1
19:06:48.419 [info] State:
L 3
C 2
R 1
19:06:48.419 [info] State:
L 3
C 2 1
R
19:06:48.419 [info] State:
L
C 2 1
R 3
19:06:48.419 [info] State:
L 1
C 2
R 3
19:06:48.419 [info] State:
L 1
C
R 3 2
19:06:48.419 [info] State:
L
C
R 3 2 1
```
