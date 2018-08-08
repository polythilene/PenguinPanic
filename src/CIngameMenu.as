package  
{
	import flash.display.StageQuality;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CIngameMenu extends InGameMenu
	{
		
		public function CIngameMenu() 
		{
		}
		
		public function applyMusicVolume(value:Number):void
		{
			var rect:Rectangle = MusicSliderContainer.getRect(this);
			var m_volumeSliderRect:Rectangle = new Rectangle( rect.x + 10, 
													musicSliderButton.y,
													rect.width - 20, 0);
			musicSliderButton.x = m_volumeSliderRect.x + 
								  ( m_volumeSliderRect.width * 
								    SoundManager.getInstance().musicVolume );
		}
		
		public function applySFXVolume(value:Number):void
		{
			var rect:Rectangle = SFXSliderContainer.getRect(this);
			var m_sfxSliderRect:Rectangle = new Rectangle( rect.x + 10, 
												sfxSliderButton.y,
												rect.width - 20, 0);
			sfxSliderButton.x = m_sfxSliderRect.x + 
								( m_sfxSliderRect.width * 
								  SoundManager.getInstance().sfxVolume );
		}
		
		public function applyGraphicQuality(value:String):void
		{
			switch(value)
			{
				case StageQuality.LOW:
				case StageQuality.HIGH
				case StageQuality.HIGH
			}
			
		}
		
		public function applyParticle(value:Boolean):void
		{
			
		}
		
		public function applyFunFacts(value:Boolean):void
		{
			
		}
		
		
		
		
		
		
		
	}

}