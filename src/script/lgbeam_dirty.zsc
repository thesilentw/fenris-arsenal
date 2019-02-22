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
			//TNT1 A 0 A_Jump(256, FireVis1, FireVis2, FireVis3, FireVis4)
			Goto FireVisuals;

		FireVisuals:
			LITE B 1 A_WeaponOffset(invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
			LITE C 1 A_WeaponOffset(-invoker.shake, invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE B 1 A_WeaponOffset(invoker.shake, -invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE C 1 A_WeaponOffset(-invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
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


Class LBeam : Actor {
    
	int beamlifetime;
	property beam_life_time : beamlifetime;
	
	default {
		Radius 4;
		Height 4;
		Speed 2;
		Damage 2;
		Renderstyle "Add";
		Alpha 0.99;
		//Scale 0.9;
		PROJECTILE;
		+THRUSPECIES;
		+MTHRUSPECIES;
		+DONTSPLASH;
		+NODAMAGETHRUST;
		// 
		+FORCEPAIN;
		+FORCEXYBILLBOARD;
		+BLOODLESSIMPACT;
		+HITTRACER; // sets the thing it hits to AAPTR_TRACER
		//
		LBeam.beam_life_time 0;
	}

    States {
        Spawn:
            TNT1 A 0;
			Goto Movement;
        
		Movement:
            TNT1 A 0 {
				if (beamlifetime>=750) {
					return ResolveState("Dissipate");
				}
				if (!A_Warp(AAPTR_TRACER,velx,vely,velz,0,WARPF_ABSOLUTEOFFSET,1)) {
					return ResolveState("DetectSolid");
				}
				beamlifetime++;
				return ResolveState(Null);
			}
            Loop;
        
		DetectSolid:
            TNT1 A 5;
            Goto Movement;
        
		Dissipate:
            TNT1 A 0;
			Stop;
        
		Death:
			TNT1 A 0 A_JumpIfHealthLower (1, "JustImpact", AAPTR_TRACER);
			TNT1 A 0 A_CheckFlag ("BOSS", "JustImpact", AAPTR_TRACER);
			TNT1 A 0 A_JumpIf(CheckClass("ExplosiveBarrel", AAPTR_TRACER, TRUE), "JustImpact");
			TNT1 A 0 A_JumpIfInventory ("FDAliensStasisActive", 1, "ExtendStasis", AAPTR_TRACER);
			TNT1 A 0 // impact effect here
			TNT1 A 0 A_Warp (AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "ShockLoop", 0.5);
			Stop;

		JustImpact:
			TNT1 A 0 // impact effect here
			Stop;
		
		ShockLoop:
			TNT1 A 0 A_SpawnItemEx ("ShockEffectItem", 0,0,0, 0,0,0, 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
			Stop;
	
		ExtendShock:
			TNT1 A 0 // indicate extension
			TNT1 A 0 A_GiveInventory ("ChargeActivePowerup", 1, AAPTR_TRACER);
			Stop;
			
	}
}

Class ChargeActivePowerup : Powerup {
	default {
		+ADDITIVETIME;
		Powerup.Duration 105;
	}
}

class ShockEffectItem : Actor {
    default {
		Radius 6
		Height 6
		RenderStyle Add
		Alpha 0.95
		+FORCEXYBILLBOARD
		+NOINTERACTION
		+NOCLIP
	}
    
	States {
		Spawn:
			TNT1 A 0 A_GiveInventory ("ChargeActivePowerup", 1, AAPTR_TRACER);
			Goto ShockLoop;

		ShockLoop:
			TNT1 A 1 {
				if (tracer) {
					if (tracer.health > 0) {
						tracer.setStateLabel("Pain");
					}
				}
				return ResolveState(Null);
			}
			TNT1 A 0 A_JumpIfInventory ("ChargeActivePowerup", 1, "ShockLoopTeleport", AAPTR_TRACER);
			Stop;

		ShockLoopTeleport:
			TNT1 A 0 A_Warp (AAPTR_TRACER, 0,0,0, 0, WARPF_NOCHECKPOSITION, "ShockLoop", 0.5);
			Stop;
    }
}


class ChargeCounter : Inventory {
	default {
		Inventory.MaxAmount 0x777777;
		+Inventory.IGNORESKILL;
	}
}

class ChargeLogic : Actor {
	
    default {
		+DONTGIB;
		+NOINTERACTION;
		+NOCLIP;
		+NOBLOCKMAP;
    }

    States {
		Spawn:
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("DeathNull");
				}
				else return ResolveState(Null);
			}
				
		SpawnLoop:
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("DeathNull");
				}
				if (tracer.health <= 0) {
					return ResolveState("Death");
				}
								
				A_Warp(AAPTR_TRACER);
				statelabel nextstate = "SpawnLoop";
				
				A_TakeInventory("ChargeCounter", 1, giveto: AAPTR_TRACER);
				
				if (countInv("ChargeCounter", AAPTR_TRACER) > 0) {
					tracer.setStateLabel("Pain");
				}
				else {
					nextstate = "Death";
				}
				return ResolveState(nextstate);
			}
			stop;
		
		Death:
			TNT1 A 1 {
				A_TakeInventory("ChargeCounter", 0x777777, giveto: AAPTR_TRACER);
				Console.printf("ChargeLogic hit death state, destroying");
				}
			stop;	
		
		DeathNull: //if we have a null tracer
			TNT1 A 0 {
				Console.printf("ChargeLogic destroyed, null tracer");
			}
			stop;
    }
}


class ChargeVFX : Actor {
	int randomx, randomy, randomz;
    int lifetime, lifecheck;

    default {
        Radius 8;
        Height 8;
        Scale 0.85;
        Alpha 0.85;
        RenderStyle "Add";
        +NOBLOCKMAP;
        +NOGRAVITY;
        +FORCEXYBILLBOARD;
		+DONTGIB;
		+NOINTERACTION;
		+NOCLIP;
    }

    States {
		Spawn:
			TNT1 A 1;
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("SpawnEnd");
				}
				else if (tracer.health > 0) {
					A_PlaySound("weapons/lgun_elecloop", CHAN_7, looping: true);
					randomx = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
					//frandom((tracer.radius / 1.5), (tracer.radius / 1.5));
					randomy = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
					randomz = frandom((tracer.height * 0.52), (tracer.height * 0.57));
				}
				else {
					return ResolveState("SpawnEnd");
				}
				return ResolveState(Null);
			}
			
		SpawnLoop:
			LTXS ABCDEF 2 BRIGHT {
				if (!tracer) {
					return ResolveState("SpawnEnd");
				}
				if (tracer.health <= 0) {
					return ResolveState("SpawnEnd");
				}
				if (countInv("ChargeCounter", AAPTR_TRACER) < 1) {
					return ResolveState("SpawnEnd");
				}
				A_Warp(AAPTR_TRACER,randomx,randomy,randomz,0,WARPF_NOCHECKPOSITION | WARPF_INTERPOLATE);
				return ResolveState(null);
			}
			loop;
		
		SpawnEnd:
			LTXS ABCDE 1 Bright;
			LTXS F 1 Bright A_StopSound(CHAN_7);
			stop;
    }
}


class GiveChargeObjects : CustomInventory {
    
	default {
		Inventory.MaxAmount 1;
	}
	
	States {
		Pickup:
			TNT1 A 0 {
				A_SpawnItemEx("ChargeVFX", flags: SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
				A_SpawnItemEx("ChargeLogic", flags: SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
				Console.printf("GiveChargeObjects finished pickup state, destroying");
			}
			stop;
    }
}


class LGBeamSeeker : FastProjectile {
	
	default {
		Radius 8;
		Height 8;
		Speed 60;
		Damage 15;
		Projectile;
		+SEEKERMISSILE;
		+SCREENSEEKER;
		MissileType "LGSeekerTrail";
	}
	
	States {
		Spawn:
			TNT1 A 0 A_SeekerMissile(2, 20, SMF_LOOK | SMF_PRECISE, 100);
			TNT1 A 1 A_SpawnItemEx("LGSeekerTrail");
			Loop;
		Death:
			TNT1 A 0;
			Stop;
		XDeath:
			Goto Death;
	}
}

class LGSeekerTrail : Actor {
   default {
      RenderStyle "Add";
      Scale 0.3;
      Alpha 0.5;
      Translation "160:167=192:199", "64:79=197:201";
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
