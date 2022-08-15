ThePhantomReplay
Version 1

# TUTORIAL

## MODULE ID - 10605326798

Create a folder in workspace, called "ThePhantomReplay"

require the module
```lua
local ThePhantomReplay = require(10605326798)
```

from there, register all the parts you want to be recorded.
```lua
ThePhantomReplay.Register(part1)
ThePhantomReplay.Register(part2)
```

and then, start recording!
```lua
ThePhantomReplay.Record("TEST") -- don't forget to name your replay! (i'll use the name test for now)
```

after you're done recording, call the stop function. this will save your replay to the system cashe.

```lua
ThePhantomReplay.Stop(); 
```

when you want to watch your replay, call the Replay function, using the name of your replay as a pramater

```lua
ThePhantomReplay.Replay("TEST")
```

this will start replaying all the movements of your objects!

BE SURE TO CREATE CONNECTIONS FOR THESE EVENTS (they can be found by referencing ThePhantomReplay.Events)

```
STEP
FRAME_STEP
ON_RECORD
ON_STOP
ON_REPLAY
ON_REPLAY_STOP
```
