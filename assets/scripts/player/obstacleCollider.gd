## obstacleCollider.gd is a generic class that requires its parent to be area3D.
## It fetches overlapping bodies in its parent, checks if they have the neccesary
## class, and then it runs its on_collision function, which lets the collided object
## manage its own state.
extends Area3D

func _physics_process(_delta: float) -> void:
	if get_overlapping_bodies().size() == 0:
		return

	## highly volatile loop, we'll see if it works.
	## we check to see if the colliding object is a parent of
	## a component, if it is, we remove it, because nobody else
	## should be a parent of that component.

	## get interactable components, then look through the


	var components = get_tree().get_nodes_in_group("interactableComponents") # this seems to be failing us...
	await get_tree().process_frame
	for col in get_overlapping_bodies():
		for componentNode in components:
			if col.is_ancestor_of(componentNode):
				componentNode.call("on_interact")
				components.remove_at(components.find(componentNode))
