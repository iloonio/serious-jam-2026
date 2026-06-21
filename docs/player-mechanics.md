# player mechanics

## Movement
This part is a summary of the [PlayerMovement.gd](assets/scripts/player/PlayerMovement.gd) script, which controls how forces & impulses are applied to the player during gameplay. 

**Forces** are gentle movements which are intended to be applied every physics frame. these can be used to maintain velocity, or add a sliding effect to movement.

**Impulses** are instant bursts of power that are applied to rigidbodies. they are explosive, and should not be applied every single physics frame. For this reason, impulses should be gated behind a cooldown of some sort. 

### Direction Vector (dirVec)
the player has a dirVec which is a unit vector pointing in any direction parallel to the XZ plane. dirVec is used when both forces & impulses are applied to the player.

dirVec is calculated by using _velocity factor_ as its x-value, and the forward vector of the player as its z-value. Since velocity factor can have a much longer length than the forward vector, its value is clamped so as to not influence it too much, which is determined by the `maxTorque` property.

### Torque Factor
Torque is the spin power of a rigidbody. we use torque to rotate the player character when they press Left or Right. Torque Factor is a float in the code of PlayerMovement that also determines the x-position of the direction vector. This means that player movement is a bit curvy in a less predictable way, since torque impacts the player's immediate rotation as well as the orientation of their direction vector.

### Charging & Velocity Factor
When the player holds spacebar, they will briefly slow down while incrementing `chargeGauge`. Letting go of spacebar will send an impulse in the direction of the forward vector based on the chargeGauge's value. If spacebar is released at perfect time, the players velocity factor will gain additional velocity factor. 

### Collisions
Current player controller is a rigidbody3D, with contact monitor enabled so we can check what it is we're colliding with. 

Since the direction vector is constantly applying force to the player in a steerable direction, it means that movement will naturally gravitate towards walls until all velocity factor is consumed. This yields unsatisfying gameplay, so the fix to this is to have the direction vector be reflected off of walls.
