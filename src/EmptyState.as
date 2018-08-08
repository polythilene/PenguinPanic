package  
{
	import flash.display.DisplayObjectContainer;
/*	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.media.SoundChannel;*/
	
/*	import gs.TweenMax;
	import gs.easing.Bounce;*/
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class EmptyState extends CGameState
	{
		static private var m_instance:EmptyState;
		
		public function EmptyState(lock:SingletonLock) {}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
		}
		
		override public function enter(): void
		{
		}
		
		override public function exit(): void
		{
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			GameStateManager.getInstance().setState( GameMenu.getInstance() );
		}
		
		static public function getInstance(): EmptyState
		{
			if( m_instance == null ){
				m_instance = new EmptyState( new SingletonLock() );
			}
			return m_instance;
		}
	}
}


class SingletonLock{}