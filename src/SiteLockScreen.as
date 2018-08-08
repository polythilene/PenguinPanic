package  
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import com.shade.math.OpMath;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class SiteLockScreen extends CGameState
	{
		static private var m_instance:SiteLockScreen;
		
		private var m_sitelockMenu:SiteLockMenu;
		
		public function SiteLockScreen(lock:SingletonLock)  
		{ 
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
		}
		
		override public function enter():void 
		{
			m_sitelockMenu = new SiteLockMenu();
			stage.addChild(m_sitelockMenu);
			
			GameVars.menuBackground = m_sitelockMenu.background;
			SeaManager.getInstance().changeSet(1);
			
			for( var i:int = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUBUBBLES, OpMath.randomRange( 0, 640 ), 480 );
				
			for( i = 0; i < 5; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUPENGUIN, OpMath.randomRange( 0, 640 ), 480 );	
		}
		
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			SeaManager.getInstance().update(elapsedTime);
		}
		
		override public function exit():void 
		{
			SeaManager.getInstance().clear();
			
			stage.removeChild(m_sitelockMenu);
		}
		
		static public function getInstance(): SiteLockScreen
		{
			if( m_instance == null ){
				m_instance = new SiteLockScreen( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}