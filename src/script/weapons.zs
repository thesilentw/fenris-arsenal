// weapons.zsc
// 
// Prototype for all Fenris Arsenal weapons
//
Class FenrisWeapon : DoomWeapon {
	//bool bLog;
	//property bLog : bLog;
	
	default {
		inventory.pickupMessage "OBTAINED DEFAULT WEAPON - THIS IS A BUG";
		weapon.slotNumber 1;
		weapon.SelectionOrder 1000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 10;
		Weapon.AmmoType "Clip";
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 0.2;
		+WEAPON.NODEATHINPUT;
		//weapon.attacksound "DSPISTOL";
		weapon.upsound "DSSGCOCK";
		weapon.yadjust 12;
		//bLog true;
	}
	States {
		Ready:
			SHTG A 1 A_WeaponReady();
			Loop;
		Select:
			SHTG A 1 A_Raise();
			Loop;
		Deselect:
			SHTG A 1 A_Lower();
			Loop;
		Fire:
			SHTG A 10 A_FireBullets(1, 1, 1, 10);
			SHTG A 1 A_WeaponReady();
			Goto Ready;
		Spawn:
			TLGL A -1;
			Stop;
	}
}

#include "script/laspistol.zs"
#include "script/spinrifle.zs"
#include "script/chainrail.zs"
#include "script/thumper.zs"
#include "script/lasrifle.zs"
#include "script/lascarbine.zs"
//#include "script/lightninggun.zs"
//#include "script/lgbeam.zs"
#include "script/conerifle.zs"
#include "script/lgtest.zs"
//eof