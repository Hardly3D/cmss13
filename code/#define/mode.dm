#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

#define MODE_INFESTATION		1
#define MODE_PREDATOR			2
#define MODE_NO_LATEJOIN		4
#define MODE_HAS_FINISHED		8

#define BE_ALIEN      1
#define BE_PAI		  2
#define BE_SURVIVOR	  4
#define BE_RESPONDER  8
#define BE_PREDATOR   16

#define BE_REV        32
#define BE_TRAITOR    64
#define BE_OPERATIVE  128
#define BE_CULTIST    256
#define BE_MONKEY     512
#define BE_NINJA      1024
#define BE_RAIDER     2048
#define BE_PLANT      4096
#define BE_MUTINEER   8192
#define BE_CHANGELING 16384

#define BE_WO_COM 32768
//=================================================

var/list/be_special_flags = list(
	"Xenomorph" = BE_ALIEN,
	"pAI" = BE_PAI,
	"Survivor" = BE_SURVIVOR,
	"Responder" = BE_RESPONDER,
	"Predator" = BE_PREDATOR

/*
	"Malf AI" = BE_MALF,
	"Revolutionary" = BE_REV,
	"Traitor" = BE_TRAITOR,
	"Operative" = BE_OPERATIVE,
	"Cultist" = BE_CULTIST,
	"Monkey" = BE_MONKEY,
	"Ninja" = BE_NINJA,
	"Raider" = BE_RAIDER,
	"Diona" = BE_PLANT,
	"Mutineer" = BE_MUTINEER,
	"Changeling" = BE_CHANGELING*/
	)

#define AGE_MIN 17			//youngest a character can be
#define AGE_MAX 160			//oldest a character can be
//Number of marine players against which the Marine's gear scales
#define MARINE_GEAR_SCALING_NORMAL 30
#define MAX_GEAR_COST 5 //Used in chargen for loadout limit.
//=================================================

//Various roles and their suggested bitflags or defines.

#define ROLEGROUP_MARINE_COMMAND		1

#define ROLE_COMMANDING_OFFICER			1
#define ROLE_EXECUTIVE_OFFICER			2
#define ROLE_BRIDGE_OFFICER				4
#define ROLE_MILITARY_POLICE			8
#define ROLE_CORPORATE_LIAISON			16
#define ROLE_REQUISITION_OFFICER		32
#define ROLE_PILOT_OFFICER				64
//=================================================

#define ROLEGROUP_MARINE_ENGINEERING 	2

#define ROLE_CHIEF_ENGINEER				1
#define ROLE_MAINTENANCE_TECH			2
#define ROLE_REQUISITION_TECH			4
//=================================================

#define ROLEGROUP_MARINE_MED_SCIENCE 	4

#define ROLE_CHIEF_MEDICAL_OFFICER		1
#define ROLE_CIVILIAN_DOCTOR			2
#define ROLE_CIVILIAN_RESEARCHER		4
//=================================================

#define ROLEGROUP_MARINE_SQUAD_MARINES 	8

#define ROLE_MARINE_LEADER			1
#define ROLE_MARINE_MEDIC			2
#define ROLE_MARINE_ENGINEER		4
#define ROLE_MARINE_STANDARD		8
#define ROLE_MARINE_SPECIALIST		16
//=================================================

#define ROLE_ADMIN_NOTIFY			1
#define ROLE_ADD_TO_SQUAD			2
#define ROLE_ADD_TO_DEFAULT			4
#define ROLE_ADD_TO_MODE			8
#define ROLE_WHITELISTED			16
//=================================================

