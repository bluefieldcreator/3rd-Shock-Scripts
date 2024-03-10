// BLUEFIELD'S SMOOTHBORE LOGISTICS

/**
	PRIMARY VARIABLES (IMPORTANT!)
	These variables define the logic of the logistic system and the medical assets. Dont touch unless you know what you're doing.
 */
private _factoryAvailable = !isNull factory;
GAT_supplyBoxModel = "CargoNet_01_Box_F";
GAT_medicalBoxModel = "BOX_I_E_UAV_06_medical_F"
GAT_Main_Squad = "Artyom";

GAT_Medical_Supplies = createHashMapFromArray [["ACE_elasticBandage", 15], ["ACE_morphine", 10], ["ACE_tourniquet", 10]];
GAT_Squad_Supplies = createHashMapFromArray [];

/**
	Main Functions, beware, spaghetti ahead.
 */
GAT_fnc_message = {
	params ["_msg"];
	systemChat format ["Gatari's Smoothbore Logistics: %1", _msg];
};

GAT_fnc_addTransportLogic = {
	params ["_object"];
	_object addAction ["Transport", {
		params ["_target", "_caller", "_actionId"];

		private _isCarrying = _caller getVariable ["transporting", false];
		if (_isCarrying) then {
			systemChat "You are already carrying a box!!";
		} else {
			_target attachTo [_caller, [0, 2, 1.2]];
			_caller setVariable ["transporting", true];
			_target addAction ["Drop Crate", {
				params ["_target", "_caller", "_actionId"];
				detach _target;
				_target removeAction _actionId;
				_caller setVariable ["transporting", false];
			}];
		};
	}];
};

GAT_fnc_spawnLogi = {
	params ["_type", "_caller"];

	/**
		Check the type of crate demanded by the user.
	 */
	switch (_type) do {
		/**
			Medical Crate, we give them the pre-made hashmap of medical items. (GAT_Medical_Supplies)
		 */
		case "medical": {
			private _supplyBox = GAT_medicalBoxModel createVehicle position _caller;
			{
				_supplyBox addItemCargo [_x, _y]
			} forEach GAT_Medical_Supplies;
			[_supplyBox] call GAT_fnc_addTransportLogic;
		};

		/**
			Squad supply crate, for this one we have to add the weapons of all squad members, and some magazines of their guns.
		 */
		case "squad": {
			// Search for all "Opfor" groups. (Platoon -> Artyom etc...)
			private _opforGroups = groups opfor;
			{
				// Once we found the group, we check if its "Artyom", the reason why I choose Artyom is because it 'always exists' or has squad members.
				private _name = groupId _x;
				if (_name == GAT_Main_Squad) then {
					// Get all of Artyom's units. Important to get all their guns!
					private _unitsArtyom = units _x;
					{
						// We extract the primary weapon and its current magazine.
						private _currentPrimary = primaryWeapon _x;
						private _currentPrimaryMagazine = primaryWeaponMagazine _x;

						// We add it to the hashmap if not already in.

						private _alreadyInHashMap = _currentPrimary in GAT_Squad_Supplies;

						// Check if its already in (to avoid duplicates)
						if (!_alreadyInHashMap) then {
							private _firstMagazine = _currentPrimaryMagazine select 0;
							GAT_Squad_Supplies set [_currentPrimary, _firstMagazine]; // :3 we select 0 because arma is gay as fucc!!
						};
					} forEach _unitsArtyom;

					// with all weapons listed, we add the actual ammo and weapons to the box.
					private _supplyBox = GAT_supplyBoxModel createVehicle position _caller;
					[_supplyBox] call GAT_fnc_addTransportLogic;
					{
						// We add 3 primary weapons per gun listed in the hash map. Change the "3" to any other number at free will.
						_supplyBox addItemCargo [_x, 3];

						// Due to arma being kinda... goofy! We need to do this to get the actual magazine.
						private _fetchedMag = GAT_Squad_Supplies getOrDefault [_x];

						// We add it to the box. :3!!!
						_supplyBox addItemCargo [_fetchedMag, 15];
					} forEach GAT_Squad_Supplies;
				} else {
					private _errorMessage = format ["Squad '%1' Not found! Errors will occur.", GAT_Main_Squad];
					[_errorMessage] call GAT_fnc_message;
				};
			} forEach _opforGroups;
		};

		default {};
	};
};


if (!_factoryAvailable) then {
	["Factory not found. Gatari's Smoothbore Logistics wont work as intended!"] call GAT_fnc_message;
};

["Logistics System finished loading."] call GAT_fnc_message;

// MAIN PROCESS! :3
if (_factoryAvailable) then {
	["Starting factory process..."] call GAT_fnc_message;

	factory addAction ["Medical Box", {
		params ["_target", "_caller"];
		["medical", _caller] call GAT_fnc_spawnLogi;
	} ];

	factory addAction ["Squad Box", {
		params ["_target", "_caller"];
		["squad", _caller] call GAT_fnc_spawnLogi;
	} ];

	["Factory process complete."] call GAT_fnc_message;

	/*
		["Medical Box", "medical"] call GAT_fnc_addFactoryAction;
		["Testing Squad Crate", "squad"] call GAT_fnc_addFactoryAction;
	*/
};
