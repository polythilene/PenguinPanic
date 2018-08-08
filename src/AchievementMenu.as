package  
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import gs.TweenMax;
	import gs.easing.Elastic;
	
	import com.shade.math.OpMath;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class AchievementMenu extends CGameState
	{
		static private var m_instance:AchievementMenu;
		
		private var m_achievementPage:AchievementPage;
		//private var m_musicChannel:CSoundObject;
		private var m_page:int;
		private var m_x:int;
		private var m_y:int;
		
		private var m_desc:Array;
		private var m_bonus:Array;
		
		public function AchievementMenu(lock:SingletonLock)  
		{ 
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
		}
		
		override public function enter():void 
		{
			m_achievementPage = new AchievementPage();
			stage.addChild(m_achievementPage);
			//m_musicChannel = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			
			m_page = 1;
			//m_achievementPage.buttonPrevious.gotoAndStop(2);
			m_achievementPage.buttonPrevious.visible = false;
			m_achievementPage.unlockCountText.htmlText = String(GameVars.countUnlock) + " of 23 UNLOCKED";
			
			/* register events */
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			registerButtonEvents(m_achievementPage.buttonNext);
			registerButtonEvents(m_achievementPage.buttonPrevious);
			registerButtonEvents(m_achievementPage.buttonMainMenu);
			
			registerButtonEvents(m_achievementPage.plater_1);
			registerButtonEvents(m_achievementPage.plater_2);
			registerButtonEvents(m_achievementPage.plater_3);
			registerButtonEvents(m_achievementPage.plater_4);
			registerButtonEvents(m_achievementPage.plater_5);
			registerButtonEvents(m_achievementPage.plater_6);
			registerButtonEvents(m_achievementPage.plater_7);
			registerButtonEvents(m_achievementPage.plater_8);
			
			m_achievementPage.plater_1.mouseChildren = false;
			m_achievementPage.plater_2.mouseChildren = false;
			m_achievementPage.plater_3.mouseChildren = false;
			m_achievementPage.plater_4.mouseChildren = false;
			m_achievementPage.plater_5.mouseChildren = false;
			m_achievementPage.plater_6.mouseChildren = false;
			m_achievementPage.plater_7.mouseChildren = false;
			m_achievementPage.plater_8.mouseChildren = false;
			
			m_achievementPage.tooltip.visible = false;
			
			/* descriptions */
			m_desc = new Array();
			m_desc[0] = new Array( "One penguin K.I.A.",
									"Reached checkpoint with 15 penguins survived.",
									"No penguins survived.",
									"5 Penguins died at a time.",
									"Avoid predator using panic ability.",
									"10x Avoid predators using panic ability.",
									"Avoid predator without panic ability.",
									"10x Avoid predators without panic ability." );
			m_desc[1] = new Array( "Got stung by jellyfish.",
									"10x Stung by jellyfishes.",
									"Reached checkpoint with only 1 penguin survived.",
									"5x Game Over.",
									"Reached checkpoint without surfing.",
									"No penguin died.",
									"Used panic ability 50 times.", 
									"20x Rapid stream surfing." );
			m_desc[2] = new Array( "50x Toxic bubbles hit.",
									"Successfully avoided all toxic bubbles in a level.",
									"20x got eaten by predators.",
									"20x New Game.",
									"A penguin collided with icicle.",
									"Completed all levels.",
									"10x Complete all levels.",
									"-" );
									
			/* bonus point */
			m_bonus = new Array();
			m_bonus[0] = new Array( "100", "1000", "100", "200", "200", "250", "300", "1000" );
			m_bonus[1] = new Array( "100", "300", "300", "100", "1000", "1000", "300", "300" );
			m_bonus[2] = new Array( "500", "1000", "100", "500", "100", "2000", "10000", "0" );
					
			showPageContent();
			
			GameVars.menuBackground = m_achievementPage.background;
			SeaManager.getInstance().changeSet(1);
			
			for( var i:int = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUBUBBLES, OpMath.randomRange( 0, 640 ), 480 );
				
			for( i = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUPENGUIN, OpMath.randomRange( 0, 640 ), 480 );	
		}
		
		private function registerButtonEvents(button:MovieClip):void
		{
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseHover);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			button.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function unregisterButtonEvents(button:MovieClip):void
		{
			button.removeEventListener(MouseEvent.MOUSE_OVER, mouseHover);
			button.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			button.removeEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			m_x = event.stageX;
			m_y = event.stageY;
			
			m_achievementPage.tooltip.x = m_x + 20;
			m_achievementPage.tooltip.y = m_y + 20;
		}
		
		private function mouseHover(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if( (mc == m_achievementPage.buttonPrevious && m_page > 1) ||
				(mc == m_achievementPage.buttonNext && m_page < 3) ||
				(mc == m_achievementPage.buttonMainMenu) )
			{
				TweenMax.to(mc, 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:2.5 }} );
				SoundManager.getInstance().playSFX("Water_05");
			}
			else
			{
				//m_achievementPage.tooltip.visible = true;
				/*m_achievementPage.tooltip.x = m_x + 20;
				m_achievementPage.tooltip.y = m_y + 20;*/
				setToolTipText( MovieClip(event.currentTarget) );
			}
		}
		
		private function mouseOut(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			if( (mc == m_achievementPage.buttonPrevious && m_page > 1) ||
				(mc == m_achievementPage.buttonNext && m_page < 3) ||
				(mc == m_achievementPage.buttonMainMenu) )
			{
				TweenMax.to(MovieClip(event.currentTarget), 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:0 }} );
			}
			else
			{
				m_achievementPage.tooltip.visible = false;
			}
		}
		
		private function setToolTipText(target:MovieClip):void
		{
			if ( target.currentFrame == 2 )
			{
				if ( target == m_achievementPage.plater_1 )	
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][0];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][0];
				}
				else if ( target == m_achievementPage.plater_2 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][1];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][1];
				}
				else if ( target == m_achievementPage.plater_3 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][2];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][2];
				}
				else if ( target == m_achievementPage.plater_4 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][3];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][3];
				}
				else if ( target == m_achievementPage.plater_5 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][4];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][4];
				}
				else if ( target == m_achievementPage.plater_6 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][5];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][5];
				}
				else if ( target == m_achievementPage.plater_7 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][6];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][6];
				}
				else if ( target == m_achievementPage.plater_8 )
				{
					m_achievementPage.tooltip.desc.htmlText = m_desc[m_page-1][7];
					m_achievementPage.tooltip.bonus.htmlText = m_bonus[m_page-1][7];
				}
				
				m_achievementPage.tooltip.visible = true;
			}
		}
		
		private function mouseClick(event:MouseEvent):void
		{
			
			if ( event.currentTarget == m_achievementPage.buttonMainMenu )
			{
				SoundManager.getInstance().playSFX("Water_06");
				GameStateManager.getInstance().setState( GameMenu.getInstance() );
			}
			else if( event.currentTarget == m_achievementPage.buttonPrevious && m_page > 1 )
			{
				SoundManager.getInstance().playSFX("Water_06");
				m_page--;
				//m_achievementPage.buttonNext.gotoAndStop(1);
				m_achievementPage.buttonNext.visible = true; // gotoAndStop(1);
				//if ( m_page == 1 ) m_achievementPage.buttonPrevious.gotoAndStop(2);
				if ( m_page == 1 ) 
				{
					m_achievementPage.buttonPrevious.visible = false;
					TweenMax.to(MovieClip(event.currentTarget), 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:0 }} );
				}
				
				showPageContent();
			}
			else if( event.currentTarget == m_achievementPage.buttonNext && m_page < 3 )
			{
				SoundManager.getInstance().playSFX("Water_06");
				m_page++;
				//m_achievementPage.buttonPrevious.gotoAndStop(1);
				m_achievementPage.buttonPrevious.visible = true;
				//if ( m_page == 3 ) m_achievementPage.buttonNext.gotoAndStop(2);
				if ( m_page == 3 ) 
				{
					m_achievementPage.buttonNext.visible = false;
					TweenMax.to(MovieClip(event.currentTarget), 0.5, { glowFilter: { color:0x66CAFF, alpha:1, blurX:5, blurY:5, strength:0 }} );
				}
				
				showPageContent();
			}
		}
		
		private function checkAchievementState(flag:Boolean, title:String, plater:MovieClip):void
		{
			if ( flag )
			{
				plater.gotoAndStop(2);
				plater.text.htmlText = title.toUpperCase();
			}
			else
			{
				plater.gotoAndStop(1);
				plater.text.htmlText = "Locked";
			}
		}
		
		private function showPageContent():void 
		{
			m_achievementPage.pageText.htmlText = String(m_page) + "/3";
			if ( m_page == 1 )
			{
				checkAchievementState( GameVars.achievementISeeDeadPenguinObtained, "I See Dead Penguin", m_achievementPage.plater_1 );
				checkAchievementState( GameVars.achievementNobodyLeftBehindObtained, "Leave No Bird Behind", m_achievementPage.plater_2 );
				checkAchievementState( GameVars.achievementNobodyLovesMeObtained, "Nobody Loves Me", m_achievementPage.plater_3 );
				checkAchievementState( GameVars.achievementMassSuicideObtained, "Mass Suicide", m_achievementPage.plater_4 );
				checkAchievementState( GameVars.achievementHahaYouCantGetMeObtained, "You Can't Get Me", m_achievementPage.plater_5 );
				checkAchievementState( GameVars.achievementEatMyTrailObtained, "Eat My Trail", m_achievementPage.plater_6 );
				checkAchievementState( GameVars.achievementWhoaThatWasCloseObtained, "Whoa!, That Was Close", m_achievementPage.plater_7 );
				checkAchievementState( GameVars.achievementIAmGooodObtained, "I...Am...Goooood!", m_achievementPage.plater_8 );
				m_achievementPage.plater_8.visible = true;
			}
			else if ( m_page == 2 )
			{
				checkAchievementState( GameVars.achievementElectrifiedObtained, "That Tingles", m_achievementPage.plater_1 );
				checkAchievementState( GameVars.achievementLetsDoItAgainObtained, "Let's Do That Again!", m_achievementPage.plater_2 );
				checkAchievementState( GameVars.achievementIllBeBackObtained, "I'll Be Back", m_achievementPage.plater_3 );
				checkAchievementState( GameVars.achievementBlameTheLeaderObtained, "Blame The Leader", m_achievementPage.plater_4 );
				checkAchievementState( GameVars.achievementSlowHeadObtained, "Slowhead", m_achievementPage.plater_5 );
				checkAchievementState( GameVars.achievementFlawlessObtained, "Flawless", m_achievementPage.plater_6 );
				checkAchievementState( GameVars.achievementTotalParanoidObtained, "Total Paranoid", m_achievementPage.plater_7 );
				checkAchievementState( GameVars.achievementSurfFreakObtained, "Surf Freak", m_achievementPage.plater_8 );
				m_achievementPage.plater_8.visible = true;
			}
			else if ( m_page == 3 )
			{
				checkAchievementState( GameVars.achievementToxifiedObtained, "Toxic Junkie", m_achievementPage.plater_1 );
				checkAchievementState( GameVars.achievementNoToxicObtained, "We Hate Toxic", m_achievementPage.plater_2 );
				checkAchievementState( GameVars.achievementPenguliciousObtained, "Pengulicious", m_achievementPage.plater_3 );
				checkAchievementState( GameVars.achievementHeartOfSteelObtained, "Heart of Steel", m_achievementPage.plater_4 );
				checkAchievementState( GameVars.achievementDidSomeoneOrderFrozenPenguinObtained, "Did Someone Order Frozen Penguin?", m_achievementPage.plater_5 );
				checkAchievementState( GameVars.achievementAllHailToTheLeaderObtained, "All Hail The Leader", m_achievementPage.plater_6 );
				checkAchievementState( GameVars.achievementFanboyObtained, "Fanboy", m_achievementPage.plater_7 );
				m_achievementPage.plater_8.visible = false;
			}
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			SeaManager.getInstance().update(elapsedTime);
		}
		
		override public function exit():void 
		{
			SeaManager.getInstance().clear();
			
			/* unregister events */
			unregisterButtonEvents(m_achievementPage.buttonNext);
			unregisterButtonEvents(m_achievementPage.buttonPrevious);
			unregisterButtonEvents(m_achievementPage.buttonMainMenu);
			
			unregisterButtonEvents(m_achievementPage.plater_1);
			unregisterButtonEvents(m_achievementPage.plater_2);
			unregisterButtonEvents(m_achievementPage.plater_3);
			unregisterButtonEvents(m_achievementPage.plater_4);
			unregisterButtonEvents(m_achievementPage.plater_5);
			unregisterButtonEvents(m_achievementPage.plater_6);
			unregisterButtonEvents(m_achievementPage.plater_7);
			unregisterButtonEvents(m_achievementPage.plater_8);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			//m_musicChannel.stop();
					
			stage.removeChild(m_achievementPage);
			m_achievementPage = null;
		}
		
		static public function getInstance(): AchievementMenu
		{
			if( m_instance == null ){
				m_instance = new AchievementMenu( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}