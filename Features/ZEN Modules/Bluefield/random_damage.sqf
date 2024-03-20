/**
  Author: Bluefield
  Description: Randomly damages a vehicle except the engine which is limited to 0.9 to avoid explosions.
  Requires: ZEN (Zeus Enhanced)
  
  Usage:
	1. Place in init.sqf
	2. Use in Zeus Enhanced (Modules, under Bluefield)
*/
["Bluefield", "Random Damage Car", {
	params ["_position", "_obj"];

	private _damageArray = getAllHitPointsDamage _obj;
	_damageArray = _damageArray select 0;

	{
		if (_x in ["hitengine", "hithull", "hitengine2"]) then {
			_obj setHitPointDamage [_x, random [0, 0, 0.9]];
		} else {
			_obj setHitPointDamage [_x, random 1];
		};
	} forEach _damageArray;
}] call zen_custom_modules_fnc_register;
