exec function movetype()
{
	//theGame.GetGuiManager().ShowNotification( (float) thePlayer.GetBehaviorVariable( 'playerMoveType' ) );
	theGame.GetGuiManager().ShowNotification( (int) thePlayer.playerMoveType );
}

exec function speed()
{
	var locomotion : CR4LocomotionPlayerControllerScript;
	var input : CPlayerInput;
	theGame.GetGuiManager().ShowNotification( (float) thePlayer.GetMovingAgentComponent().GetRelativeMoveSpeed() );
}

exec function cachedspeed()
{
	var locomotion : CR4LocomotionPlayerControllerScript;
	var input : CPlayerInput;
	//theGame.GetGuiManager().ShowNotification( (float) thePlayer.GetMovingAgentComponent().GetRelativeMoveSpeed() );
}