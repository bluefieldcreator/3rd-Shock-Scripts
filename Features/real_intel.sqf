/**
	BASIC INTEL SCRIPT
	By: Bluefield

	Description:
	This script is a basic example of how to create an intel object in Arma 3. This script will create an intel object that can be picked up and added to the player's diary. The intel will have a title, contents, and an image. The image will be displayed in the diary when the intel is added. The intel will also have a faction, which will determine who can pick it up and add it to their diary.

	HOW TO USE:
	1. Copy and paste the code into the init field of a game object in the editor.
	2. Change the values of the variables to suit your needs.
	3. Preview the mission and pick up the intel to add it to your diary.

	NOTES:
	- The image file must be in the mission folder.
	- The image file must be a .paa file.
 */

private _intelTitle = ""; // The title of the intel. This will be displayed in the diary.
private _intelContents = ""; // The contents of the intel. This can be a string or an array of strings. If it is an array, each element will be a separate paragraph in the intel.
private _imagePath = ""; // Path to the image file in your mission folder. Example: "myImages\myImage.paa"
private _faction = west; // guerrila, west, east, civilian, independent

[ this ] call BIS_fnc_initIntelObject;
this setVariable ["RscAttributeDiaryRecord_texture", _imagePath, true];
[this, "RscAttributeDiaryRecord", [_intelTitle, _intelContents, ""] ] call BIS_fnc_setServerVariable;
this setVariable ["RscAttributeOwners", [_faction], true];
this setVariable ["recipients", _faction, true];
