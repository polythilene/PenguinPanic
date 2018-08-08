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
	public class GameSelectLevel extends CGameState
	{
		static private var m_instance:GameSelectLevel;
		
		/* buffers */
		private var m_levelSelect:LevelSelect;
		//private var m_musicChannel:CSoundObject;
		private var m_levelIcons:Array;
		
		public function GameSelectLevel(lock:SingletonLock) 
		{
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
			
			m_levelSelect = new LevelSelect();
			
			m_levelIcons = [];
			m_levelIcons.push(m_levelSelect.level01);
			m_levelIcons.push(m_levelSelect.level02);
			m_levelIcons.push(m_levelSelect.level03);
			m_levelIcons.push(m_levelSelect.level04);
			m_levelIcons.push(m_levelSelect.level05);
			m_levelIcons.push(m_levelSelect.level06);
			m_levelIcons.push(m_levelSelect.level07);
			m_levelIcons.push(m_levelSelect.level08);
			m_levelIcons.push(m_levelSelect.level09);
			m_levelIcons.push(m_levelSelect.level10);
			m_levelIcons.push(m_levelSelect.level11);
			m_levelIcons.push(m_levelSelect.level12);
			m_levelIcons.push(m_levelSelect.level13);
			m_levelIcons.push(m_levelSelect.level14);
			m_levelIcons.push(m_levelSelect.level15);
		}
		
		override public function enter(): void
		{
			m_owner.addChild(m_levelSelect);
			m_levelSelect.x = 320;
			m_levelSelect.y = 240;
			
			m_owner.mouseChildren = true;
			
			for ( var i:int = 0; i < 15; i++ )
			{
				var mc:MovieClip = MovieClip(m_levelIcons[i]); 
				
				registerEvents( mc );
			
				if ( !GameVars.freeRoamLevel[i] )
					mc.gotoAndStop(1);
				else	
					mc.gotoAndStop(2);
			}
			
			registerEvents( m_levelSelect.mainMenu );
			
			if( GameStateManager.getInstance().lastState == GameLoop.getInstance() )
				GameVars.menuMusic = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			
			//m_musicChannel = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
		}
		
		override public function exit(): void
		{
			//m_musicChannel.stop();
			
			for ( var i:int = 0; i < 15; i++ )
			{
				unregisterEvents( MovieClip(m_levelIcons[i]) );
			}
			
			unregisterEvents( m_levelSelect.mainMenu );
			
			m_owner.removeChild(m_levelSelect);
		}
		
		private function iconToLevel(mc:MovieClip):int
		{
			var level:int=0;
			while ( m_levelIcons[level] != mc )
			{
				level++;
			}
			
			return level;
		}
		
		private function registerEvents(mc:MovieClip):void
		{
			mc.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			mc.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			mc.addEventListener( MouseEvent.CLICK, onMouseClick );
		}
		
		private function unregisterEvents(mc:MovieClip):void
		{
			mc.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			mc.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			mc.removeEventListener( MouseEvent.CLICK, onMouseClick );
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_06");
			var mc:MovieClip = MovieClip(event.currentTarget);
			TweenMax.to(mc, 1, { glowFilter: { color:0x66CAFF, strength:2.5, alpha:1, blurX:10, blurY:10 }} );
		
			if ( mc != m_levelSelect.mainMenu && mc.currentFrame == 2 )
			{
				var xmldata:XML = LevelData.getInstance().getData();
				var distance:int = xmldata.children()[iconToLevel(mc)].misc.checkpoint.attribute("length");
				m_levelSelect.distance.htmlText = String(distance) + " FEET";
			}
		}
		
		
		
		private function onMouseOut(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			TweenMax.to(mc, 1, { glowFilter: { color:0x66CAFF, strength:0, alpha:1, blurX:0, blurY:0 }} );
			
			if( mc != m_levelSelect.mainMenu )
				m_levelSelect.distance.htmlText = "--- FEET";
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if ( mc == m_levelSelect.mainMenu )
			{
				mc.filters = null;
				GameStateManager.getInstance().setState( GameMenu.getInstance() );
			}
			else
			{
				if ( mc.currentFrame == 1 )
					SoundManager.getInstance().playSFX("upgrade_abort");
				else
				{
					GameVars.current_level = iconToLevel(mc);
					SoundManager.getInstance().playSFX("upgrade_click");
					mc.filters = null;
					GameStateManager.getInstance().setState( GameUpgrade.getInstance() );
				}
			}
		}
		
			
		static public function getInstance(): GameSelectLevel
		{
			if( m_instance == null ){
				m_instance = new GameSelectLevel( new SingletonLock() );
			}
			return m_instance;
		}
	}
}


class SingletonLock{}
