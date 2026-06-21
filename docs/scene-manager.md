# SceneManager


## Structure
The components that contribute to the functionality of the Scenemanager consist of:
- SceneManager.gd (Global class)
- GameScene.tscn (and GameScene.gd)
- RunnableScene.gd


### SceneManager.gd (Global class)
Handles the actual scene switching!

The functions that can be used to load scenes are:
- load_scene(newScenePath: String), which loads a specified scene (Must inherit class RunnableScene)
- reload_scene(), which simply reloads the current scene 


### GameScene.tscn (and GameScene.gd)
This node should always be on top of the game hierarchy.
It handles the fade in/out animation for the scene transitions, and emits signals to
SceneManager.gd when the scene has faded in/out, to switch scenes.

To be clear, "fade_out" is when the screen fades out (fade to black screen).

The Node3D "CurrentScene" is always parented to the scene that you want to run in the game.
This is ensured to be the case for direct debug runs too, thanks to RunnableScene.bootstrap_into_game()

It is important to keep the names and node structure "SubViewportContainer/SubViewport/CurrentScene"
intact, as it is used to find "CurrentScene" in both SceneManager.gd and RunnableScene.gd


### RunnableScene.gd
Any scene that you want to run should have this script attatched! (or inherit it)

An important function it has is:
- bootstrap_into_game(), ensures that the current scene becomes a the child of GameScene, 
so debug runs emulate the node structure of a proprely running game.
