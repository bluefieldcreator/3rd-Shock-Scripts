/*
	TO_ALL_PLAYERS
	MADE BY BOHEMIA INTERACTIVE (WIKI LINK; https://community.bistudio.com/wiki/remoteExec | Example 9)

	Adds the global variable "TO_ALL_PLAYERS" for remote executions.

	HOW TO USE:
	1. Place script in init.sqf
	2. Use it in a remoteExec call like this:
	
	```sqf
		[params] remoteExec ["function", TO_ALL_PLAYERS];
	``` 
*/
if (isServer) then
{
	TO_ALL_PLAYERS = [0, -2] select isDedicated;

	private _allNegativeHCs = allPlayers apply { getPlayerID _x } select { _x != "-1" }	// all valid playerIDs
		apply { getUserInfo _x } select { _x select 7 }									// filter by HC
		apply { -(_x select 1) };														// get negative network ID

	if (_allNegativeHCs isNotEqualTo []) then
	{
		TO_ALL_PLAYERS = [TO_ALL_PLAYERS] + _allNegativeHCs;
	};

	publicVariable "TO_ALL_PLAYERS";

	addMissionEventHandler ["OnUserConnected", {
		params ["_networkId"];
		private _userInfo = getUserInfo _networkId;
		if !(_userInfo select 7) exitWith {}; // not a HC

		if (TO_ALL_PLAYERS isEqualType 0) then	// number to array conversion
		{
			if (TO_ALL_PLAYERS == 0) then		// player-hosted
			{
				TO_ALL_PLAYERS = [-(_userInfo select 1)];
			}
			else								// -2, dedicated server
			{
				TO_ALL_PLAYERS = [TO_ALL_PLAYERS, -(_userInfo select 1)];
			};
		}
		else									// already an array
		{
			TO_ALL_PLAYERS pushBackUnique -(_userInfo select 1);
		};

		publicVariable "TO_ALL_PLAYERS";
	}];
};
