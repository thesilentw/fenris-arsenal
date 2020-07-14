// zapvfx.zsc
//
//
Class ZapVFX : Actor {
	bool loggingEnabled;
	property loggingEnabled : loggingEnabled;
	
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
		ZapVFX.loggingEnabled true;
	}
	
	States {
		Spawn:
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("NullTracer");
				}
				return ResolveState("Null");
			}
				
		MainLoop:
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("NullTracer");
				}
				if (CountInv("ZapTracker", AAPTR_TRACER) > 0) {
					A_PlaySound("weapons/lgun_elecloop", CHAN_7, looping: true);
					return ResolveState("DoVFX");
				}
				else {
					return ResolveState("Expire");
				}
			}
			
		DoVFX:
			LTXS ABCDEF 2 BRIGHT;
			Goto WarpCheck;
		
		WarpCheck:
			TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "MainLoop", heightoffset: 0.5);

		Expire:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ZapVFX can't find ZapTracker, destroying");}
			}
			LTXS ABCDE 1 Bright;
			LTXS F 1 Bright A_StopSound(CHAN_7);
			Stop;
				
		NullTracer:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ZapVFX has null tracer, destroying");}
			}
			Stop;
    }
}
//eof