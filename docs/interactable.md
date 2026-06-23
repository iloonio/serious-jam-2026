# interactables
interactables are prefabs with nodes which have a script that inherits from the [interactable.gd](assets/scripts/interactables/Interactable.gd). All interactables must implement the abstract method:
```gd
@abstract func on_interact()
```
which handles what will happen to an object when a player interacts with it. 

Interactable prefab structure should looks roughly like this:
- Node (root of interactable prefab)
  - A script attached to root that fetches parent of Node

## Moving Component
The Moving component is a Node with [Moving.gd](assets/scripts/interactables/Moving.gd) inside of it. It must be parented to a rigidbody3D, and that rigidbody will be set to `kinematic`. the node tree of the component should look like this:
- `Node` 
  - `Path3D`
    - `PathFollow3D`
      - `RemoteTransform3D`

The RemoteTransform will move the parent along the Path3D
