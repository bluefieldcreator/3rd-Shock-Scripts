/**
	ARTILLERY RADAR SCRIPT
	MADE BY THE ONLY ONE, BLUEFIELD

	THIS SCRIPT IS A PART OF THE "ARTILLERY RADAR" SYSTEM, WHICH IS A SYSTEM THAT DETECTS INCOMING ARTILLERY PROJECTILES AND ALERTS THE LEADERSHIP OF EACH GROUP PER PLAYER.

	HOW TO USE;
	1. PLACE SCRIPT INSIDE MISSION FOLDER
	2. PLACE THIS CODE INSIDE THE ARTILLERY UNIT YOU WANT TO TRACK;
	```
	this setVariable ['alerted', false, true];
	this addEventHandler ["Fired", {_this execVM "artillery.sqf";}]; 
	```
 */

if (!hasInterface) exitWith {};
private _projectile = _this select 6;
private _unit = _this select 0;

// ALERT setTinGS:
private _posGrid = mapGridPosition (getPos _projectile);
private _message = format ["Artillery Radar Alert<br />Incoming artillery detected. Seek Shelter!<br />ORIGIN GRID SQUARE: %1", _posGrid];


// We alert the leadership of each group per player
if (!(_unit getVariable "alerted")) then {
	_unit setVariable ['alerted', true, true];
	{
		private _leader = leader _x;
		_leader createDiaryRecord ["Diary", ["Artillery Radar Alert", _message]];

		"INCOMING!\nARTY DATA SENT TO YOUR BRIEFING!" remoteExec ["hint", allPlayers select {
			leader group _x == _x
		}, true];
	} forEach allPlayers;
};


private _markerTrace = "EH_fired_Bullet";
private _cnt = random 50000;
_markerTrace = format ["%1_%2", _markerTrace, _cnt];
// PROJECTILE TRACE
_marker = createMarker[_markerTrace, (getPos _projectile)];
_marker setMarkerShape "ICON";
_marker setMarkertype "mil_dot";
_marker setMarkerSize [0.5, 0.5];

private _markerHeight = "EH_fired_Bullet";
private _cnt = random 50000+50000;
private _markerHeight = format ["%1_%2", _markerHeight, _cnt];

// PROJECTILE MARKER
_markerH = createMarker[_markerHeight, (getPos _projectile)];
_markerH setMarkerShape "ICON";
_markerH setMarkertype "loc_move";
_markerH setMarkerSize [1, 1];
_markerH setMarkerDir (getDir _projectile + 180);

_markerstr = createMarker ["Suspected Artillery", _this select 0];
_markerstr setMarkerShape "ELLIPSE";
_markerstr setMarkerColor "ColorRed";
_markerstr setMarkerSize [30, 30];
_markerstr setMarkertext "Enemy Artillery";

private _timeStart = time;

_height = 0;
_time = 0;
while { alive _projectile } do {
	_time = round ((time - _timeStart) * 100)/100;
	_pos = getPosATL _projectile;
	if (_height < _pos select 2) then {
		_height = _pos select 2;
		_markerH setMarkerPos _pos;
	};

	switch (true) do {
		case (_pos select 2 > 1000): {
			_marker setMarkerColor "ColorGreen";
		};
		case (_pos select 2 > 500 && _pos select 2 < 1000): {
			_marker setMarkerColor "ColorYellow";
		};
		case (_pos select 2 > 150 && _pos select 2 < 500): {
			_marker setMarkerColor "Colororange";
		};
		case (_pos select 2 < 150): {
			_marker setMarkerColor "ColorRed";
		};
	};

	_marker setMarkerPos _pos;
	_marker setMarkertext format ["time of Flight: %1s | Altitude: %2m", str _time, _pos select 2];
	_markerH setMarkerPos _pos;

	sleep 0.5;
};

sleep 10;
_this select 0 setVariable ['alerted', false, true];
{
	deleteMarker _x
} forEach [_marker, _markerH, _markerstr];

