package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.media.SoundChannel;
	import flash.ui.Mouse;

	import gs.TweenMax;
	import gs.easing.Bounce;
	
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class GameHowToPlay extends CGameState
	{
		static private var m_instance:GameHowToPlay;
		
		/* buffers */
		private var m_howToPlayMenu:ScreenHowToPlay;
		
		public function GameHowToPlay(lock:SingletonLock) 
		{
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
		}
		
		override public function enter(): void
		{
			m_howToPlayMenu = new ScreenHowToPlay();
			stage.addChild(m_howToPlayMenu);
			
			m_howToPlayMenu.shoot.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			m_howToPlayMenu.shoot.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			m_howToPlayMenu.shoot.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			GameVars.menuBackground = m_howToPlayMenu.background;
			SeaManager.getInstance().changeSet(1);
			
			for( var i:int = 0; i < 5; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUBUBBLES, OpMath.randomRange( 0, 640 ), 480 );
				
			for( i = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUPENGUIN, OpMath.randomRange( 0, 640 ), 480 );	
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_05");
			TweenMax.to(MovieClip(event.currentTarget), 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:2.5 }} );
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			TweenMax.to(MovieClip(event.currentTarget), 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:0 }} );
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_06");
			GameStateManager.getInstance().setState( GameLoop.getInstance() );
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			SeaManager.getInstance().update(elapsedTime);
		}
		
		override public function exit(): void
		{
			//m_musicChannel.stop();
			GameVars.menuMusic.stop();
			SeaManager.getInstance().clear();
			
			stage.removeChild(m_howToPlayMenu);
			m_howToPlayMenu = null;
		}
			
		static public function getInstance(): GameHowToPlay
		{
			if( m_instance == null ){
				m_instance = new GameHowToPlay( new SingletonLock() );
			}
			return m_instance;
		}
	}
}


class SingletonLock{}