//Role defines, specifically lists of roles for job bans and the like.
#define ROLES_COMMAND 		list("Commander","Executive Officer","Bridge Officer","Pilot Officer","Military Police","Corporate Liaison","Requisitions Officer","Chief Engineer","Chief Medical Officer")
#define ROLES_OFFICERS		list("Commander","Executive Officer","Bridge Officer","Pilot Officer","Military Police","Corporate Liaison")
#define ROLES_ENGINEERING 	list("Chief Engineer","Maintenance Tech")
#define ROLES_REQUISITION 	list("Requisitions Officer","Cargo Technician")
#define ROLES_MEDICAL 		list("Chief Medical Officer","Doctor","Researcher")
#define ROLES_MARINES		list("Squad Leader","Squad Specialist","Squad Medic","Squad Engineer","Squad Marine")
#define ROLES_SQUAD_ALL		list("Alpha","Bravo","Charlie","Delta")
#define ROLES_REGULAR_ALL	ROLES_OFFICERS + ROLES_ENGINEERING + ROLES_REQUISITION + ROLES_MEDICAL + ROLES_MARINES
#define ROLES_UNASSIGNED	list("Squad Marine")
//=================================================

//=================================================
#define WHITELIST_YAUTJA_UNBLOODED	1
#define WHITELIST_YAUTJA_BLOODED	2
#define WHITELIST_YAUTJA_ELITE		4
#define WHITELIST_YAUTJA_ELDER		8
#define WHITELIST_PREDATOR			(WHITELIST_YAUTJA_UNBLOODED|WHITELIST_YAUTJA_BLOODED|WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER)
#define WHITELIST_COMMANDER			16
#define WHITELIST_SYNTHETIC			32
#define WHITELIST_ARCTURIAN			64
#define WHITELIST_ALL				(WHITELIST_YAUTJA_UNBLOODED|WHITELIST_YAUTJA_BLOODED|WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER|WHITELIST_COMMANDER|WHITELIST_SYNTHETIC|WHITELIST_ARCTURIAN)
//=================================================

/*Access levels. Changed into defines, since that's what they should be.
It's best not to mess with the numbers of the regular access levels because
most of them are tied into map-placed objects. This should be reworked in the future.*/
#define ACCESS_MARINE_COMMANDER 	1
#define ACCESS_MARINE_LOGISTICS 	2
#define ACCESS_MARINE_BRIG 			3
#define ACCESS_MARINE_ARMORY 		4
#define ACCESS_MARINE_CMO 			5
#define ACCESS_MARINE_CE 			6
#define ACCESS_MARINE_ENGINEERING 	7
#define ACCESS_MARINE_MEDBAY 		8
#define ACCESS_MARINE_PREP 			9
#define ACCESS_MARINE_MEDPREP 		10
#define ACCESS_MARINE_ENGPREP 		11
#define ACCESS_MARINE_LEADER 		12
#define ACCESS_MARINE_SPECPREP 		13
#define ACCESS_MARINE_RESEARCH 		14

#define ACCESS_MARINE_ALPHA 		15
#define ACCESS_MARINE_BRAVO 		16
#define ACCESS_MARINE_CHARLIE 		17
#define ACCESS_MARINE_DELTA 		18

#define ACCESS_MARINE_BRIDGE 		19
#define ACCESS_MARINE_CHEMISTRY 	20
#define ACCESS_MARINE_CARGO 		21
#define ACCESS_MARINE_DROPSHIP 		22
#define ACCESS_MARINE_PILOT 		23

//Surface access levels
#define ACCESS_CIVILIAN_PUBLIC 		100
#define ACCESS_CIVILIAN_LOGISTICS 	101
#define ACCESS_CIVILIAN_ENGINEERING 102
#define ACCESS_CIVILIAN_RESEARCH	103

//Special access levels. Should be alright to modify these.
#define ACCESS_WY_PMC_GREEN 		180
#define ACCESS_WY_PMC_ORANGE	 	181
#define ACCESS_WY_PMC_RED			182
#define ACCESS_WY_PMC_BLACK			183
#define ACCESS_WY_PMC_WHITE			184
#define ACCESS_WY_CORPORATE 		200
#define ACCESS_ILLEGAL_PIRATE 		201

//Temporary until I turn these into defines/bitflags and develop proper IF tagging.
#define ACCESS_IFF_MARINE 			998
#define ACCESS_IFF_PMC 				999
//=================================================