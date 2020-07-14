/*
LGTEST.ZSC

Ok, let's try something new.

Plan:
Hit an enemy with a limited-length beam (Zapper)
If the enemy already has charge, give it some more (Zaptracker)
If the enemy is uncharged, give the enemy a manager item (Zapmaster)
Give the enemy an amount of charge (Zaptracker)
Stun the enemy as long as it has charge (Zapmaster)
Play VFX as long as the enemy is stunned (ZapVFX)
Emit targeted projectiles as long as the enemy is stunned (ZapPulser)

*/
#include "script/zapmaster.zsc"
#include "script/zapvfx.zsc"
#include "script/zappulser.zsc"
 
Class LGTest: FenrisWeapon {
	int vfxLayerId, shakeval;

	property vfxLayerId : vfxLayerId;
	property shakeval : shakeval;
	
	default {
		inventory.pickupMessage "TEST LIGHTING GUN";
		weapon.slotNumber 7;
		weapon.SelectionOrder 7000;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Obituary "zap zap splort";
		LGTest.vfxLayerId -8000;
		LGTest.shakeval 2;
		+WEAPON.NOAUTOFIRE;
	}
	
	States {
		Ready:
			LITE A 1 A_WeaponReady();
			Loop;
		
		Select:
			LITE A 1 A_Raise();
			Loop;
		
		Deselect:
			LITE A 1 A_Lower();
			Loop;
		
		Fire:
			LITE A 4 {
				A_WeaponReady(WRF_NOBOB | WRF_NOFIRE);
				A_PlaySound("weapons/lbmfire", 7);
				//A_PlaySound("weapons/lgun_chargeloop", CHAN_WEAPON | CHAN_NOSTOP, looping: true);
			}		
		FireLoop:
			TNT1 A 0 A_FireProjectile("Zapper", 0, 0);
			TTN1 A 0 A_RailAttack(0, 0, 0, "", "White", RGF_SILENT | RGF_NOPIERCING | RGF_FULLBRIGHT, 0, "", 0, 0, 750, 1, 0.2, 0.0, "None", -4);
			Goto FireVisuals;

		FireVisuals:
			LITE B 2 A_WeaponOffset(invoker.shakeval, 0, WOF_ADD | WOF_INTERPOLATE);
			LITE C 2 A_WeaponOffset(-invoker.shakeval, invoker.shakeval, WOF_ADD | WOF_INTERPOLATE);
			LITE B 2 A_WeaponOffset(invoker.shakeval, -invoker.shakeval, WOF_ADD | WOF_INTERPOLATE);
			LITE C 2 A_WeaponOffset(-invoker.shakeval, 0, WOF_ADD | WOF_INTERPOLATE);
			TNT1 A 0 A_Refire("AmmoCheck");
			Goto EndFire;
		
		AmmoCheck:
			TNT1 A 0 {
				A_TakeInventory("Cell", 1);
				if (countInv("Cell") < 1) {
					return ResolveState("Dryfire");
				}
				return ResolveState(Null);
			}
			//if no ammo do thing
			// alert???
			Goto FireLoop;
		
		Dryfire:
		EndFire:	
		Recharge:
			TNT1 A 0 {
				A_StopSound(CHAN_WEAPON);
				A_StopSound(7);
			}
			LITE A 50 A_PlaySound("weapons/lgun_rechargebeep", CHAN_6);
			Goto Ready;	
			
		Spawn:
			TLGL A -1;
			Stop;
	}
}

Class Zapper : FastProjectile {
	bool loggingEnabled;
	int maxLifetime;
	int currentLifetime;
	
	property loggingEnabled : loggingEnabled;
	property maxLifetime : maxLifetime;
	property currentLifetime : currentLifetime;
	
	default {
		Radius 4;
		Height 4;
		Speed 150;
		Damage 15;
		PROJECTILE;
		+FORCEPAIN;
		+HITTRACER; // sets the thing it hits to AAPTR_TRACER
		+GETOWNER;
		Zapper.loggingEnabled true;
		Zapper.maxLifetime 8;
		Zapper.currentLifetime 0;
	}
	
	States {
        Spawn:
            TNT1 A 1 {
				if (currentLifetime > maxLifetime) {
					if (loggingEnabled) {Console.printf("projectile lived for %i tics, fizzling", maxLifetime);}
					return ResolveState("Fizzle");
				}
				else {
					currentLifetime++;
					return ResolveState(Null);
				}
			}
            Loop;
		
		Fizzle:
            TNT1 A 0;
			Stop;
		
		Death:			
			TNT1 A 0 {
				if (!tracer) {
					if (loggingEnabled) {Console.printf("Null tracer");}
					return ResolveState("JustImpact");
				}
				return ResolveState(null);
			}					
			TNT1 A 0 {
				//if (tracer.health < 1) {
				//	if (loggingEnabled) {Console.printf("Tracer health < 15");}
				//	return ResolveState("JustImpact");
				//}
				if (tracer.bBoss) {
					if (loggingEnabled) {Console.printf("Hit Boss");}
					return ResolveState("JustImpact");
				}
				if (CheckClass("ExplosiveBarrel", AAPTR_TRACER, TRUE)) {
					if (loggingEnabled) {Console.printf("Hit Barrel");}
					return ResolveState("JustImpact");
				}
				return ResolveState(null);
			}
			TNT1 A 0 { 
				if (CountInv("Zaptracker", AAPTR_TRACER) > 0) {
					return ResolveState("ExtendShock");
				}
				else {
					return ResolveState("GiveShock");
				}
				return ResolveState(null);
			}
			Stop;
		
		ExtendShock:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("Enemy charged, extending charge");}
			}
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("but not really, this is a test");}
			}
			Stop;
		
		JustImpact:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("just impacting");}
			}
			Stop;
		
		GiveShock:
			TNT1 A 0 {
				if (loggingEnabled && A_SpawnItemEx("ZapMaster", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {
					Console.printf("Spawning ZapMaster on target");
				}
				if (loggingEnabled && A_GiveInventory("ZapTracker", 1, AAPTR_TRACER)) {
					Console.printf("Giving Zaptracker to target");
				}
				if (loggingEnabled && A_SpawnItemEx("ZapVFX", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {
					Console.printf("Spawning ZapVFX on target");
				}
				if (loggingEnabled && A_SpawnItemEx("ZapPulser", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {
					Console.printf("Spawning ZapPulser on target");
				}
				return ResolveState(null);
			}
			Stop;
	}
}

Class ZapTracker : Inventory {
	default {
		Inventory.MaxAmount 0xFFFFFF;
		+INVENTORY.IGNORESKILL;
	}
}

//EOF
