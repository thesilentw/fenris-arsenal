// laser pistol - similar to marathon's fusion pistol
// charge it too long and you go boom.
/*
Sprite Index:
	A is default, inactive charge
	B is charging level 1
	C is charging level 2
	D is charging level 3
	E/F is charging to Overload and beyond, alternates between the two
	G is recoiling
	H is recoiling with muzzle flash	
*/

Class Laspistol : FenrisWeapon {
	default {
		inventory.pickupMessage "Liberated a Locidion LP-101!\nERROR: CHARGE LIMITER MALFUNCTION, EXCERCISE CAUTION.";
		weapon.ammoType "Cell";
		weapon.ammoUse 1;
		weapon.slotNumber 2;
		weapon.SelectionOrder 2000;
		weapon.ammogive 100;
		weapon.yadjust 12;
	}
	
	States {			
		Ready:
			TNT1 A 0 A_TakeInventory("LasCharge", 0x7FFFFFFF); //remove all charge
			LSPS A 1 A_WeaponReady();
			Loop;
			
		Select:
			LSPS A 1 A_Raise();
			Loop;
			
		Deselect:
			LSPS A 1 A_Lower();
			Loop;
			
		Fire:
			LSPS B 5 A_GiveInventory("LasCharge", 70);
			TNT1 A 0 A_Refire("PlayChargeSound"); //the player is holding fire, play the sound and start charging
			Goto QuickFire;
			
		PlayChargeSound:
			LSPS B 1 A_PlaySound("weapons/LSPS_chargestart");
			Goto WaitForRelease;
		
		QuickFire:
			TNT1 A 0 A_FireProjectile("LasShot", angle: 0.2, useammo: true); //We released fire, shoot a projectile
			TNT1 A 0 A_PlaySound("weapons/LSPS_fire");
			LSPS H 3 A_Light2;
			LSPS H 4 A_Light1;
			LSPS G 2 A_Light0;
			Goto Ready;
			
		WaitForRelease:
			// if we're at a a charge milestone, play the sound
			TNT1 A 0 A_JumpIf(countInv("LasCharge") == 320, "PlayChargeSoundOverload");
			TNT1 A 0 A_JumpIf(countInv("LasCharge") == 260, "PlayChargeSound4");
			TNT1 A 0 A_JumpIf(countInv("LasCharge") == 200, "PlayChargeSound3");
			TNT1 A 0 A_JumpIf(countInv("LasCharge") == 130, "PlayChargeSound2");
			//TNT1 A 0 A_JumpIf(countInv("LasCharge") == 90, "PlayChargeSound1")
			// ok, we're not at a milestone, so check what sprite we should use - rounded down
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 320, "Overloading"); // overload, YOU CAN STOP NOW
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 260, "GainCharge4"); // between level 4 and overload
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 200, "GainCharge3"); // between level 3 and 4
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 130, "GainCharge2"); // between level 2 and 3
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 69, "GainCharge1"); // nice.
		
		GainCharge1:
			LSPS B 1 A_GiveInventory("LasCharge", 1); // accumulate some charge, level 1 sprite
			LSPS B 5 A_ReFire("WaitForRelease"); // if player is still holding fire, return to the holding state
			Goto FireLevel1; // otherwise shoot
	
		GainCharge2:
			LSPS C 1 A_GiveInventory("LasCharge", 1); // accumulate some charge, level 2 sprite
			LSPS C 5 A_ReFire("WaitForRelease"); // level 2 charge
			Goto FireLevel2;
	
		GainCharge3:
			LSPS D 1 A_GiveInventory("LasCharge", 1); // accumulate some charge, level 3 sprite
			LSPS D 5 A_ReFire("WaitForRelease"); // level 3 charge
			Goto FireLevel3;
	
		GainCharge4:
			LSPS E 1 A_GiveInventory("LasCharge", 1); // accumulate some charge, level 4 sprite
			LSPS E 5 A_ReFire("WaitForRelease"); // level 4 charge
			Goto FireLevel4;
			
		//PlayChargeSound1:
		//	LSPS B 1 A_GiveInventory("LasCharge", 1);
		//	LSPS B 1 A_PlaySound("weapons/LSPS_chargebeep"); // play the beep
		//	Goto WaitForRelease; // go back to the hold state
			
		PlayChargeSound2:
			LSPS B 1 A_GiveInventory("LasCharge", 1); // we skipped the acculumation state to play this sound
			LSPS B 1 A_PlaySound("weapons/LSPS_chargebeeplevel2");
			Goto WaitForRelease;
		
		PlayChargeSound3:
			LSPS C 1 A_GiveInventory("LasCharge", 1);
			LSPS C 1 A_PlaySound("weapons/LSPS_chargebeeplevel3");
			Goto WaitForRelease;
			
		PlayChargeSound4:
			LSPS D 1 A_GiveInventory("LasCharge", 1);
			LSPS D 1 A_PlaySound("weapons/LSPS_chargebeeplevel4");
			Goto WaitForRelease;
		
		PlayChargeSoundOverload:
			LSPS E 1 A_GiveInventory("LasCharge", 1);
			LSPS F 1 A_PlaySound("weapons/LSPS_chargebeepoverload");
			Goto WaitForRelease;
		
		
		FireLevel1:
			TNT1 A 0 {
				A_FireProjectile("LasShot", 0.2, true);
				A_PlaySound("weapons/LSPS_fire");
			}
			LSPS H 3 A_Light2;
			LSPS H 4 A_Light1;
			LSPS G 2 A_Light0;
			LSPS A 4;
			Goto Ready;
		
		FireLevel2:
			TNT1 A 0 {
				A_FireProjectile("LasShotLevel2", 0.2, true);
				A_PlaySound("weapons/LSPS_fire");
			}
			LSPS H 3 A_Light2;
			LSPS H 4 A_Light1;
			LSPS G 2 A_Light0;
			LSPS A 4;
			Goto Ready;
		
		FireLevel3:
			TNT1 A 0 {
				A_FireProjectile("LasShotLevel3", 0.2, true);
				A_PlaySound("weapons/LSPS_fire");
			}
			LSPS H 3 A_Light2;
			LSPS H 4 A_Light1;
			LSPS G 2 A_Light0;
			LSPS A 4;
			Goto Ready;
		
		FireLevel4:
			TNT1 A 0 {
				A_FireProjectile("LasShotLevel4", 0.2, true);
				A_PlaySound("weapons/LSPS_fire");
			}
			LSPS H 3 A_Light2;
			LSPS H 4 A_Light1;
			LSPS G 2 A_Light0;
			LSPS A 4;
			Goto Ready;

		Overloading:
			TNT1 A 0 A_JumpIf(countInv("LasCharge") > 341, "OverloadExplosion"); // splody time
			LSPS E 1 {
				A_GiveInventory("LasCharge", 1); // accumulate some charge, level 4 sprite
				A_WeaponOffset(-2, 0, WOF_ADD);
			}
			LSPS E 1 A_WeaponOffset(2, 0, WOF_ADD);
			LSPS E 1 A_WeaponOffset(-2, 2, WOF_ADD);
			LSPS E 1 A_WeaponOffset(2, -2, WOF_ADD);
			LSPS F 1 {
				A_GiveInventory("LasCharge", 1); // accumulate some charge, level 4 sprite
				A_WeaponOffset(-2, 0, WOF_ADD);
			}
			LSPS F 1 A_WeaponOffset(2, 0, WOF_ADD);
			LSPS F 1 A_WeaponOffset(-2, 2, WOF_ADD);
			LSPS F 1 A_WeaponOffset(2, -2, WOF_ADD);
			LSPS E 1 A_ReFire("WaitForRelease");
			TNT1 A 0 {
				A_WeaponOffset(0, 32, WOF_INTERPOLATE);
				A_FireProjectile("LasShotOverload", 0.2, true);
				A_PlaySound("weapons/LSPS_firebig");
			}
			LSPS H 3 {
				A_Light2();
				A_WeaponOffset(0, 40, WOF_INTERPOLATE);
			}
			LSPS H 4 {
				A_WeaponOffset(0, 37, WOF_INTERPOLATE);
				A_Light1();
			}
			LSPS G 2 {
				A_WeaponOffset(0, 34, WOF_INTERPOLATE);
				A_Light0();
			}
			LSPS C 10 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		OverloadExplosion:
			TNT1 A 1 {
				A_SetBlend("Cyan", 0.95, 70);
				A_PlaySound("weapons/LSPS_overloadexplosion");
				A_Explode(500,256);
			}
			Goto Ready;
		
		Spawn:
			TLGL A -1;
			Stop;
	}
}	

