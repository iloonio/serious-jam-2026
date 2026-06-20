# player mechanics

## Movement
The player should be able to hold a button to charge up their movement. 

### Bezier Curves
player movement direction is given by a quadratic bezier curve.
- Movement is handled by having p1 extend outwards when player holds the forward button.
- turning is handled by having the handle for p1 move along the x axis (-x for turning left, +x for turning right)
- player character moves along that path ig? its a bit unclear to me right now, but i currently imagine that it will attempt to move the body along that curve.

The player can steer the bezier curve's endpoint's handlepoint (simply called, `b1` from here on out) by using left & right input (by default this is mapped to A and D respectively). the endpoint (`p1` from here on out) will lerp towards `b1` over time, allowing them to turn in a direction!


when a player turns with A or D, `b1` is shifted in some direction. after that, the player character will rotate while `b1` lerps towards (0,0,0).


b0 also needs to be lerped towards the general direction of p1, so we can use a normalized version of it so that it doesnt go absolutely insane.


now that we have that system setup, how do we keep going from here?
- now its time to rotate the player character themselves. we do this towards p1 iff player forward vector dot product is not equal to 0.001
