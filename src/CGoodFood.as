package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CGoodFood extends CBaseFood
	{
		
		public function CGoodFood() 
		{
			
		}
		
		override public function eaten(eater:CBoid):void 
		{
			GameVars.currentScore += m_point * GameVars.powerUpPointMultiplier;
			
			/* show floating text */
			var text:String = "+" + String(m_point * GameVars.powerUpPointMultiplier);
			FloatingTextManager.getInstance().add( text, eater.getClip().x, eater.getClip().y, "#00FF33", 3000 );
			
			/* calculate stamina */
			if ( !SwarmManager.getInstance().isPanic() )
			{
				var stamina:int = m_point * 0.035; 
				GameVars.currentStamina += stamina;
				GameVars.currentStamina = Math.min(GameVars.currentStamina, GameVars.maxStamina);
				GameVars.refreshStaminaBar();
			}
			
			/* play sound */
			var dice:int = Math.floor( OpMath.randomNumber( 3 ) );
			switch( dice )
			{
				case 0: SoundManager.getInstance().playSFX( "Water_03" );
						break;
				case 1: SoundManager.getInstance().playSFX( "Water_05" );
						break;
				case 2: SoundManager.getInstance().playSFX( "Water_06" );
						break;		
			}
			
			FoodManager.getInstance().signalGoodFoodEatenEnd();
		}
	}
}