Class LasShot : Actor {
	default {
		Decal "DoomImpScorch";
		Radius 8;
		Height 8;
		Speed 40;
		DamageFunction (30+random(0,10));
		DamageType "Laser";
		Scale 0.35;
		Projectile;
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/LSPS_impact";
		Obituary "%o got some laser face removal, courtesy of %k's Laser Pistol.";
	}
	States {
		Spawn:
			LSBL ABC 4;
			Loop;
		Death:
			LSBL EFGH 3;
			Stop;
	}
}

Class LasShotLevel2 : LasShot {
	default {
		DamageFunction (40+random(0,10));
	}
}

Class LasShotLevel3 : LasShot {
	default {
		DamageFunction (50+random(0,10));
	}
}

Class LasShotLevel4 : LasShot {
	default {
		DamageFunction (60+random(0,10));
	}
}

Class LasShotOverload : LasShot {
	default {
		Radius 16;
		Height 16;
		DamageFunction (150+random(0,50));
		Scale 1.0;
		DeathSound "weapons/bfgx";
		Obituary "Good job, %k, there isn't much left of %o other than a pile of ash.";
	}
	States {
		Spawn:
			LSBL ABC 2;
			Loop;
		Death:
			LSBL EFGH 3 A_Explode(100, 128);
			Stop;
	}
}

Class LasCharge : Inventory {
	default {
		Inventory.MaxAmount 0x7FFFFFFF; //thanks murb
	}
}
	
// EOF