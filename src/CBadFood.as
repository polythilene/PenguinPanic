package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CBadFood extends CBaseFood
	{
		
		public function CBadFood() 
		{
			
		}
		
		override public function eaten(eater:CBoid):void 
		{
			if ( !GameVars.powerUpInvincible )
			{
				GameVars.currentScore += m_point;
			
				/* show floating text */
				var text:String = String(m_point);
				FloatingTextManager.getInstance().add( text, eater.getClip().x, eater.getClip().y, "#FF0033", 3000 );
			}
			
			/* calculate stamina (upgrade only) */
			if ( !SwarmManager.getInstance().isPanic() && GameVars.upgradeImmunityObtained )
			{
				var stamina:int = Math.abs(m_point) * 0.035; 
				GameVars.currentStamina += stamina;
				GameVars.currentStamina = Math.min(GameVars.currentStamina, GameVars.maxStamina);
				GameVars.refreshStaminaBar();
			}
			
			/* play sound */
			var dice:int = Math.floor( OpMath.randomNumber( 3 ) );
			switch( dice )
			{
				case 0: SoundManager.getInstance().playSFX( "Water_01" );
						break;
				case 1: SoundManager.getInstance().playSFX( "Water_02" );
						break;
				case 2: SoundManager.getInstance().playSFX( "Water_04" );
						break;		
			}
			
			FoodManager.getInstance().signalBadFoodEatenEnd();
		}
	}
}