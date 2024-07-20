exec function statename()
{
	theGame.GetGuiManager().ShowNotification( thePlayer.GetCurrentStateName() );
}

exec function tauntvar()
{
	var vSCAARTaunt : cSCAARTaunt;
	theGame.GetGuiManager().ShowNotification( vSCAARTaunt.inTauntAnim );
}

function SCAARLeaveTaunt()
{
	thePlayer.RaiseEvent( 'CombatTauntComplete' );
}

function SCAARLeaveIdleTauntHit()
{
	thePlayer.RaiseEvent( 'Hit' );
}

function PlayAnimation(animation_name: name)
{
    var sett                                     : SAnimatedComponentSlotAnimationSettings;
    
    sett.blendIn = 0.2f;
    sett.blendOut = 1.f;
        
    thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( animation_name, 'PLAYER_SLOT', sett );
	
}

function SCAAR_GetVoiceTauntsEnabled(): bool 
{
  return theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARTauntsEnabled');
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function SCAARCallTaunt()
{
	SCAARTaunt();
}

function SCAARInterruptTaunt()
{
	SCAARInterrupt();
}

struct STauntStruct
{
	var tauntChance 						: float; //= RandF();
	var voiceTauntChance					: float; //= RandF();
	var randValue							: float; //= RandF();
	var battlecry_timeForNext				: float;
	var battlecry_delayMin					: float;	default battlecry_delayMin = 5;
	var battlecry_delayMax					: float;	default battlecry_delayMax = 10;
	var battlecry_lastTry					: name;
	var oneOrTwoHandedIdle					: float; //= thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ); //0 = 1handed, 1 = 2handed
	var leftOrRightStance 					: float; //= thePlayer.GetBehaviorVariable( 'combatIdleStance' ); //0 = left, 1 = right
	//var inTauntAnim						: bool;		default inTauntAnim = true;
	//var leftStance, rightStance			: name;
	//var oneHanded, twoHanded				: name;
}

function IsInTauntAnim() : bool
{
	var vSCAARTaunt : cSCAARTaunt;
	return vSCAARTaunt.inTauntAnim;
}

function IsInLeftOrRightStance(): name
{
	var SCAARStruct					:	STauntStruct;
	var leftStance, rightStance		:	name;
	if ( thePlayer.GetBehaviorVariable( 'combatIdleStance' ) == 0 ) //0 = left, 1 = right
	{
		return 'leftStance';
	}
	else
	{
		return 'rightStance';
	}
}

function IsOneOrTwoHandedIdle(): name
{
	var SCAARStruct					:	STauntStruct;
	var oneHanded, twoHanded		:	name;
	if ( thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ) == 0 ) //0 = one handed, 1 = two handed
	{
		return 'oneHanded';
	}
	else
	{
		return 'twoHanded';
	}
}

function SetInTauntAnim(flag : bool)
{
	var vSCAARTaunt : cSCAARTaunt;
	vSCAARTaunt.inTauntAnim = flag;
}

function SCAARTaunt()
{
	var vSCAARTaunt : cSCAARTaunt;
	vSCAARTaunt = new cSCAARTaunt in theGame;
	
	vSCAARTaunt.Engage();
}

function SCAARInterrupt()
{
	var vSCAARTaunt : cSCAARTaunt;
	
	vSCAARTaunt.Interrupt();
}

statemachine class cSCAARTaunt
{
	var SCAARStruct					: STauntStruct;
	var inTauntAnim					: bool;
	
	function Engage()
	{
		this.PushState('Engage');
	}
	
	function Interrupt()
	{
		this.PushState('Interrupt');
	}
}

