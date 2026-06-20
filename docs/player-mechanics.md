# player mechanics

### Bezier Curves
player movement direction is given by a quadratic bezier curve.
- Movement is handled by having p1 extend outwards when player holds the forward button.
- turning is handled by having the handle for p1 move along the x axis (-x for turning left, +x for turning right)
- player character moves along that path ig? its a bit unclear to me right now, but i currently imagine that it will attempt to move the body along that curve.
