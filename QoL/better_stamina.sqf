/**
	Enhanced Fatigue by Quailsnap (https://github.com/acemod/ACE3/issues/6163#issuecomment-1767485644)
	Found by Rat 

	DESCRIPTION: 
	Increases fatigue recovery per unit.

	HOW TO USE:
	1. Paste the script onto a unit's init field or in the initPlayerLocal.sqf file.
	2. Enjoy!


	NOTES:
	If you add the script to initPlayerLocal.sqf, you will have to remove the if-statement at the start
 */
if (local this) exitWith {
	[{
		ace_advanced_fatigue_ae1reserve = 4000000;
		ace_advanced_fatigue_ae2reserve = 84000;
		ace_advanced_fatigue_muscledamage = 0;
	},
	180,
[]] call CBA_fnc_addPerFrameHandler;

[{
	ace_advanced_fatigue_anfatigue = 0.8;
},
1,
[]] call CBA_fnc_addPerFrameHandler;
};
