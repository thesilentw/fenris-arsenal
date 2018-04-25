// Nocke (Nok-uh) HVB-X Chainrail
// Nocke Armaments' pride and joy, the Chainrail brings the instant-hit capability of a railgun to the average soldier,
// at a cyclic rate of just under 60 RPM. The HVB-X's 14mm tungsten darts are guaranteed to put a dent in anyone's day,
// if not punch all the way through it. 
//
// Nocke Armaments - Nock and Loose!
// Ask about our high-risk contractor discounts!
//
//
Class Chainrail : FenrisWeapon {	
	default {
		inventory.pickupMessage "Coralled a ChainRail!";
		weapon.slotNumber 4;
		weapon.SelectionOrder 4000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.Kickback 500;
		Weapon.AmmoType "Cell";
		//+Weapon.DontBob;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 0.2;
		+WEAPON.NODEATHINPUT;
		Obituary "%o got railed by %k's Chainrail.";
	}
	
	states {
		Ready:
			CHRL A 1 A_WeaponReady();
			Loop;
		Select:
			CHRL A 1 A_Raise();
			Loop;
		Deselect:
			CHRL A 1 A_Lower();
			Loop;
		Fire:
			CHRL E 3 {
				A_RailAttack(77, 0, false, "c5c5ff", "c5c5ff", RGF_SILENT | RGF_NORANDOMPUFFZ, 0, "CHRLPuff", frandom(-0.2,0.2), frandom(-0.2,0.2), 0, 15, 1.2, 2.5, "none", 5, 180, 3);
				A_PlaySound("weapons/chrl_fire1", CHAN_WEAPON);
				A_TakeInventory("Cell", 1);
				A_WeaponOffset(0, 45, WOF_INTERPOLATE);
				}
			CHRL E 3 A_WeaponOffset(0, 42, WOF_INTERPOLATE);
			CHRL A 2 A_WeaponOffset(0, 39, WOF_INTERPOLATE);
			CHRL A 4 A_WeaponOffset(0, 37, WOF_INTERPOLATE);
			CHRL A 0 A_PlaySound("weapons/chrl_rechamber", CHAN_BODY);
			CHRL B 5 A_WeaponOffset(-4, 34, WOF_INTERPOLATE);
			CHRL C 5 A_WeaponOffset(-10, 36, WOF_INTERPOLATE);
			CHRL D 5 A_WeaponOffset(0, 36, WOF_INTERPOLATE);
			CHRL A 5 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			CHRL A 4 A_WeaponReady(WRF_NOBOB);
			Goto Ready;
		Spawn:
			TLGL A -1; //no pickup sprite yet
			Stop;
	}
}

class CHRLPuff : BulletPuff {
	default { 
		+ALWAYSPUFF;
		-RANDOMIZE;
		VSpeed 0.5;
		Alpha 0.8;
	}
	states {
		Spawn: //8 tics normally
			CHPF ABCDGHI 1;
			Stop;
	}
}