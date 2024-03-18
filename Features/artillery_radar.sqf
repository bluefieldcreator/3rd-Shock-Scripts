/*
	ARTILLERY RADAR SCRIPT
	MADE BY THE ONLY ONE, BLUEFIELD
	(Then optomised, localised, CBA'd, and adjusted by your local rodent, Rat)

	THIS SCRIPT IS A PART OF THE "ARTILLERY RADAR" SYSTEM, WHICH IS A SYSTEM THAT DETECTS INCOMING ARTILLERY PROJECTILES AND ALERTS THE LEADERSHIP OF EACH GROUP PER PLAYER. KEEP IN MIND THIS IS INTENDED FOR PVE, YOUR OWN ARTILLERY WILL TRIGGER THIS IN PVP IF BOTH SIDES GET THE RADAR.

	HOW TO USE;
	1. PLACE SCRIPT INSIDE MISSION FOLDER
	2. PLACE THIS CODE INSIDE THE ARTILLERY UNIT YOU WANT TO TRACK;
	'''
	this execVM "artillery.sqf"
	'''
	OR PLACE THE SCRIPT ONTO CFGFUNCTIONS & LOAD IN THE INIT FIELD AS 
	```
	this call functionNameGivenInCfgFunctions;
	``` 
*/
params ["_unit"];

if (!local _unit) exitWith {};

_unit setVariable ["ArtyRadar_alertedPlayers", false, true];

_unit addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	// Preps message to be sent
	private _posGrid = mapGridPosition _unit;
	private _message = format ["Artillery Radar Alert<br />Incoming artillery detected. Seek Shelter!<br />ORIGIN GRID SQUARE: %1", _posGrid];

	// We alert anyone with a radio, usually this is leadership. Reasonably it's anyone who could get the info.
	if (!(_unit getVariable "ArtyRadar_alertedPlayers")) then {
		_unit setVariable ["ArtyRadar_alertedPlayers", true, true];
		// Check if TFAR loaded
		if (isClass(configFile >> "CfgPatches" >> "tfar_core")) then {
			{
				// Check if TFAR radio on player
				private _hasRadio = [_x] call TFAR_fnc_hasRadio;
				if (_hasRadio) then {
					[_x, ["Diary", ["Artillery Radar Alert", _message]]] remoteExec ["createDiaryRecord", _x];
					"INCOMING!\nARTY DATA SENT TO YOUR BRIEFING!" remoteExec ["hint", _x, false];
				} else {
					// Check if TFAR compatible vehicle radio
					_hasRadio = (vehicle _x) call TFAR_fnc_hasVehicleRadio;
					if (_hasRadio) then {
						[_x, ["Diary", ["Artillery Radar Alert", _message]]] remoteExec ["createDiaryRecord", _x];
						"INCOMING!\nARTY DATA SENT TO YOUR BRIEFING!" remoteExec ["hint", _x, false];
					};
				};
			} forEach allPlayers;
		} else {
			// Check for vanilla radio
			{
				if (_x getSlotItemName 611 != "") then {
					[_x, ["Diary", ["Artillery Radar Alert", _message]]] remoteExec ["createDiaryRecord", _x];
					"INCOMING!\nARTY DATA SENT TO YOUR BRIEFING!" remoteExec ["hint", _x];
				};
			} forEach allPlayers;
		};
	};

	// Unique IDs for markers based on projectile
	private _projName = str _projectile;
	private _markerHeight = format ["%1_height", _projName];
	private _markerStr = format ["%1_string", _projName];
	
	// PROJECTILE MARKER
	_markerH = createMarkerLocal [_markerHeight, _projectile];
	_markerH setMarkerShapeLocal "ICON";
	_markerH setMarkertypeLocal "loc_LetterV";
	_markerH setMarkerSizeLocal [1, 1];
	_markerH setMarkerDir (getDir _projectile + 180);

	private _markerstr = createMarkerLocal [_markerStr, _unit];
	_markerstr setMarkerShapeLocal "ELLIPSE";
	_markerstr setMarkerColorLocal "ColorRed";
	_markerstr setMarkerSizeLocal [30, 30];
	_markerstr setMarkertext "Enemy Artillery";

	// PFH to handle marker colour changes, position changes, text changes
	private _timeStart = time;
	private _handle = [{
		params ["_args", "_idPFH"];
		_args params ["_markerH","_timeStart", "_projectile"];
		
		private _timeOfFlight = round ((time - _timeStart) * 100)/100;
		private _pos = getPosATL _projectile;
		_markerH setMarkerPosLocal _projectile;

		switch (true) do {
			case (_pos select 2 > 1000): {
				_markerH setMarkerColorLocal "ColorGreen";
			};
			case (_pos select 2 > 500 && _pos select 2 < 1000): {
				_markerH setMarkerColorLocal "ColorYellow";
			};
			case (_pos select 2 > 150 && _pos select 2 < 500): {
				_markerH setMarkerColorLocal "Colororange";
			};
			case (_pos select 2 < 150): {
				_markerH setMarkerColorLocal "ColorRed";
			};
		};
		
		_markerH setMarkertext format ["time of Flight: %1s | Altitude: %2m", str _timeOfFlight, _pos select 2];
	}, 0.5, [_markerH,_timeStart, _projectile]] call CBA_fnc_addPerFrameHandler;

	// Saving vars to projectile to use when it's deleted.
	_projectile setVariable ["ArtyRadar_PFH", _handle, true];
	_projectile setVariable ["ArtyRadar_ArtyPiece", _unit, true];
	_projectile setVariable ["ArtyRadar_markerH", _markerH, true];
	_projectile setVariable ["ArtyRadar_markerStr", _markerStr, true];
	// When deleted, it removes the PFH associated with this shell and the markers
	_projectile addEventHandler ["Deleted", {
		params ["_projectile"];
		private _handle =_projectile getVariable "ArtyRadar_PFH";
		private _unit = _projectile getVariable "ArtyRadar_ArtyPiece";
		private _markerH = _projectile getVariable "ArtyRadar_markerH";
		private _markerStr = _projectile getVariable "ArtyRadar_markerStr";
		
		[_handle] call CBA_fnc_removePerFrameHandler;
		// Makes impact marker
		_markerH setMarkertypeLocal "mil_box";
		_markerH setMarkerPosLocal _projectile;
		_markerH setMarkertext format ["Impact!"];
		// Deletes impact marker and arty locator after 10 seconds
		[{
			params ["_unit", "_markerH", "_markerStr"];
			sleep 10;
			_unit setVariable ["ArtyRadar_alertedPlayers", false, true];
			deleteMarker _markerH;
			deleteMarker _markerStr;
		}, [_unit, _markerH, _markerStr], 10] call CBA_fnc_waitAndExecute;
		// 10 above here refers to the time it takes for the impact marker to disappear. As soon as it does, alerted will become false.
	}];
}];
