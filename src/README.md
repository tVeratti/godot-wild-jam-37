# godot_scene_swap_plugin
Helps you change your scene gracefully!

# How to use:
1. Just download this repo (or get it from asset_lib)
2. Activate plugin
3. Use singleton "scene_manager" to load your scene like:
      `scene_manager.change_scene_to("res://demo/large_scene.tscn")`

Check the results.

# How it works:
1.  "change_scene_to" is called;
2.  Fade out (from loading_scene) is called;
3.  Once anim is finished (notified from signal animation_finished);
4.  Background thread is invoked;
2.  Current scene is released;
3.  New scene is loaded
4.  Progress is updated
5.  Once load is finished
6.  New scene is added to node three
7.  Once scene is ready (signal three_entered has been invoked), fade_in is called
6.  After fade_in is finished, loading_scene is hidden;
7.  Background thread is paused

# Creating new transitions:
1. Change/copy the included scene 'loading_scene.tscn';
2. Create/change your animations;
3. Keep emiting the signal animation_finished (with names fade_in or fade_out);
4. Keep the methods fade_in and fade_out (plugin call these);
4. Create/change the progress bar;

**So far, only one loading scene is used, then, if you want to show more than one, changes on scene_transition_manager.gd is required**
