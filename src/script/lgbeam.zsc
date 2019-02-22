/* My next guests need little introduction. Hailing from the farthest north, the brainiacs at Raptor Labs
have a reputation for doing what others can't or won't.

Enter the last word in crowd control - The Raptor Labs Static Cannon.
Give your enemies the world's worst case of static cling...

THIS IS THE CONSTANT BEAM VERSION

I stole the beam functionality from Final Doomer's TNT Maser, and the stun is vaguely based on the Stasis Bow
ty Yholl pls no prosecute

*/ 
Class LGBeam: FenrisWeapon {
	
	int vfxlid, shake;

	property vfxLayerId : vfxlid;
	property shakeval : shake;
	
	default {
		inventory.pickupMessage "Lifted a Static Cannon!\nSeriously, lifting it alone is enough of a challenge. Shooting is extra.";
		weapon.slotNumber 7;
		weapon.SelectionOrder 7000;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Obituary "%k has successfully proved to %o that nothing is grounded when the current runs high enough.";
		LGBeam.vfxLayerId -8000;
		LGBeam.shakeval 2;
	}
	
	states {
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
				A_PlaySound("weapons/lgun_chargeloop", CHAN_WEAPON | CHAN_NOSTOP, looping: true);
			}
			/*
			TNT1 A 0 {
				A_Overlay(-8000, "ChargeVFX", true);
				invoker.charge = 1;
				A_Refire("Charging");
			}
			*/		
		FireLoop:
			TNT1 A 0 A_FireProjectile("LBeam", 0, 0);
			TTN1 A 0 A_RailAttack(0, 0, 0, "", "White", RGF_SILENT | RGF_NOPIERCING | RGF_FULLBRIGHT, 0, "", 0, 0, 750, 1, 0.2, 0.0, "None", -4);
			Goto FireVisuals;

		FireVisuals:
			LITE B 2 A_WeaponOffset(invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
			LITE C 2 A_WeaponOffset(-invoker.shake, invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE B 2 A_WeaponOffset(invoker.shake, -invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE C 2 A_WeaponOffset(-invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
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

Class LBeam : FastProjectile {
    
	bool loggingEnabled;
	int beamlifetime;
	property beam_life_time : beamlifetime;
	property logging_enabled : loggingEnabled;
	
	default {
		Radius 4;
		Height 4;
		Speed 150;
		Damage 1;
		PROJECTILE;
		+FORCEPAIN;
		+BLOODLESSIMPACT;
		+HITTRACER; // sets the thing it hits to AAPTR_TRACER
		LBeam.beam_life_time 0;
		LBeam.logging_enabled true;
	}

    States {
        Spawn:
            TNT1 A 1 {
				if (beamlifetime>=8) {
					if (loggingEnabled) {Console.printf("LBeam hit travel limit, destroying");}
					return ResolveState("Dissipate");
				}
				else {
					beamlifetime++;
					return ResolveState(Null);
				}
			}
            Loop;
		Dissipate:
            TNT1 A 0;
			Stop;
		Death:
			TNT1 A 0 {
				if (!tracer) {
					if (loggingEnabled) {Console.printf("null tracer");}
					return ResolveState("JustImpact");
				}				
				else if (tracer.health < 1) {
					if (loggingEnabled) {Console.printf("tracer health < 1");}
					return ResolveState("JustImpact");
				}
				//if (tracer.bBoss == true) {
				//	return ResolveState("JustImpact");
				//}
				//if (CheckClass("ExplosiveBarrel", AAPTR_TRACER, TRUE)) {
				//	return ResolveState("JustImpact");
				//}
				return ResolveState(null);
			}
			TNT1 A 0 A_JumpIfInventory ("ChargeActivePowerup", 1, "ExtendShock", AAPTR_TRACER);
			TNT1 A 0; // impact effect here
			TNT1 A 0 A_Warp(AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "GiveShock", 0.5);
			Stop;
		
		ExtendShock:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("extending charge");}
				return ResolveState(null);
			}
			// indicate extension
			TNT1 A 0 A_GiveInventory("ChargeActivePowerup", 1, AAPTR_TRACER);
			Stop;
		
		JustImpact:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("just impacting");}
				return ResolveState(null);
			} // impact effect here
			Stop;
		
		GiveShock:
			TNT1 A 0 {
				if (loggingEnabled && A_SpawnItemEx("ShockEffectItem", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {Console.printf("giving shock item");}
				if (loggingEnabled && A_SpawnItemEx("ShockEffectVFX", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {Console.printf("giving shock vfx");}
				if (loggingEnabled && A_SpawnItemEx("ShockEffectPulser", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS)) {Console.printf("giving shock pulser");}
				return ResolveState(null);
			}
			Stop;
				
	}
}

Class ChargeActivePowerup : Powerup {
	default {
		+INVENTORY.AUTOACTIVATE;
		+Inventory.ADDITIVETIME;
		Powerup.Duration 30;
	}
}

class ShockEffectItem : Actor {
    
	bool loggingEnabled;
	property logging_enabled : loggingEnabled;
	
	default {
		Radius 8;
		Height 8;
		+DONTGIB;
		+NOINTERACTION;
		+NOCLIP;
		ShockEffectItem.logging_enabled true;
	}
    
	States {
		Spawn:
			TNT1 A 0;
			TNT1 A 0 A_GiveInventory("ChargeActivePowerup", 1, AAPTR_TRACER);
			Goto ShockLoop;

		ShockLoop:
			TNT1 A 1 {
				if (tracer) {
					tracer.setStateLabel("Pain");
					return ResolveState(Null);
				}
				else return ResolveState("DeathNull");
			}
			TNT1 A 0 A_JumpIfInventory ("ChargeActivePowerup", 1, "ShockLoopWarpCheck", AAPTR_TRACER);
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ShockEffectItem destroying, no powerup found");}
				return ResolveState(null);
			}
			Stop;
		
		ShockLoopWarpCheck:
			TNT1 A 0 A_Warp (AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "ShockLoop", 0.5);
			Stop;
			
		DeathNull:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ShockEffectItem destroying - null tracer ");}
				return ResolveState(null);
			}
			stop;
    }
}

class ShockEffectVFX : Actor {
    
	int randomx, randomy, randomz;
	
	default {
        Radius 8;
        Height 8;
        Scale 0.95;
        Alpha 0.85;
        RenderStyle "Add";
        +FORCEXYBILLBOARD;
		+DONTGIB;
		+NOINTERACTION;
		+NOCLIP;
	}
    
	States {
		Spawn:
			TNT1 A 0 {
				if (tracer) {
						A_PlaySound("weapons/lgun_elecloop", CHAN_7, looping: true);
						randomx = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
						randomy = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
						randomz = frandom((tracer.height * 0.52), (tracer.height * 0.57));
						return ResolveState(Null);
				}
				else {
					return ResolveState("SpawnEnd");
				}
			}			
			Goto VFXLoop;

		VFXLoop:
			TNT1 A 1 {
				if (tracer) {
					return ResolveState("DoVFX");
				}
				else return ResolveState("SpawnEnd");
			}
			Stop;	
			
		DoVFX: 
			LTXS ABCDEF 2 BRIGHT;
			TNT1 A 0 A_JumpIfInventory ("ChargeActivePowerup", 1, "VFXLoopWarpCheck", AAPTR_TRACER);
			Goto SpawnEnd;
		
		VFXLoopWarpCheck:
			TNT1 A 0 A_Warp (AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "VFXLoop", 0.5);
			Goto SpawnEnd;
			
		SpawnEnd:
			LTXS ABCDE 1 Bright;
			LTXS F 1 Bright A_StopSound(CHAN_7);
			stop;
    }
}

class ShockEffectPulser : Actor {
	 
	int numproj, xoff, yoff, zoff, anoff, xvel, yvel;
		
	default {
        Radius 8;
        Height 8;
		+NOINTERACTION;
		+NOCLIP;
	}
    
	States {
		Spawn:
			TNT1 A 0 {
				master = target = players[consoleplayer].mo;
			}
		PulseLoop:
			TNT1 A 15 {
				if (tracer) {
					numproj = 16 - (int)(tracer.health/100);
					
					/*
					Actor testActor;
					BlockThingsIterator list = BlockThingsIterator.Create(self, 256);
						while (numproj > 0) {
							testActor = list.thing;
							if (CheckSight(testActor)) {
								// spawn thing?					
							}
							list.next();
							numproj--;
						}
					*/
					
					xoff = frandom(-20,20);
					yoff = frandom(-20,20);
					zoff = frandom(0,10);
					xvel = frandom(20, 50);
					yvel = frandom(20, 60);
					anoff = frandom(-180,180);
					
					
					do {
						/*
						if (numproj %2 == 0) {
							A_SpawnItemEx("LGBeamSeeker", xoff, yoff, tracer.height/2, xvel, yvel, 0, anoff, SXF_NOCHECKPOSITION);
						}
						else {
							A_SpawnItemEx("LGBeamSeeker", -xoff, -yoff, tracer.height/2, xvel, yvel, 0, anoff, SXF_NOCHECKPOSITION);
						}
						*/
						//A_FireProjectile("LGBeamSeeker", (tracer.height*1.5), frandom(-4,4), (90*numproj), CMF_AIMDIRECTION, frandom(-3,3));
						A_SpawnItemEx("LGBeamSeeker", xoff, yoff, tracer.height/2, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
						
						
						numproj--;
					} while (numproj > 0);
				
					return ResolveState(null);
				}
				else return ResolveState("SpawnEnd");
			}
			TNT1 A 0 A_JumpIfInventory ("ChargeActivePowerup", 1, "PulseLoopWarpCheck", AAPTR_TRACER);
			Goto SpawnEnd;

		PulseLoopWarpCheck:
			TNT1 A 0 A_Warp(AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "PulseLoop", 0.5);
			Goto SpawnEnd;
			
		SpawnEnd:
			TNT1 A 0;
			stop;
    }
}


Class LGBeamBouncer : Actor {

	default {
		Decal "BulletChip";
		Radius 8;
		Speed 35;
		Damage 10;
		Gravity 1;
		BounceFactor 0.99;
		BounceCount 2;
		Scale 0.4;
		Projectile;
		Alpha 0.9;
		RenderStyle "Add";
		BounceType "Hexen";
		+BOUNCEONACTORS;
		//DeathSound "weapons/sprf_hit";
		//BounceSound "weapons/sprf_ricochet";
	}
	States {
		Spawn:
			LTLP ABC 3;
			Loop;
		Death:
			LTXL ABCDEFG 3 A_Explode(128,128);
			Stop;
	}
}



class LGBeamSeeker : FastProjectile {
	
	default {
		Radius 8;
		Height 8;
		Speed 90;
		Damage 15;
		Projectile;
		+SEEKERMISSILE;
		//+SCREENSEEKER;
		MissileType "LGSeekerTrail";
	}
	
	States {
		Spawn:
			TNT1 A 1;
			TNT1 A 1 {
				master = players[consoleplayer].mo;
				target = players[consoleplayer].mo;
			}
		FlyLoop:
			TNT1 A 1 A_SeekerMissile(89, 90, SMF_PRECISE | SMF_LOOK, 256, 3);
			TNT1 A 1 {
				if (tracer) {
					if (tracer.health < 1) {
						return ResolveState("Death");
					}
					else 
						return ResolveState(Null);
				}
				else
					return ResolveState("Death");
			}
			TNT1 A 1 A_SpawnItemEx("LGSeekerTrail");
			Loop;
		Death:
			TNT1 A 0 {
				if (tracer) {
					if (countInv("ChargeActivePowerup", AAPTR_TRACER) > 0) {
						return ResolveState("ExtendShock");
					}
				}
				return ResolveState(Null);
			}
			Stop;
		XDeath:
			Goto Death;
		ExtendShock:
			// indicate extension
			TNT1 A 0 A_GiveInventory("ChargeActivePowerup", 1, AAPTR_TRACER);
			Stop;
	}
}

class LGSeekerTrail : Actor {
   default {
      RenderStyle "Add";
      Scale 0.15;
      Alpha 0.5;
      //Translation "160:167=192:199", "64:79=197:201";
      +BRIGHT
      +NOINTERACTION
   }
   states {
   Spawn:
      LTLP ABC 1 A_FadeOut(0.05);
      wait;
   }
}

//EOF
