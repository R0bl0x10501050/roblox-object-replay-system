ThePhantomReplay
Version 1

# DOCUMENTATION

## Functions
### function] Register([Instance] Object) -> returns nil
Adds an object to the replay that will be recorded, before it's recorded. IT WILL ONLY TAKE INSTANCES.
  
### [function] Unregister([Instance] Object) -> returns nil
Removes an object from the replay that will be recorded, before it's recorded. IT WILL ONLY TAKE INSTANCES.
  
### [function] Record([string] Name) -> returns nil
Starts recording every movement of the registered objects. Requires a name to be provided for the replay.

### [function] Stop(nil) -> returns nil
Stops recording, and saves the frames of each registered object to the system cashe.
  
### [function] Replay([string] Name) -> returns nil
Replays the replay selected by its Name.

## Events
### [BindableEvent] ON_REPLAY([string] Name)
Fires once a replay starts playing. Provides the Name of the replay currently being played.
  
### [BindableEvent] ON_STOP([string] Name)
Fires once recording of a replay has stopped. Provides the Name of the reply that was recorded.

### [BindableEvent] FRAME_STEP([number] Frame)
Fires while replaying once a new frame has been rendered. Provides which frame of the replay you are currently on.
  
### [BindableEvent] STEP([number] ElapsedTime)
Fires while recording the ElapsedTime of the current replay.

### [BindableEvent] ON_REPLAY_STOP([string] Name)
Fires once a replay has finished replaying. Provides the Name of the replay that finished replaying.
