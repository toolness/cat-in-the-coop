**Cat in the Coop** is a game about finding your lost cat in the Cooper Hewitt Smithsonian Design Museum.

[It can be played on the web.](https://toolness.github.io/cat-in-the-coop/)

## History

This was originally Atul's repository for working through the [Godot FPS tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/fps_tutorial/index.html), but then Atul and Erik repurposed it for working on a Global Game Jam 2020 game.

Having zero experience with Godot, this thing is kind of a mess, but we learned a lot!  Yay.

## Quick start

This game was created with Godot 3.2.3 and Blender 2.91.0.

The deployment scripts were created with Node v14, though it's likely that other versions will work fine too.

To deploy the game to GitHub pages, run `npm run deploy`.

If you change materials in Blender, or the `import_cooper_hewitt.gd` script (which modifies materials upon import), note that you may need to uncheck the "Materials -> Keep on Reimport" checkbox in the Godot import settings in order for the new changes to take. Be sure to re-check this checbkox before you save, though.

## Credits

This is a game by T-Sub Squiggle.

T-Sub is Erik Christensen.

Squiggle is Atul Varma.

Some of the code, especially the first-person movement code, is from the Godot FPS tutorial.

The cat is from [cat Rigged](https://sketchfab.com/3d-models/cat-rigged-eccebebd5a60484eaa49036f8a4b6ed7) by 
Vr-cvantorium.

The Cooper Hewitt level is from [Smithsonian 3d Digitization](https://3d.si.edu/explore/museum/cooper-hewitt?edan_local=&edan_q=Carnegie%2BMansion&). Specifically, we used the medium resolution 3D mesh.

All music is ©2020 [Joshua McLean](https://joshua-mclean.itch.io), licensed under Creative Commons Attribution 4.0 International.

The font used is Titillium-Regular, and is licensed under the SIL Open Font License, Version 1.1.