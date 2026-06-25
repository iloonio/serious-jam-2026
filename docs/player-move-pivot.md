# Player move with Pivot

This version of the player move uses a Pivot point, which is a 3D point in space. Its distance to the player is used
as a Vector3 for the purpose of applying forces. 

### Signals
`IsSpinning` is a signal that sends a boolean flag along with a float to notify that the player is indeed spinning. Spinning is a condition that is achieved when the Pivot point has a great enough magnitude. The float it sends over will always fall in the range of (0.5, 4). 

`(deprecated) LinearVelocity` is a signal that sends over a float with the player's current LinearVelocity. This was used by the trail effects before, but it actually has no reason to exist. Therefore, it is marked as deprecated

`Charging` is emitted when the player is charging. This sends over the current charge gauge, as well as the min and max threshold values.

`ChargeRelease` is emitted when the player releases charge. It sends over a boolean which says whether the Charge was perfectly timed or not.
