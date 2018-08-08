package  
{
	/* TODO: DEFINE INITIALIZATION WHEN WINDOW SHOWED */
	 
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.filters.GlowFilter;
	
	import gs.TweenMax;
	import gs.easing.Elastic;
	
	import com.shade.math.OpMath;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class GameOptions extends EventDispatcher
	{
		static private var m_instance:GameOptions;
		
		/* constants */
		static public const BEFORE_SHOW:String = "before_show";
		static public const AFTER_HIDE:String = "after_hide";
		
		/* buffers */
		private var m_inGameMenu:InGameMenu;
		private var m_dragTarget:MovieClip;
		private var m_volumeSliderRect:Rectangle;
		private var m_sfxSliderRect:Rectangle;
		private var m_dragging:Boolean;
		private var m_stage:Stage;
		private var m_glow:GlowFilter;
		private var m_showInstant:Boolean;
		
		public function GameOptions(lock:SingletonLock) 
		{ 
			initialize();
		}
		
		public function initialize():void
		{
			m_inGameMenu = new InGameMenu();	// in-game menu
			//m_inGameMenu.cacheAsBitmap = true;
			//m_inGameMenu.alpha = 0.8;
			
			var rect:Rectangle = m_inGameMenu.MusicSliderContainer.getRect(m_inGameMenu);
			m_volumeSliderRect = new Rectangle(	rect.x + 10, 
												m_inGameMenu.musicSliderButton.y,
												rect.width - 20, 0);
			m_inGameMenu.musicSliderButton.x = m_volumeSliderRect.x + 
											  ( m_volumeSliderRect.width * 
											    SoundManager.getInstance().musicVolume );
			
			rect = m_inGameMenu.SFXSliderContainer.getRect(m_inGameMenu);
			m_sfxSliderRect = new Rectangle( rect.x + 10, 
											 m_inGameMenu.sfxSliderButton.y,
											 rect.width - 20, 0);
			m_inGameMenu.sfxSliderButton.x = m_sfxSliderRect.x + 
											( m_sfxSliderRect.width * 
											  SoundManager.getInstance().sfxVolume );
											  
											  
			m_glow = new GlowFilter(0x66CAFF, 1, 3, 3, 2.5, 3);
											  
			m_inGameMenu.gfxLow.buttonMode = true;
			m_inGameMenu.gfxMed.buttonMode = true;
			m_inGameMenu.gfxHigh.buttonMode = true;
		}
		
		public function show(stage:Stage, instant:Boolean=false, instant_x:int = 320, instant_y:int = 240):void
		{
			TweenMax.killTweensOf(m_inGameMenu, true);
			
			dispatchEvent( new Event(BEFORE_SHOW) );
			
			m_stage = stage;
			m_stage.addChild(m_inGameMenu);

			m_dragTarget = null;
			m_dragging = false;
			m_showInstant = instant;
			
			m_inGameMenu.back.addEventListener(MouseEvent.MOUSE_OVER, backButtonHover);
			m_inGameMenu.back.addEventListener(MouseEvent.MOUSE_OUT, backButtonOut);
			m_inGameMenu.back.addEventListener(MouseEvent.CLICK, backButtonClick);
			
			applyParticleIngameMenuText();
			
			if (instant)
			{
				m_inGameMenu.x = instant_x;
				m_inGameMenu.y = instant_y;
				registerMenuHandler();
			}
			else
			{
				m_inGameMenu.x = 320;
				m_inGameMenu.y = -500;
				
				TweenMax.to( m_inGameMenu, 2, 
							{ 
								x:320, y:240, 
								ease:Elastic.easeOut,
								onComplete:function():void
								{
									registerMenuHandler();
								}
							} );
			}
		}
		
		private function registerMenuHandler():void
		{
			m_inGameMenu.musicSliderButton.addEventListener(MouseEvent.MOUSE_DOWN, inGameSliderDown);
			m_stage.addEventListener(MouseEvent.MOUSE_UP, inGameSliderUp);
			
			m_inGameMenu.sfxSliderButton.addEventListener(MouseEvent.MOUSE_DOWN, inGameSliderDown);
			m_stage.addEventListener(MouseEvent.MOUSE_UP, inGameSliderUp);
			
			m_inGameMenu.gfxLow.addEventListener(MouseEvent.CLICK, gfxSet);
			m_inGameMenu.gfxMed.addEventListener(MouseEvent.CLICK, gfxSet);
			m_inGameMenu.gfxHigh.addEventListener(MouseEvent.CLICK, gfxSet);
			
			m_inGameMenu.particleOn.addEventListener(MouseEvent.CLICK, particleSet);
			m_inGameMenu.particleOff.addEventListener(MouseEvent.CLICK, particleSet);
			
			m_inGameMenu.factsOn.addEventListener(MouseEvent.CLICK, factsSet);
			m_inGameMenu.factsOff.addEventListener(MouseEvent.CLICK, factsSet);
		}
		
		private function unregisterMenuHandler():void
		{
			m_inGameMenu.musicSliderButton.removeEventListener(MouseEvent.MOUSE_DOWN, inGameSliderDown);
			m_stage.removeEventListener(MouseEvent.MOUSE_UP, inGameSliderUp);
			
			m_inGameMenu.sfxSliderButton.removeEventListener(MouseEvent.MOUSE_DOWN, inGameSliderDown);
			m_stage.removeEventListener(MouseEvent.MOUSE_UP, inGameSliderUp);
					
			m_inGameMenu.gfxLow.removeEventListener(MouseEvent.CLICK, gfxSet);
			m_inGameMenu.gfxMed.removeEventListener(MouseEvent.CLICK, gfxSet);
			m_inGameMenu.gfxHigh.removeEventListener(MouseEvent.CLICK, gfxSet);
			
			m_inGameMenu.particleOn.removeEventListener(MouseEvent.CLICK, particleSet);
			m_inGameMenu.particleOff.removeEventListener(MouseEvent.CLICK, particleSet);
			
			m_inGameMenu.factsOn.removeEventListener(MouseEvent.CLICK, factsSet);
			m_inGameMenu.factsOff.removeEventListener(MouseEvent.CLICK, factsSet);
			
			m_inGameMenu.back.removeEventListener(MouseEvent.MOUSE_OVER, backButtonHover);
			m_inGameMenu.back.removeEventListener(MouseEvent.MOUSE_OUT, backButtonOut);
			m_inGameMenu.back.removeEventListener(MouseEvent.CLICK, backButtonClick);
		}
		
		public function hide():void
		{
			TweenMax.killTweensOf(m_inGameMenu, true);
			
			unregisterMenuHandler();
			
			if ( m_showInstant )
			{
				m_stage.removeChild(m_inGameMenu);
				dispatchEvent( new Event(AFTER_HIDE) );	
			}
			else
			{
				TweenMax.to( m_inGameMenu, 1.0, 
							{ 
								x:320, y:-500,
								ease:Elastic.easeIn,
								onComplete:function():void
								{
									m_stage.removeChild(m_inGameMenu);
									dispatchEvent( new Event(AFTER_HIDE) );	
								}
							} );
			}
		}
		
		private function backButtonHover(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_05");
			m_inGameMenu.back.scaleX = m_inGameMenu.back.scaleY = 1.1;
			m_inGameMenu.back.filters = [ m_glow ];
		}
		
		private function backButtonOut(event:MouseEvent):void
		{
			m_inGameMenu.back.scaleX = m_inGameMenu.back.scaleY = 1.0;
			m_inGameMenu.back.filters = null;
		}
		
		private function backButtonClick(event:MouseEvent):void
		{
			m_inGameMenu.back.scaleX = m_inGameMenu.back.scaleY = 1.0;
			m_inGameMenu.back.filters = null;
			SoundManager.getInstance().playSFX("Water_06");
			hide();
		}
		
		private function inGameSliderDown(event:MouseEvent):void
		{
			var boundRect:Rectangle = ( event.currentTarget == m_inGameMenu.musicSliderButton ) ?
										m_volumeSliderRect : m_sfxSliderRect;
			m_dragging = true;
			m_dragTarget = MovieClip(event.currentTarget);
			m_dragTarget.startDrag(true, boundRect);
		}
		
		private function inGameSliderUp(event:MouseEvent):void
		{
			if( m_dragging )
			{
				m_dragging = false;
				m_dragTarget.stopDrag();
				
				// calculate percentage 
				if (m_dragTarget == m_inGameMenu.musicSliderButton)
				{
					var max:Number = Math.round(m_volumeSliderRect.width);
					var value:Number = Math.max(m_dragTarget.x - Math.round(m_volumeSliderRect.x), 0);
					value = Math.min(value, max);
					
					//SoundManager.getInstance().musicVolume = OpMath.percentage(value, max);
				}
				else
				{
					max = Math.round(m_sfxSliderRect.width);
					value = Math.max( m_dragTarget.x - Math.round(m_sfxSliderRect.x), 0 );
					value = Math.min(value, max);
					
					//SoundManager.getInstance().sfxVolume = OpMath.percentage(value, max);
				}
				
				m_dragTarget = null;
			}
		}
		
		private function setMenuItemState(item:MovieClip, selected:Boolean):void
		{
			if (selected)
			{
				item.scaleX = item.scaleY = 1.1;
				item.filters = [ m_glow ];
			}
			else
			{
				item.scaleX = item.scaleY = 1.0;
				item.filters = null;
			}
		}
		
		private function gfxSet(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case m_inGameMenu.gfxLow:
					setMenuItemState(m_inGameMenu.gfxLow, true);
					setMenuItemState(m_inGameMenu.gfxMed, false);
					setMenuItemState(m_inGameMenu.gfxHigh, false);
					m_stage.quality = StageQuality.LOW;
					break;
				case m_inGameMenu.gfxMed:
					setMenuItemState(m_inGameMenu.gfxLow, false);
					setMenuItemState(m_inGameMenu.gfxMed, true);
					setMenuItemState(m_inGameMenu.gfxHigh, false);
					m_stage.quality = StageQuality.MEDIUM;
					break;	
				case m_inGameMenu.gfxHigh:
					setMenuItemState(m_inGameMenu.gfxLow, false);
					setMenuItemState(m_inGameMenu.gfxMed, false);
					setMenuItemState(m_inGameMenu.gfxHigh, true);
					m_stage.quality = StageQuality.HIGH;
					break;		
			}
		}
		
		private function applyParticleIngameMenuText():void
		{
			if (ParticleManager.getInstance().enable)
			{
				setMenuItemState( m_inGameMenu.particleOn, true );
				setMenuItemState( m_inGameMenu.particleOff, false );
			}
			else
			{
				setMenuItemState( m_inGameMenu.particleOn, false );
				setMenuItemState( m_inGameMenu.particleOff, true );
			}
		}
		
		private function particleSet(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case m_inGameMenu.particleOn:
						ParticleManager.getInstance().enable = true;
						break;
				case m_inGameMenu.particleOff:
						ParticleManager.getInstance().enable = false;
						break;		
			}
			applyParticleIngameMenuText();
		}
		
		private function factsSet(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case m_inGameMenu.factsOn:
						setMenuItemState( m_inGameMenu.factsOn, true );
						setMenuItemState( m_inGameMenu.factsOff, false );
						GameVars.enableFunFacts = true;
						break;
				case m_inGameMenu.factsOff:
						setMenuItemState( m_inGameMenu.factsOn, false );
						setMenuItemState( m_inGameMenu.factsOff, true );
						GameVars.enableFunFacts = false;
						break;
			}
		}
		
		static public function getInstance(): GameOptions
		{
			if( m_instance == null ){
				m_instance = new GameOptions( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}