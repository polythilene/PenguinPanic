package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.media.SoundChannel;
		
	import gs.TweenMax;
	import gs.easing.Elastic;
	
	//import mochi.as3.*;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class GameMenu extends CGameState
	{
		static private var m_instance:GameMenu;
		
		/* buffers */
		private var m_mainMenuBG:MainMenuBG;
		private var m_mainMenu:MainMenu;
		private var m_snowEmitter:CBaseEmitter;
		//private var m_musicChannel:CSoundObject;
		private var m_creditsPlate:ScrollingCreditsPlate;
		private var m_creditsShown:Boolean;
		private var m_blur:BlurFilter;
		private var m_glow:GlowFilter;
		
		private var m_leaderBoardShown:Boolean = false;
		
		/* parameters */
		private var m_optionShown:Boolean;
		
		public function GameMenu(lock:SingletonLock) {}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
			
			m_mainMenu = new MainMenu();
			m_mainMenu.x = 513;
			//m_mainMenu.y = 240;
			m_mainMenu.y = 200;
			
			m_mainMenuBG = new MainMenuBG();
			m_mainMenuBG.x = m_mainMenuBG.y = 0;
			
			m_creditsPlate = new ScrollingCreditsPlate();
			m_creditsPlate.x = 350;
			m_creditsPlate.y = 240;
			m_creditsPlate.alpha = 0.85;
			
			m_blur = new BlurFilter(6, 6, 2);
			m_glow = new GlowFilter(0x66CAFF, 1, 3, 3, 2.5, 3);
			SoundManager.getInstance().addMusic( "MainMenu_01", new Sound_MainMenu() );
		}
		
		override public function enter(): void
		{
			addChild(m_mainMenuBG);
			
			ParticleManager.getInstance().attach(m_owner);
			m_snowEmitter = ParticleManager.getInstance().add(EMITTERTYPE.SNOW, 0, 0, 0);
			
			addChild(m_mainMenu);
			
			/* register events */
			registerMenuEvents();
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			m_owner.mouseChildren = true;
			m_optionShown = false;
			m_creditsShown = false;
			
			// play music
			//m_musicChannel = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			
			if( GameStateManager.getInstance().lastState != AchievementMenu.getInstance() &&
				GameStateManager.getInstance().lastState != GameUpgrade.getInstance() && 
				GameStateManager.getInstance().lastState != GameSelectLevel.getInstance() )
				GameVars.menuMusic = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			
				
				
			//MochiSocial.showLoginWidget({x:420, y:430});	
		}
		
		override public function exit(): void
		{
			//MochiSocial.hideLoginWidget();
			
			/* complete all tweens */
			TweenMax.killAllTweens(true);
			
			/* stop music */
			//m_musicChannel.stop();
			
			/* remove particle */
			m_snowEmitter.setDead();
				
			ParticleManager.getInstance().clear();
			ParticleManager.getInstance().detach();
			
			/* unregister events */
			unregisterMenuEvents();
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			removeChild(m_mainMenu);
			removeChild(m_mainMenuBG);
		}
		
		private function registerMenuEvents():void
		{
			m_mainMenu.newGame.buttonMode = m_mainMenu.newGame.useHandCursor = true;
			m_mainMenu.freeRoam.buttonMode = m_mainMenu.freeRoam.useHandCursor = true;
			m_mainMenu.options.buttonMode = m_mainMenu.options.useHandCursor = true;
			m_mainMenu.highScores.buttonMode = m_mainMenu.highScores.useHandCursor = true;
			m_mainMenu.achievements.buttonMode = m_mainMenu.achievements.useHandCursor = true;
			m_mainMenu.credits.buttonMode = m_mainMenu.credits.useHandCursor = true;
			
			m_mainMenu.newGame.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.options.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.highScores.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.achievements.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.credits.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			
			m_mainMenu.newGame.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.options.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.highScores.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.achievements.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.credits.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			
			m_mainMenu.newGame.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.options.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.highScores.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.achievements.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.credits.addEventListener(MouseEvent.CLICK, menuMouseClick);
			
			GameOptions.getInstance().addEventListener( GameOptions.AFTER_HIDE, afterMenuHidden );
		}
		
		private function unregisterMenuEvents():void
		{
			m_mainMenu.newGame.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.options.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.highScores.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.achievements.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_mainMenu.credits.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			
			m_mainMenu.newGame.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.options.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.highScores.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.achievements.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_mainMenu.credits.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			
			m_mainMenu.newGame.removeEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.freeRoam.addEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.options.removeEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.highScores.removeEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.achievements.removeEventListener(MouseEvent.CLICK, menuMouseClick);
			m_mainMenu.credits.removeEventListener(MouseEvent.CLICK, menuMouseClick);
			
			GameOptions.getInstance().removeEventListener( GameOptions.AFTER_HIDE, afterMenuHidden );
		}
		
		private function menuMouseClick(event:MouseEvent):void 
		{
			if( m_leaderBoardShown )
				return;
			
			SoundManager.getInstance().playSFX("Water_06");
			setMenuItemGlow( MovieClip(event.currentTarget), 0 );
			
			/* change game state */
			if ( event.currentTarget == m_mainMenu.newGame )
			{
				GameVars.reset();
				GameVars.gameMode = 0;
				GameStateManager.getInstance().setState( GameHowToPlay.getInstance() );
			}
			else if ( event.currentTarget == m_mainMenu.freeRoam )
			{
				GameVars.reset();
				GameVars.gameMode = 1;
				GameStateManager.getInstance().setState( GameSelectLevel.getInstance() );
			}
			else if ( event.currentTarget == m_mainMenu.options )
			{
				m_optionShown = true;
				m_mainMenu.visible = false;
				m_owner.filters = [m_glow];
				GameOptions.getInstance().show(stage);
			}
			else if ( event.currentTarget == m_mainMenu.achievements )
			{
				GameStateManager.getInstance().setState( AchievementMenu.getInstance() );
			}
			else if ( event.currentTarget == m_mainMenu.highScores )
			{
				/*
				MochiScores.showLeaderboard( {
												boardID: GameVars.getBoardId(), 
												res: "640x480", 
												onDisplay:function():void { showLeaderBoard(); },
												onClose:function():void { hideLeaderBoard(); } } );
				*/								
			}
			else if ( event.currentTarget == m_mainMenu.credits )
			{
				if ( GameVars.completeGameCounter > 0 )
				{
					GameStateManager.getInstance().setState( InGameCredits.getInstance() );
				}
				else
				{
					m_creditsShown = true;
					m_creditsPlate.y = 240;	
					stage.addChild(m_creditsPlate);
					m_creditsPlate.gotoAndPlay(2);
					m_creditsPlate.scroller.thankyou.visible = false;
					
					m_owner.filters = [m_glow];
					
					TweenMax.to(m_mainMenu, 1, { alpha:0, 
												 onComplete:function():void 
												 {
													m_mainMenu.visible = false;
												 }  
												} );
					
					TweenMax.to(m_blur, 2, 
										{ blurX:8, blurY:8, 
											onUpdate:function():void
											{
												m_owner.filters = [m_blur];
											} 
										} );
				}
			}
		}
		
		private function showLeaderBoard():void
		{
			m_leaderBoardShown = true;
			
			TweenMax.to(m_blur, 2, { blurX:8, blurY:8, 
									 onUpdate:function():void
									 {
										m_owner.filters = [m_blur];
									 } } );
			
		}
		
		private function hideLeaderBoard():void
		{
			m_leaderBoardShown = false;
			
			TweenMax.to(m_blur, 2, { blurX:0, blurY:0, 
									 onUpdate:function():void
									 {
										m_owner.filters = [m_blur];
									 } } );
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			/*if ( event.charCode == Keyboard.ESCAPE )
			{*/
				if ( m_creditsShown )
				{
					
					m_creditsShown = false; 
					m_owner.filters = null;
					m_mainMenu.visible = true;
					stage.removeChild(m_creditsPlate);
										
					TweenMax.to(m_mainMenu, 1, { alpha:1 } );
					TweenMax.to(m_blur, 2, {  blurX:0, blurY:0, 
												onUpdate:function():void
												{
													m_owner.filters = [m_blur];
												},
												onComplete:function():void 
												{
													m_owner.filters = null;
												} 
											} );
				}
			//}
		}
		
		private function afterMenuHidden(event:Event=null):void
		{
			m_optionShown = false;
			m_mainMenu.visible = true;
			m_owner.filters = null;
		}
		
		private function menuMouseHover(event:MouseEvent): void
		{
			if( m_leaderBoardShown ) return;
				
			SoundManager.getInstance().playSFX("Water_05");
			setMenuItemGlow( MovieClip(event.currentTarget), 2.5 );
		}
	
		private function menuMouseLeave(event:MouseEvent): void
		{
			setMenuItemGlow( MovieClip(event.currentTarget), 0 );
		}
		
		private function setMenuItemGlow(mc:MovieClip, value:Number):void
		{
			TweenMax.to(mc, 0.5, {glowFilter:{color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:value}});
		}
		
		static public function getInstance(): GameMenu
		{
			if( m_instance == null ){
				m_instance = new GameMenu( new SingletonLock() );
			}
			return m_instance;
		}
	}
}


class SingletonLock{}