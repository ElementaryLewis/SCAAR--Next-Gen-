exec function scaarapplysettings()
{
	if ( SCAAR_Enabled() )
	{
		SCAAR_Init_Attempt();
		SCAARSetSwitchWithState();
	}
}

exec function showvariable(num : int)
{
	if ( num <= 1 )
	theGame.GetGuiManager().ShowNotification( (int) thePlayer.GetBehaviorVariable( 'scaarDodges' ) );
	else if ( num <= 2 )
	theGame.GetGuiManager().ShowNotification( (int) thePlayer.GetBehaviorVariable( 'scaarCombatMovement' ) );
	else if ( num <= 3 )
	theGame.GetGuiManager().ShowNotification( (int) thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ) );
	else if ( num <= 4 )
	theGame.GetGuiManager().ShowNotification( (int) thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) );
	else
	return;
}

function SCAARApplySettingsOnAttack()
{
	if ( SCAAR_Enabled() )
	{
		SCAAR_Init_Attempt();
		ScaarSetSwitchWithAttack();
	}
}

function SCAARApplySettingsOnStateSwitch()
{
	if ( SCAAR_Enabled() )
	{
		SCAAR_Init_Attempt();
		SCAARSetSwitchWithState();
	}
	else
	{
		theGame.GetInGameConfigWrapper().SetVarValue('SCAARmodMain', 'SCAARmodEnabled', "true" );
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function SCAAR_Enabled(): bool 
{
  return theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARmodEnabled');
}

function SCAAR_Init_Attempt()
{
	if (!SCAAR_IsInitialized()) 
	{
      SCAAR_InitializeSettings();
    }
}

function SCAAR_IsInitialized(): bool 
{
  return theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARmodInit');
}

function SCAAR_InitializeSettings() 
{
  theGame.GetInGameConfigWrapper().ApplyGroupPreset('SCAARmodMain', 0);

  theGame.SaveUserSettings();
}

/*
function SCAAR_GetBehMode(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARmodBehMode'));
}

function SCAAR_GetVersionMode(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARmodVersionMode'));
}
*/

function SCAAR_GetDodgeSet(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARDodgeSet'));
}

function SCAAR_GetCombatMovementSet(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARCombatMovementSet'));
}

function SCAAR_GetCombatIdleSet(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARCombatIdleSet'));
}

function SCAAR_GetLongDodgeSet(): int 
{
  return StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('SCAARmodMain', 'SCAARLongDodgeSet'));
}

function SCAAR_BehGetDodgeSet(): int 
{
  return (int) thePlayer.GetBehaviorVariable( 'scaarDodges' );
}

function SCAAR_BehGetCombatMovementSet(): int
{
  return (int) thePlayer.GetBehaviorVariable( 'scaarCombatMovement' );
}

function SCAAR_BehGetCombatIdleSet(): int 
{
  return (int) thePlayer.GetBehaviorVariable( 'scaarCombatIdle' );
}

function SCAAR_BehGetLongDodgeSet(): int 
{
  return (int) thePlayer.GetBehaviorVariable( 'scaarLongDodges' );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function SCAARSetSwitchWithState()
{
	var vSCAARSetSwitchWithState : cSCAARSetSwitchWithState;
	vSCAARSetSwitchWithState = new cSCAARSetSwitchWithState in theGame;
	
	//if (SCAAR_Enabled())
	//{	
		vSCAARSetSwitchWithState.Engage();
	//}
}

statemachine class cSCAARSetSwitchWithState
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cSCAARSetSwitchWithState
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ScaarSwitchOnState();
	}
	
	/*entry function preSwitch()
	{
		if ( thePlayer.GetBehaviorVariable( 'scaarDodges' ) != 0
		&& thePlayer.GetBehaviorVariable( 'scaarDodges' ) != 1
		&& thePlayer.GetBehaviorVariable( 'scaarDodges' ) != 2
		&& thePlayer.GetBehaviorVariable( 'scaarDodges' ) != 3
		&& thePlayer.GetBehaviorVariable( 'scaarDodges' ) != 4 )
		{
			thePlayer.SetBehaviorVariable( 'scaarDodges', 0 );
			//theGame.GetInGameConfigWrapper().SetVarValue('SCAARmodMain', 'SCAARDodgeSet', 0 );
		}
		Sleep (0.25f);
		if ( thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ) != 0
		&& thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ) != 1 )
		{
			thePlayer.SetBehaviorVariable( 'scaarCombatIdle', 0 );
			//theGame.GetInGameConfigWrapper().SetVarValue('SCAARmodMain', 'SCAARCombatIdleSet', 0 );
		}
		Sleep (0.25f);
		if ( thePlayer.GetBehaviorVariable( 'scaarCombatMovement' ) != 0
		&& thePlayer.GetBehaviorVariable( 'scaarCombatMovement' ) != 1
		&& thePlayer.GetBehaviorVariable( 'scaarCombatMovement' ) != 2 )
		{
			thePlayer.SetBehaviorVariable( 'scaarCombatMovement', 0 );
			//theGame.GetInGameConfigWrapper().SetVarValue('SCAARmodMain', 'SCAARCombatMovementSet', 0 );
		}
		Sleep (0.25f);
		if ( thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) != 0
		&& thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) != 1
		&& thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) != 2
		&& thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) != 3
		&& thePlayer.GetBehaviorVariable( 'scaarLongDodges' ) != 4 )
		{
			thePlayer.GetBehaviorVariable( 'scaarLongDodges', 0 );
			//theGame.GetInGameConfigWrapper().SetVarValue('SCAARmodMain', 'SCAARLongDodgeSet', 0 );
		}
		Sleep (0.25f);
		ScaarSwitchOnState();
	}*/
	
	entry function ScaarSwitchOnState()
	{
		var DodgeSet, CombatIdle, CombatMovement, LongDodgeSet											:	int;
		var factScaarDodgeSet, factScaarCombatIdle, factScaarCombatMovement, factScaarLongDodgeSet		:	string;
		var CurrentOptions																				:	bool;
		var CachedOptions																				:	bool;
		var optionsChanged																				:	bool = HaveOptionsChanged();
		//DodgeSet = 0;
		//CombatIdle = 0;
		//CombatMovement = 0;
		//LongDodgeSet = 0;
		optionsChanged;
		Sleep(0.1f);
		if ( !optionsChanged )
		{
			//theGame.GetGuiManager().ShowNotification( optionsChanged ); //debug
			return;
		}
		//if ( //!theGame.IsDialogOrCutscenePlaying() 
		//&& !thePlayer.IsInNonGameplayCutscene() 
		//&& !thePlayer.IsInGameplayScene()
		//&& !thePlayer.IsSwimming()
		//&& !thePlayer.IsUsingHorse()
		//&& !thePlayer.IsUsingVehicle() 
		//&& !thePlayer.IsCiri() )
		//{
		
		else
		{
			//theGame.GetGuiManager().ShowNotification( optionsChanged ); //debug
			if ( SCAAR_GetCombatIdleSet() == 0 )
			{
				CombatIdle = 0;
				if ( !thePlayer.HasTag( 'scaar_1handed' ) )
				{	
					RemoveIdleTags();
					thePlayer.AddTag('scaar_1handed');
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', CombatIdle );
					//FactsAdd ( factScaarCombatIdle, thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ), -1 );
				}
				else if ( thePlayer.HasTag('scaar_1handed' ) && SCAAR_BehGetCombatIdleSet() != 0 )
				{
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', CombatIdle );
					//FactsAdd ( factScaarCombatIdle, thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ), -1 );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetCombatIdleSet() == 1 )
			{
				CombatIdle = 1;
				if ( !thePlayer.HasTag( 'scaar_2handed' ) )
				{	
					RemoveIdleTags();
					thePlayer.AddTag('scaar_2handed');
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', CombatIdle );
					//FactsAdd ( factScaarCombatIdle, thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ), -1 );
				}
				else if ( thePlayer.HasTag( 'scaar_2handed' ) && SCAAR_BehGetCombatIdleSet() != 1 )
				{
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', CombatIdle );
					//FactsAdd ( factScaarCombatIdle, thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ), -1 );
				}
				Sleep (0.1f);
			}
			FactsAdd ( factScaarCombatIdle, (int) thePlayer.GetBehaviorVariable( 'scaarCombatIdle' ), -1 );
			//else
			//{
				//RemoveIdleTags();
				//thePlayer.AddTag('scaar_1handed');
				//thePlayer.SetBehaviorVariable( 'scaarCombatIdle', 0 );
			//}
			if ( SCAAR_GetCombatMovementSet() == 0 )
			{
				CombatMovement = 0;
				if ( !thePlayer.HasTag( 'scaar_1handed_movement' ) )
				{
					RemoveMovementTags();
					thePlayer.AddTag('scaar_1handed_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				else if ( thePlayer.HasTag( 'scaar_1handed_movement' ) && SCAAR_BehGetCombatMovementSet() != 0 )
				{
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetCombatMovementSet() == 1 )
			{
				CombatMovement = 1;
				if ( !thePlayer.HasTag( 'scaar_hybrid_movement' ) )
				{
					RemoveMovementTags();
					thePlayer.AddTag('scaar_hybrid_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				else if ( thePlayer.HasTag( 'scaar_hybrid_movement' ) && SCAAR_BehGetCombatMovementSet() != 1 )
				{
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetCombatMovementSet() == 2 )
			{
				CombatMovement = 2;
				if ( !thePlayer.HasTag( 'scaar_2handed_movement' ) )
				{
					RemoveMovementTags();
					thePlayer.AddTag('scaar_2handed_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				else if ( thePlayer.HasTag( 'scaar_2handed_movement' ) && SCAAR_BehGetCombatMovementSet() != 2 )
				{
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', CombatMovement );
				}
				Sleep (0.1f);
			}
			FactsAdd ( factScaarCombatMovement, (int) thePlayer.GetBehaviorVariable( 'scaarCombatMovement' ), -1 );
			//else
			//{
				//RemoveMovementTags();
				//thePlayer.AddTag('scaar_1handed_movement');
				//thePlayer.SetBehaviorVariable( 'scaarCombatMovement', 0 );
			//}
			if ( SCAAR_GetDodgeSet() == 0 )
			{
				DodgeSet = 0;
				if ( !thePlayer.HasTag( 'scaar_dodge_vanilla' ) )
				{
					RemoveDodgeTags();
					thePlayer.AddTag('scaar_dodge_vanilla');
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_dodge_vanilla' ) && SCAAR_BehGetDodgeSet() != 0 )
				{
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetDodgeSet() == 1 )
			{
				DodgeSet = 1;
				if ( !thePlayer.HasTag( 'scaar_dodge_combine' ) )
				{
					RemoveDodgeTags();
					thePlayer.AddTag('scaar_dodge_combine');
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_dodge_combine' ) && SCAAR_BehGetDodgeSet() != 1 )
				{
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetDodgeSet() == 2 )
			{
				DodgeSet = 2;
				if ( !thePlayer.HasTag( 'scaar_dodge_intense' ) )
				{
					RemoveDodgeTags();
					thePlayer.AddTag('scaar_dodge_intense');
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_dodge_intense' ) && SCAAR_BehGetDodgeSet() != 2 )
				{
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetDodgeSet() == 3 )
			{
				DodgeSet = 3;
				if ( !thePlayer.HasTag( 'scaar_dodge_revolve' ) )
				{
					RemoveDodgeTags();
					thePlayer.AddTag('scaar_dodge_revolve');
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_dodge_revolve' ) && SCAAR_BehGetDodgeSet() != 3 )
				{
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetDodgeSet() == 4 )
			{
				DodgeSet = 4;
				if ( !thePlayer.HasTag( 'scaar_dodge_technical' ) )
				{
					RemoveDodgeTags();
					thePlayer.AddTag('scaar_dodge_technical');
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_dodge_technical' ) && SCAAR_BehGetDodgeSet() != 4 )
				{
					thePlayer.SetBehaviorVariable( 'scaarDodges', DodgeSet );
				}
				Sleep (0.1f);
			}
			FactsAdd ( factScaarDodgeSet, (int) thePlayer.GetBehaviorVariable( 'scaarDodges' ), -1 );
			//else
			//{
				//RemoveDodgeTags();
				//thePlayer.AddTag('scaar_dodge_technical');
				//thePlayer.SetBehaviorVariable( 'scaarDodges', 0 );
			//}
			if ( SCAAR_GetLongDodgeSet() == 0 )
			{
				LongDodgeSet = 0;
				if ( !thePlayer.HasTag( 'scaar_longdodge_vanilla' ) )
				{
					RemoveLongDodgeTags();
					thePlayer.AddTag('scaar_longdodge_vanilla');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_longdodge_vanilla' ) && SCAAR_BehGetLongDodgeSet() != 0 )
				{
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetLongDodgeSet() == 1 )
			{
				LongDodgeSet = 1;
				if ( !thePlayer.HasTag( 'scaar_longdodge_combine' ) )
				{
					RemoveLongDodgeTags();
					thePlayer.AddTag('scaar_longdodge_combine');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_longdodge_combine' ) && SCAAR_BehGetLongDodgeSet() != 1 )
				{
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetLongDodgeSet() == 2 )
			{
				LongDodgeSet = 2;
				if ( !thePlayer.HasTag( 'scaar_longdodge_intense' ) )
				{
					RemoveLongDodgeTags();
					thePlayer.AddTag('scaar_longdodge_intense');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_longdodge_intense' ) && SCAAR_BehGetLongDodgeSet() != 2 )
				{
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetLongDodgeSet() == 3 )
			{
				LongDodgeSet = 3;
				if ( !thePlayer.HasTag( 'scaar_longdodge_revolve' ) )
				{
					RemoveLongDodgeTags();
					thePlayer.AddTag('scaar_longdodge_revolve');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_longdodge_revolve' ) && SCAAR_BehGetLongDodgeSet() != 3 )
				{
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				Sleep (0.1f);
			}
			else if ( SCAAR_GetLongDodgeSet() == 4 )
			{
				LongDodgeSet = 4;
				if ( !thePlayer.HasTag( 'scaar_longdodge_technical' ) )
				{
					RemoveLongDodgeTags();
					thePlayer.AddTag('scaar_longdodge_technical');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				else if ( thePlayer.HasTag( 'scaar_longdodge_technical' ) && SCAAR_BehGetLongDodgeSet() != 4 )
				{
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', LongDodgeSet );
				}
				Sleep (0.1f);
			}
			FactsAdd ( factScaarLongDodgeSet, (int) thePlayer.GetBehaviorVariable( 'scaarLongDodges' ), -1 );
			//else
			//{
				//RemoveLongDodgeTags();
				//thePlayer.AddTag('scaar_longdodge_technical');
				//thePlayer.SetBehaviorVariable( 'scaarLongDodges', 0 );
			//}
		}
	}
	
	function HaveOptionsChanged() : bool
	{
		var currentDodges : int = SCAAR_GetDodgeSet();
		var currentLongDodges : int = SCAAR_GetLongDodgeSet();
		var currentCombatIdle : int = SCAAR_GetCombatIdleSet();
		var currentCombatMovement : int = SCAAR_GetCombatMovementSet();
		var cachedDodges : int = SCAAR_BehGetDodgeSet();
		var cachedLongDodges : int = SCAAR_BehGetLongDodgeSet();
		var cachedCombatIdle : int = SCAAR_BehGetCombatIdleSet();
		var cachedCombatMovement : int = SCAAR_BehGetCombatMovementSet();
		
		if ( currentDodges !=  cachedDodges ||  currentLongDodges !=  cachedLongDodges ||  currentCombatIdle !=  cachedCombatIdle ||  currentCombatMovement !=  cachedCombatMovement )
		{
			return true;
		}
		
		return false;
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
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ScaarSetSwitchWithAttack()
{
	var vScaarSetSwitchWithAttack : cScaarSetSwitchWithAttack;
	vScaarSetSwitchWithAttack = new cScaarSetSwitchWithAttack in theGame;
	
	if (SCAAR_Enabled())
	{	
		vScaarSetSwitchWithAttack.Engage();
	}
}

statemachine class cScaarSetSwitchWithAttack
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cScaarSetSwitchWithAttack
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ScaarSwitchOnAttack();
	}
	
	entry function ScaarSwitchOnAttack()
	{
		if ( !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle() 
		&& !thePlayer.IsCiri())
		{
			if ( SCAAR_GetCombatIdleSet() == 0 )
			{
				if ( !thePlayer.HasTag( 'scaar_1handed' ) )
				{	
					RemoveIdleTagsInAttack();
					thePlayer.AddTag('scaar_1handed');
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', 0 );
				}
			}
			else if ( SCAAR_GetCombatIdleSet() == 1 )
			{
				if ( !thePlayer.HasTag( 'scaar_2handed' ) )
				{	
					RemoveIdleTagsInAttack();
					thePlayer.AddTag('scaar_2handed');
					thePlayer.SetBehaviorVariable( 'scaarCombatIdle', 1 );
				}
			}
			if ( SCAAR_GetCombatMovementSet() == 0 )
			{
				if ( !thePlayer.HasTag( 'scaar_1handed_movement' ) )
				{
					RemoveMovementTagsInAttack();
					thePlayer.AddTag('scaar_1handed_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', 0 );
				}
			}
			else if ( SCAAR_GetCombatMovementSet() == 1 )
			{
				if ( !thePlayer.HasTag( 'scaar_hybrid_movement' ) )
				{
					RemoveMovementTagsInAttack();
					thePlayer.AddTag('scaar_hybrid_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', 1 );
				}
			}
			else if ( SCAAR_GetCombatMovementSet() == 2 )
			{
				if ( !thePlayer.HasTag( 'scaar_2handed_movement' ) )
				{
					RemoveMovementTagsInAttack();
					thePlayer.AddTag('scaar_2handed_movement');
					thePlayer.SetBehaviorVariable( 'scaarCombatMovement', 2 );
				}
			}
			if ( SCAAR_GetDodgeSet() == 0 )
			{
				if ( !thePlayer.HasTag( 'scaar_dodge_vanilla' ) )
				{
					RemoveDodgeTagsInAttack();
					thePlayer.AddTag('scaar_dodge_vanilla');
					thePlayer.SetBehaviorVariable( 'scaarDodges', 0 );
				}
			}
			else if ( SCAAR_GetDodgeSet() == 1 )
			{
				if ( !thePlayer.HasTag( 'scaar_dodge_combine' ) )
				{
					RemoveDodgeTagsInAttack();
					thePlayer.AddTag('scaar_dodge_combine');
					thePlayer.SetBehaviorVariable( 'scaarDodges', 1 );
				}
			}
			else if ( SCAAR_GetDodgeSet() == 2 )
			{
				if ( !thePlayer.HasTag( 'scaar_dodge_intense' ) )
				{
					RemoveDodgeTagsInAttack();
					thePlayer.AddTag('scaar_dodge_intense');
					thePlayer.SetBehaviorVariable( 'scaarDodges', 2 );
				}
			}
			else if ( SCAAR_GetDodgeSet() == 3 )
			{
				if ( !thePlayer.HasTag( 'scaar_dodge_revolve' ) )
				{
					RemoveDodgeTagsInAttack();
					thePlayer.AddTag('scaar_dodge_revolve');
					thePlayer.SetBehaviorVariable( 'scaarDodges', 3 );
				}
			}
			else if ( SCAAR_GetDodgeSet() == 4 )
			{
				if ( !thePlayer.HasTag( 'scaar_dodge_technical' ) )
				{
					RemoveDodgeTagsInAttack();
					thePlayer.AddTag('scaar_dodge_technical');
					thePlayer.SetBehaviorVariable( 'scaarDodges', 4 );
				}
			}
			if ( SCAAR_GetLongDodgeSet() == 0 )
			{
				if ( !thePlayer.HasTag( 'scaar_longdodge_vanilla' ) )
				{
					RemoveLongDodgeTagsInAttack();
					thePlayer.AddTag('scaar_longdodge_vanilla');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', 0 );
				}
			}
			else if ( SCAAR_GetLongDodgeSet() == 1 )
			{
				if ( !thePlayer.HasTag( 'scaar_longdodge_combine' ) )
				{
					RemoveLongDodgeTagsInAttack();
					thePlayer.AddTag('scaar_longdodge_combine');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', 1 );
				}
			}
			else if ( SCAAR_GetLongDodgeSet() == 2 )
			{
				if ( !thePlayer.HasTag( 'scaar_longdodge_intense' ) )
				{
					RemoveLongDodgeTagsInAttack();
					thePlayer.AddTag('scaar_longdodge_intense');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', 2 );
				}
			}
			else if ( SCAAR_GetLongDodgeSet() == 3 )
			{
				if ( !thePlayer.HasTag( 'scaar_longdodge_revolve' ) )
				{
					RemoveLongDodgeTagsInAttack();
					thePlayer.AddTag('scaar_longdodge_revolve');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', 3 );
				}
			}
			else if ( SCAAR_GetLongDodgeSet() == 4 )
			{
				if ( !thePlayer.HasTag( 'scaar_longdodge_technical' ) )
				{
					RemoveLongDodgeTagsInAttack();
					thePlayer.AddTag('scaar_longdodge_technical');
					thePlayer.SetBehaviorVariable( 'scaarLongDodges', 4 );
				}
			}
		}
	}
	
	latent function RemoveIdleTagsInAttack()
	{
		if ( thePlayer.HasTag( 'scaar_1handed' ) )
		{
			thePlayer.RemoveTag('scaar_1handed');
		}
		else if ( thePlayer.HasTag( 'scaar_2handed' ) )
		{
			thePlayer.RemoveTag('scaar_2handed');
		}
		if ( thePlayer.GetCurrentStateName() != 'Exploration') 
		{
			thePlayer.GotoState( 'Combat' );
		}
	}
	
	latent function RemoveMovementTagsInAttack()
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
		if ( thePlayer.GetCurrentStateName() != 'Exploration') 
		{
			thePlayer.GotoState( 'Combat' );
		}
	}
	
	latent function RemoveDodgeTagsInAttack()
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
		if ( thePlayer.GetCurrentStateName() != 'Exploration') 
		{
			thePlayer.GotoState( 'Combat' );
		}
	}
	
	latent function RemoveLongDodgeTagsInAttack()
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
		if ( thePlayer.GetCurrentStateName() != 'Exploration') 
		{
			thePlayer.GotoState( 'Combat' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}