state Engage in cSCAARTaunt
{
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SCAARTauntFilter();
	}
	
	entry function SCAARTauntFilter()
	{
		if ( !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& !thePlayer.isInFinisher
		&& !thePlayer.IsCiri() )
		{
			//if ( thePlayer.GetCurrentStateName() == 'Exploration' )
			//{
				//SCAARPlayExplorationTaunt();
			//}
			if ( SCAAR_GetVoiceTauntsEnabled() )
			{
				SCAARPlayVoiceTaunt();
			}
			
			if ( thePlayer.GetCurrentStateName() == 'CombatFists'  
			|| thePlayer.GetCurrentStateName() == 'CombatSteel' 
			|| thePlayer.GetCurrentStateName() == 'CombatSilver' )
			{
				SCAARPlayCombatTaunt();
			}
			else
				return;
		}
	}
	
	latent function SCAARPlayExplorationTaunt()
	{
		var tauntChance 	: float = RandF();
		
		if ( thePlayer.playerMoveType == PMT_Idle )
		{
			if ( !( thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ) ) )
			{
				if ( tauntChance > 0.5f )
				{
					PlayAnimation( 'man_geralt_sword_taunt_close_01' );
				}
				else
				{
					PlayAnimation( 'man_geralt_sword_taunt_far_01' );
				}
			}
			else //if ( thePlayer.IsDeadlySwordHeld() )
			{
				if ( tauntChance > 0.5f )
				{
					PlayAnimation( 'man_geralt_sword_taunt_close' );
				}
				else
				{
					PlayAnimation( 'man_geralt_sword_taunt_far' );
				}
			}
		}
		//currently no ideas for moving exploration taunts yet
	}
	
	latent function SCAARPlayCombatTaunt()
	{
		var tauntChance 				: float = RandF();
		var currentTime 				: float ;
		currentTime = theGame.GetEngineTimeAsSeconds();
		
		if ( thePlayer.playerMoveType == PMT_Idle )
		{
			if ( !( thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ) ) )
			{
				thePlayer.SetBehaviorVariable( 'combatTauntType', 1.0f );
				thePlayer.RaiseEvent( 'CombatTaunt' );
			}
			else //if ( !theInput.IsActionPressed('LockAndGuard') )
			{
				thePlayer.SetBehaviorVariable( 'combatTauntType', 0.0f );
				thePlayer.RaiseEvent( 'CombatTaunt' );
				return;
				if ( IsOneOrTwoHandedIdle() == 'oneHanded' )
				{
					if ( IsInLeftOrRightStance() == 'leftStance' )
					{
						if ( tauntChance > 0.5f )
						{
							PlayAnimation ( 'man_geralt_sword_left_agony_taunt' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 1.866667f );
							//else if ( theInput.IsActionPressed ('LockAndGuard') theGame.GetEngineTimeAsSeconds() < 1.866667f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
						else
						{
							PlayAnimation ( 'man_npc_sword_1hand_taunt_1_left' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 3.833333f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 3.833333f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
					}
					else if ( IsInLeftOrRightStance() == 'rightStance' )
					{
						if ( tauntChance > 0.5f )
						{
							PlayAnimation ( 'man_geralt_sword_right_agony_taunt' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 1.866667f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 1.866667f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
						else
						{
							PlayAnimation ( 'man_npc_sword_1hand_taunt_9_right' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 1.8f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 1.8f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
					}
				}
				else if ( IsOneOrTwoHandedIdle() == 'twoHanded' )
				{
					if ( IsInLeftOrRightStance() == 'leftStance' )
					{
						if ( tauntChance > 0.5f )
						{
							PlayAnimation ( 'man_npc_longsword_taunt_01_lp' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 2.f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 2.f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
						else
						{
							PlayAnimation ( 'man_npc_longsword_taunt_02_lp' );
							theGame.GetEngineTimeAsSeconds();
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 2.333333f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 2.333333f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
					}
					else if ( IsInLeftOrRightStance() == 'rightStance' )
					{
						if ( tauntChance > 0.5f )
						{
							PlayAnimation ( 'man_npc_longsword_taunt_01_rp' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 2.f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 2.f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
						else
						{
							PlayAnimation ( 'man_npc_longsword_taunt_03_rp' );
							parent.inTauntAnim = true;
							thePlayer.AddTimer ( 'AnimLength', 2.f );
							//else //if ( theInput.IsActionPressed ('LockAndGuard') && theGame.GetEngineTimeAsSeconds() < 2.f )
							//{
								//parent.PushState ('Interrupt');
							//}
						}
					}
				}
				theGame.GetGuiManager().ShowNotification( parent.inTauntAnim );
				//SleepOneFrame();
				//parent.inTauntAnim = false;
			}
		}
		else if ( thePlayer.playerMoveType == PMT_Walk )
		{
			if ( !( thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ) ) )
			{
				thePlayer.SetBehaviorVariable( 'combatTauntType', 1.0f );
			}
			else
			{
				thePlayer.SetBehaviorVariable( 'combatTauntType', 0.0f );
			}
			thePlayer.RaiseEvent( 'CombatTaunt' );		//unarmed & combat stance is done through the behaviour
		}
	}
	
	public timer function AnimLength( dt: float, id: int )
	{
		parent.inTauntAnim = false;
		theGame.GetGuiManager().ShowNotification( parent.inTauntAnim );
	}
	
	latent function SCAARPlayVoiceTaunt()
	{
		var voiceTauntChance 	: float = RandF();
		
		if ( thePlayer.GetCurrentStateName() == 'Exploration' )
			SCAARPlayBattleCry( 'Swears', 1.f, false, false );
		else if ( thePlayer.GetTarget().IsHuman() )
		{
			if ( voiceTauntChance <= 0.25 )
				SCAARPlayBattleCry( 'BattleCryHumansStart', 1.f, false, false );
			else if ( voiceTauntChance > 0.25 && voiceTauntChance <= 0.5 )
				SCAARPlayBattleCry( 'BattleCryHumansHit', 1.f, false, false );
			else if ( voiceTauntChance > 0.5 && voiceTauntChance <= 0.75 )
				SCAARPlayBattleCry( 'BattleCryTaunt', 1.f, false, false );
			else
				SCAARPlayBattleCry( 'BattleCryAttack', 1.f, false, false );
		}
		else //if ( thePlayer.GetTarget().IsMonster() || thePlayer.GetTarget().IsVampire() || thePlayer.GetTarget().IsAnimal() )
		{
			if ( voiceTauntChance <= 0.25 )
				SCAARPlayBattleCry( 'BattleCryMonstersStart', 1.f, false, false );
			else if ( voiceTauntChance > 0.25 && voiceTauntChance <= 0.5 )
				SCAARPlayBattleCry( 'BattleCryMonstersHit', 1.f, false, false );
			else if ( voiceTauntChance > 0.5 && voiceTauntChance <= 0.75 )
				SCAARPlayBattleCry( 'BattleCryTaunt', 1.f, false, false );
			else 
				SCAARPlayBattleCry( 'BattleCryAttack', 1.f, false, false );
		}
	}
	
	latent function SCAARPlayBattleCry( _BattleCry : name , _Chance : float, optional _IgnoreDelay, ignoreRepeatCheck : bool )
	{
		var randValue			: float = RandF();
		var battlecry_lastTry	: name;
		var battlecry_delayMin 	: float;
		var battlecry_delayMax 	: float;
		var battlecry_timeForNext : float;
		parent.SCAARStruct.battlecry_lastTry = battlecry_lastTry;
		parent.SCAARStruct.battlecry_timeForNext = battlecry_timeForNext;
		parent.SCAARStruct.battlecry_delayMin = battlecry_delayMin;
		parent.SCAARStruct.battlecry_delayMax = battlecry_delayMax;
		
		if ( !ignoreRepeatCheck )
		{
			if( battlecry_lastTry == _BattleCry )
				return;
		}
		
		battlecry_lastTry = _BattleCry;
				
		if( randValue < _Chance && ( _IgnoreDelay || SCAARBattleCryIsReady() )  )
		{
			thePlayer.PlayVoiceset( 90, _BattleCry );			
			
			battlecry_timeForNext = theGame.GetEngineTimeAsSeconds() + RandRangeF( battlecry_delayMax, battlecry_delayMin );
		}
		
	}
	
	function SCAARBattleCryIsReady( ) : bool
	{
		var l_currentTime : float;
		var battlecry_timeForNext : float;
		parent.SCAARStruct.battlecry_timeForNext = battlecry_timeForNext;
		
		l_currentTime = theGame.GetEngineTimeAsSeconds();
		
		if( l_currentTime >= battlecry_timeForNext )
		{
			return true;
		}		
		return false;
	}
	
	function SCAARLeaveTaunt()
	{
		thePlayer.RaiseEvent( 'CombatTauntComplete' );
	}
	
	/*
	exec function testtaunt()
	{
	var randValue : int;
	randValue = RandRange(100);
		if ( thePlayer.playerMoveType == PMT_Idle )
			thePlayer.RaiseEvent( 'CombatTaunt' );
		if( thePlayer.GetTarget().IsHuman() )
			if ( randValue < 25 )
				SCAARPlayBattleCry( 'BattleCryHumansStart', 1.f, true, true );
			if ( randValue >= 25 && randValue < 50 )
				SCAARPlayBattleCry( 'BattleCryHumansHit', 1.f, true, true );
			if ( randValue >= 50 && randValue < 75 )
				SCAARPlayBattleCry( 'BattleCryTaunt', 1.f, true, true );
			if ( randValue >= 75 )
				SCAARPlayBattleCry( 'BattleCryAttack', 1.f, true, true );
		else
			if ( randValue < 25 )
				SCAARPlayBattleCry( 'BattleCryMonstersStart', 1.f, true, true );
			if ( randValue >= 25 && randValue < 50 )
				SCAARPlayBattleCry( 'BattleCryMonstersHit', 1.f, true, true );
			if ( randValue >= 50 && randValue < 75 )
				SCAARPlayBattleCry( 'BattleCryTaunt', 1.f, true, true );
			if ( randValue >= 75 )
				SCAARPlayBattleCry( 'BattleCryAttack', 1.f, true, true );
	}
	
	latent function RemoveIdleTags()
	{
		if ( thePlayer.HasTag( 'scaar_1handed' ) )
		{
			thePlayer.RemoveTag('scaar_1handed');
		}
		else if ( thePlayer.HasTag( 'scaar_2handed' ) )
		{
			thePlayer.RemoveTag('scaar_2handed');
		}
	}
	
	latent function RemoveMovementTags()
	{
		if ( thePlayer.HasTag( 'scaar_1handed_movement' ) )
		{
			thePlayer.RemoveTag('scaar_1handed_movement');
		}
		else if ( thePlayer.HasTag( 'scaar_hybrid_movement' ) )
		{
			thePlayer.RemoveTag('scaar_hybrid_movement');
		}
		else if ( thePlayer.HasTag( 'scaar_2handed_movement' ) )
		{
			thePlayer.RemoveTag('scaar_2handed_movement');
		}
	}
	
	latent function RemoveDodgeTags()
	{
		if ( thePlayer.HasTag( 'scaar_dodge_vanilla' ) )
		{
			thePlayer.RemoveTag('scaar_dodge_vanilla');
		}
		else if ( thePlayer.HasTag( 'scaar_dodge_combine' ) )
		{
			thePlayer.RemoveTag('scaar_dodge_combine');
		}
		else if ( thePlayer.HasTag( 'scaar_dodge_intense' ) )
		{
			thePlayer.RemoveTag('scaar_dodge_intense');
		}
		else if ( thePlayer.HasTag( 'scaar_dodge_revolve' ) )
		{
			thePlayer.RemoveTag('scaar_dodge_revolve');
		}
		else if ( thePlayer.HasTag( 'scaar_dodge_technical' ) )
		{
			thePlayer.RemoveTag('scaar_dodge_technical');
		}
	}
	
	latent function RemoveLongDodgeTags()
	{
		if ( thePlayer.HasTag( 'scaar_longdodge_vanilla' ) )
		{
			thePlayer.RemoveTag('scaar_longdodge_vanilla');
		}
		else if ( thePlayer.HasTag( 'scaar_longdodge_combine' ) )
		{
			thePlayer.RemoveTag('scaar_longdodge_combine');
		}
		else if ( thePlayer.HasTag( 'scaar_longdodge_intense' ) )
		{
			thePlayer.RemoveTag('scaar_longdodge_intense');
		}
		else if ( thePlayer.HasTag( 'scaar_longdodge_revolve' ) )
		{
			thePlayer.RemoveTag('scaar_longdodge_revolve');
		}
		else if ( thePlayer.HasTag( 'scaar_longdodge_technical' ) )
		{
			thePlayer.RemoveTag('scaar_longdodge_technical');
		}
	}
	*/
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
state Interrupt in cSCAARTaunt
{
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SCAARInterruptFilter();
	}
	
	entry function SCAARInterruptFilter()
	{
		if ( !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& !thePlayer.isInFinisher
		&& !thePlayer.IsCiri() )
		{
			if ( parent.inTauntAnim == true )
			{
				ExitTaunt();
			}
			//else
			//{
				//return;
			//}
		}
	}
	
	function ExitTaunt()
	{
		
		if ( IsInLeftOrRightStance() == 'leftStance' )
		{
			PlayAnimation ( 'man_geralt_sword_parry_start_lp' );
		}
		else if ( IsInLeftOrRightStance() == 'rightStance' )
		{
			PlayAnimation ( 'man_geralt_sword_parry_start_rp' );
		}
	parent.inTauntAnim = false;
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
