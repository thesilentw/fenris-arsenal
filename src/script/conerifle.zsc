//
//
Class Conerifle : FenrisWeapon {	
	default {
		inventory.pickupMessage "...";
		weapon.slotNumber 6;
		weapon.SelectionOrder 4000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.Kickback 500;
		Weapon.AmmoType "Cell";
		Obituary "%k shootybang maek ded %o";
	}
	
	states {
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