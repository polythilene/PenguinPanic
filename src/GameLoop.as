package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.filters.GlowFilter;
				
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	
	import gs.TweenMax;
	import gs.easing.Back;
	import gs.easing.Elastic;
	
	//import mochi.as3.*;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class GameLoop extends CGameState
	{
		static private var m_instance:GameLoop;
		
		static private const ENDGAME_DELAY:int = 4500;
		static private const SUBMIT_INGAME:int = 0;
		static private const SUBMIT_ENDGAME:int = 1;
	
		/* buffers */
		private var m_virtualCamera:VirtualCamera;
		private var m_funFacts:CFunFacts;
		private var m_musicChannel:CSoundObject;
		private var m_fpsCounter:FPSCounter;
		private var m_swarmAttractor:CSwarmAttractor;
		private var m_levelData:XML; 
		private var m_cursorPos:CPoint;
		private var m_attractorPos:CPoint;
		private var m_seaWater:DeepSea;
		private var m_GUI:Gameplay_UI;
		private var m_indicatorMultiplier:IndicatorMultiply;
		private var m_indicatorInvincible:IndicatorInvincible;
		private var m_scoreInfo:ScoreInfo;
		private var m_gameOverScreen:gameOverScreen;
		private var m_endGameTimer:Timer;
		private var m_inGamePause:InGamePauseMenu;
		private var m_glow:GlowFilter;
		private var m_submitDialog:SubmitScreen;
			
		/* parameters */
		private var m_cameraZoomedOut:Boolean;
		private var m_paused:Boolean;
		private var m_allowPauseToggle:Boolean;
		private var	m_countingScore:Boolean;
		private var m_countScoreDelay:int;
		private var m_countScoreState:int;
		private var m_totalScore:int;
		private var m_buffSurvivorCount:int;
		private var m_tempCareerScore:int;
		private var m_tempTotalXP:int;
		private var m_factsRevealed:Boolean;
		private var m_factAge:int;
		private var m_penguinStartCount:int;
		private var m_checkpointReached:Boolean;
		private var m_lastDeathTime:int;
		private var m_suicideCounter:int;
		private var m_surfed:Boolean;
		private var m_flawless:Boolean;
		private var m_intoxicated:Boolean;
		private var m_submitState:int;
		
		/* countdown */
		private var m_timeUp:Boolean;
		
		/* checkpoint */
		private var m_maxCheckpoint:Number;
		private var m_halfCheckpoint:Number;
		private var m_checkpoint:Number;
		private var m_checkpointModifier:Number;
		private var m_checkpointModifierNormal:Number;
		private var m_checkpointModifierStream:Number;
		
		
		public function GameLoop(lock:SingletonLock) 
		{
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
			
			/* register sound */
			SoundManager.getInstance().addMusic("InGame_01", new Sound_InGame_01());
						
			SoundManager.getInstance().addSFX( "Water_01", new Sound_Water_01() );
			SoundManager.getInstance().addSFX( "Water_02", new Sound_Water_02() );
			SoundManager.getInstance().addSFX( "Water_03", new Sound_Water_03() );
			SoundManager.getInstance().addSFX( "Water_04", new Sound_Water_04() );
			SoundManager.getInstance().addSFX( "Water_05", new Sound_Water_05() );
			SoundManager.getInstance().addSFX( "Water_06", new Sound_Water_06() );
			SoundManager.getInstance().addSFX( "Funny_01", new Sound_Funny_01() );
			SoundManager.getInstance().addSFX( "FunFacts", new Sound_FunFacts() );
			SoundManager.getInstance().addSFX( "Predator_Eat", new Sound_PredatorEat() );
			SoundManager.getInstance().addSFX( "Bubble_01", new Sound_Bubble01() );
			SoundManager.getInstance().addSFX( "Bubble_02", new Sound_Bubble02() );
			SoundManager.getInstance().addSFX( "Bubble_03", new Sound_Bubble03() );
			SoundManager.getInstance().addSFX( "Bubble_04", new Sound_Bubble04() );
			
			SoundManager.getInstance().addSFX( "Friend_Get", new friend_get() );
			SoundManager.getInstance().addSFX( "Friend_Alert", new friend_alert() );
			SoundManager.getInstance().addSFX( "JellyFishStung", new jellyfish_stung() );
			SoundManager.getInstance().addSFX( "Friend_Get", new friend_get() );
			SoundManager.getInstance().addSFX( "Crash_Generic", new nabrak_generic() );
			SoundManager.getInstance().addSFX( "Crash_Death1", new mati_ketabrak1() );
			SoundManager.getInstance().addSFX( "Crash_Death2", new mati_ketabrak2() );
			SoundManager.getInstance().addSFX( "Stream_Surf", new StreamSound() );
			SoundManager.getInstance().addSFX( "PowerGained", new PowerUpSound() );
			SoundManager.getInstance().addSFX( "AchievementObtained", new AchievementSound() );
			
						
			m_seaWater = new DeepSea();								// create water BG
			m_GUI = new Gameplay_UI();								// create ui
			m_scoreInfo = new ScoreInfo();							// score info
			m_gameOverScreen = new gameOverScreen();				// game over screen
			m_indicatorMultiplier = new IndicatorMultiply();		// power up indicator
			m_indicatorInvincible = new IndicatorInvincible();		// power up indicator
			m_cursorPos = new CPoint();								// mouse pos
			m_attractorPos = new CPoint();							// attractor pos	
			m_fpsCounter = new FPSCounter(10, 450);					// fps counter
			m_funFacts = new CFunFacts();							// fun facts
			m_swarmAttractor = new CSwarmAttractor();				// swarm attractor
			m_inGamePause = new InGamePauseMenu();					// in-game pause
			m_submitDialog = new SubmitScreen();					// submit score dialog
			
			m_seaWater.cacheAsBitmap = true;
			m_GUI.cacheAsBitmap = true;
			m_scoreInfo.cacheAsBitmap = true;
			m_gameOverScreen.cacheAsBitmap = true;
			
			GameVars.defaultAttractor = m_swarmAttractor;			// set shared object
			GameVars.cameraPos = new CPoint(320, 300);
			
			m_glow = new GlowFilter(0x66CAFF, 1, 3, 3, 2.5, 3);
			
			m_endGameTimer = new Timer(ENDGAME_DELAY, 1);
			
			GameVars.freeRoamLevel = [];
		}
		
		override public function enter(): void
		{
			/* read xml */
			loadLevelData();
			
			/* reset gamevars */
			GameVars.currentScore = 0;
			
			/* initiate stamina */
			GameVars.currentStamina = GameVars.maxStamina = GameVars.maximumStamina;
			GameVars.staminaIndicator =	m_GUI.staminaBar.indicator.indicatorMask;
			GameVars.refreshStaminaBar();
			
			/* init params */
			m_timeUp = false;
			m_checkpointModifier = m_checkpointModifierNormal = 0.01;
			m_checkpointModifierStream = m_checkpointModifierNormal * 2.0;
			m_factAge = 0;
			
			/* Sea Water */
			m_seaWater.cacheAsBitmap = true;
			addChild(m_seaWater);
			GameVars.seaWater = m_seaWater;
			m_seaWater.y = 0;
			
			/* Game UI */
			GameVars.gameUI = m_GUI;
			stage.addChild(m_GUI);
			m_GUI.x = 320;
			m_GUI.y = 240;
			m_GUI.visible = true;
			Gameplay_UI(m_GUI).gameMessage.alpha = 0;
			
			/* Score Info */
			m_scoreInfo.x = 320;
			m_scoreInfo.y = 240;
			
			/* Game Over UI */
			m_gameOverScreen.x = 328;
			m_gameOverScreen.y = 222;
			
			/* In-Game Pause */
			stage.addChild( m_inGamePause );
			m_inGamePause.x = 320;
			m_inGamePause.y = -1000;
			//m_inGamePause.alpha = 0.8;
			m_inGamePause.visible = false;
			registerPauseEventHandlers();
			
			/* Powerup Indicator */
			/*
			stage.addChild( m_indicatorMultiplier );
			m_indicatorMultiplier.x = 562;
			m_indicatorMultiplier.y = 445;
			*/
			m_GUI.addChild( m_indicatorMultiplier );
			m_indicatorMultiplier.x = 243;
			m_indicatorMultiplier.y = -154;
			m_indicatorMultiplier.visible = false;
			
			/*
			stage.addChild( m_indicatorInvincible );
			m_indicatorInvincible.x = 603;
			m_indicatorInvincible.y = 445;
			*/
			m_GUI.addChild( m_indicatorInvincible );
			m_indicatorInvincible.x = 284;
			m_indicatorInvincible.y = -154;
			m_indicatorInvincible.visible = false;
			
			/* create camera */
			m_virtualCamera = new VirtualCamera();
			m_virtualCamera.width = 640;
			m_virtualCamera.height = 480;
			addChild(m_virtualCamera);
				
			/* create attractor and mouse pos */
			m_attractorPos.x = m_virtualCamera.x = GameVars.cameraPos.x = 320;
			m_attractorPos.y = m_virtualCamera.y = GameVars.cameraPos.y = 600;
			
			/* init particle manager */
			ParticleManager.getInstance().attach(m_owner);
			
			/* setup camera scroll */
			GameVars.currCameraScrollSpeed = GameVars.normalCameraScrollSpeed = 0.2;
			GameVars.streamCameraScrollSpeed = GameVars.normalCameraScrollSpeed * 1.55;
			
			/* event listeners */
			stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
						
			/* custom event listeners */
			SwarmManager.getInstance().addEventListener( SwarmManager.RAPID_STREAM, hitStream );
			SwarmManager.getInstance().addEventListener( SwarmManager.BOID_ADDED, boidAdded );
			SwarmManager.getInstance().addEventListener( SwarmManager.BOID_REMOVED, boidDied );
			FoodManager.getInstance().addEventListener( FoodManager.POWERUP_START, powerUpStart );
			FoodManager.getInstance().addEventListener( FoodManager.POWERUP_END, powerUpEnd );
			FoodManager.getInstance().addEventListener( FoodManager.BAD_FOOD_EATEN, toxicEaten );
			
			/* fps counter */
			//stage.addChild( m_fpsCounter );
			
			/* play in-game sound */
			m_musicChannel = SoundManager.getInstance().playMusic("InGame_01", 1000);
			
			/* init vars */
			m_allowPauseToggle = true;
			m_paused = false;
			m_countingScore = false;
			m_countScoreDelay = 0;
			m_countScoreState = 0;
			m_factsRevealed = false;
			m_GUI.funFacts.alpha = 0;
			m_checkpointReached = false;
			m_tempCareerScore = GameVars.careerScore;
			m_tempTotalXP = GameVars.totalXP;
			m_lastDeathTime = getTimer();
			m_surfed = false;
			m_flawless = true;
			m_intoxicated = false;
			SeaManager.getInstance().changeSet(0);
			
			stage.mouseChildren = false;
			GameVars.gameOver = false;
			m_GUI.messageOfAct.x = 1500;
			m_GUI.achievement.x = 1500;
			
			FoodManager.getInstance().reset();
			PredatorManager.getInstance().reset();
			m_endGameTimer.reset();
			
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.CLICK, resignButtonClick);
			
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.CLICK, resignButtonClick);
			
			GameVars.freeRoamLevel[GameVars.current_level] = true;	// unlock free roam level
			
			play();
		}
		
		private function play(): void
		{
			/* achievement */
			if( GameVars.current_level == 0 && GameVars.gameMode == 0 )
			{
				GameVars.careerScore = GameVars.achievementPermanentPoint;	// set permanent point
				GameVars.newGameCounter++;
				
				if( GameVars.newGameCounter == 20 &&
					!GameVars.achievementHeartOfSteelObtained )
				{
					GameVars.achievementHeartOfSteelObtained = true;
					GameLoop.getInstance().showAchievement( "Heart of Steel.", "20x New Game.", 500 );
				}
			}	
			
			/* save serializer */
			//Serializer.getInstance().saveData();
			
			/* create flock */
			var pos:CPoint = new CPoint();
			
			for (var i:int = 0; i < m_penguinStartCount; i++)
			{
				pos.x = GameVars.cameraPos.x-700;
				pos.y = Math.floor( GameVars.cameraPos.y + OpMath.randomRange(-400, 400) );
				
				SwarmManager.getInstance().add(BOIDTYPE.PENGUIN, pos, m_swarmAttractor);
			}
			
			/* show act message */
			TweenMax.to( m_GUI.messageOfAct, 1, 
							{ x:0, ease:Back.easeOut,
								onComplete:function():void 
								{
									TweenMax.to( m_GUI.messageOfAct, 3, 
													{ onComplete:function():void
														{
																TweenMax.to( m_GUI.messageOfAct, 1, { x: -500, ease:Back.easeIn } );
														}
													}
												)
								} 
							} );
		}
		
		private function mouseMoveHandler(event:MouseEvent):void 
		{
	       m_cursorPos.x = event.stageX;
		   m_cursorPos.y = event.stageY; 
		}
		
		private function pause():void
		{
			GameOptions.getInstance().addEventListener( GameOptions.AFTER_HIDE, afterGameOptionsHidden );
			
			stage.mouseChildren = true;
			m_paused = true;
			m_GUI.visible = false;
			m_inGamePause.visible = true;
			TweenMax.to( m_inGamePause, 2, { y:220, ease:Elastic.easeOut } );
		}
		
		private function unpause():void
		{
			GameOptions.getInstance().removeEventListener( GameOptions.AFTER_HIDE, afterGameOptionsHidden );
			
			TweenMax.killTweensOf(m_inGamePause);
			TweenMax.to( m_inGamePause, 2, { y: -1000, ease:Elastic.easeIn, 
												onComplete:function():void
												{
													afterInGameMenuHidden();
												}  
											} );
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if ( event.keyCode == Keyboard.ESCAPE && m_allowPauseToggle )
			{
				TweenMax.killTweensOf(m_virtualCamera);
				
				if( !m_paused )
				{
					pause();
				}
				else
				{
					unpause();
				}
			}
			else if ( event.keyCode == 77 )
			{
				switch(SoundManager.getInstance().musicEnable)
				{
					case true:
							SoundManager.getInstance().musicEnable = false;		
							m_musicChannel.stop();
							Gameplay_UI(m_GUI).gameMessage.text.htmlText = "Music Disabled";
							
							break;
					case false:
							SoundManager.getInstance().musicEnable = true;		
							m_musicChannel = SoundManager.getInstance().playMusic("InGame_01", 1000);
							Gameplay_UI(m_GUI).gameMessage.text.htmlText = "Music Enabled";
							break;
				}
				
				Gameplay_UI(m_GUI).gameMessage.alpha = 1;
				TweenMax.killTweensOf( Gameplay_UI(m_GUI).gameMessage );
				TweenMax.to( Gameplay_UI(m_GUI).gameMessage, 5, { alpha:0 } );
			}
			else if ( event.keyCode == 80 )
			{
				ParticleManager.getInstance().toggleParticle();
								
				switch( ParticleManager.getInstance().enable )
				{
					case true: Gameplay_UI(m_GUI).gameMessage.text.htmlText = "Particle Enabled"; break;
					case false: Gameplay_UI(m_GUI).gameMessage.text.htmlText = "Particle Disabled"; break;
				}
				
				Gameplay_UI(m_GUI).gameMessage.alpha = 1;
				TweenMax.killTweensOf( Gameplay_UI(m_GUI).gameMessage );
				TweenMax.to( Gameplay_UI(m_GUI).gameMessage, 5, { alpha:0 } );
			}
		}
		
		private function afterInGameMenuHidden():void
		{
			m_GUI.visible = true;
			m_inGamePause.visible = false;
			stage.mouseChildren = false;
			stage.focus = m_owner;
			m_paused = false;
		}
		
		private function mouseClickHandler(event:MouseEvent):void 
		{
			if ( !m_cameraZoomedOut && !m_paused && GameVars.upgradeFarsightObtained )
			{
				TweenMax.killTweensOf(m_virtualCamera);			
				TweenMax.to(m_virtualCamera, 2, { scaleX:1.5, scaleY:1.5 } );
				
				TweenMax.killTweensOf(GameVars.seaWater);
				TweenMax.to(GameVars.seaWater, 2, { scaleX:1.5 } );
				
				m_cameraZoomedOut = true;
			}
			
			/* skipping score count */
			if ( m_countingScore )
			{
				if ( m_countScoreState == 0 )
				{
					m_totalScore += GameVars.currentScore;
					m_tempCareerScore += GameVars.currentScore;
					GameVars.currentScore = 0;
					
					m_scoreInfo.score.textPointAchieved.htmlText = "0";	
					m_countScoreState = 1;
				}
				else if ( m_countScoreState == 1 )
				{
					var score:int = (GameVars.minute * 60 * 10) + (GameVars.second * 10);
					m_totalScore += score;
					m_tempCareerScore += score;
					
					GameVars.minute = GameVars.second = 0;
					m_scoreInfo.score.textTimeRemaining.htmlText = "0\"0\'";
					m_buffSurvivorCount = SwarmManager.getInstance().getCount();
					
					m_countScoreState = 2;
				}
				
				m_scoreInfo.score.textTotalPoints.htmlText = String(m_totalScore);
				m_scoreInfo.score.textCareerPoints.htmlText = String(m_tempCareerScore);
			}
			
			// PANIC
			if ( GameVars.upgradePanicObtained )
			{
				SwarmManager.getInstance().signalPanic();	// signal the flock to avoid nearby predator
			}
		}
		
		private function boidAdded(event:SwarmEvent):void
		{
			Gameplay_UI(m_GUI).survivorText.text.htmlText = String( SwarmManager.getInstance().getCount() );
		}
		
		private function boidDied(event:SwarmEvent):void
		{
			GameVars.deadCounter++;
			m_flawless = false;
						
			Gameplay_UI(m_GUI).survivorText.text.htmlText = String( SwarmManager.getInstance().getCount() );
			
			/* I see dead penguin */
			
			if ( !GameVars.achievementISeeDeadPenguinObtained && GameVars.gameMode == 0 )
			{
				GameVars.achievementISeeDeadPenguinObtained = true;
				showAchievement("I See Dead Penguin", "One Penguin K.I.A.", 100);
			}
			
			/*  mass suicide counter*/
			if ( !GameVars.achievementMassSuicideObtained )
			{
				var currTime:int = getTimer();
				if ( currTime - m_lastDeathTime < 1000 )
				{
					m_suicideCounter++;
					if( m_suicideCounter >= 5 && GameVars.gameMode == 0 )
					{
						GameVars.achievementMassSuicideObtained = true;
						showAchievement("Mass Suicide.", "5 Penguins Died at a Time.", 200);
					}
				}
				else 
				{
					m_suicideCounter = 0;	
				}
				m_lastDeathTime = currTime;
			}
			
			/* no pengu left */
			if ( SwarmManager.getInstance().getCount() == 0 )
			{
				if( !GameVars.achievementNobodyLovesMeObtained && 
					getTimer() - m_lastDeathTime > 3000 && 
					GameVars.gameMode == 0 )
				{
					GameVars.achievementNobodyLovesMeObtained = true;
					showAchievement("Nobody Loves Me.", "No Penguins Survived.", 100);
				}
				
				GameVars.gameOverCounter++;
				if( GameVars.gameOverCounter == 5 &&
					!GameVars.achievementBlameTheLeaderObtained &&
					GameVars.gameMode == 0 )
				{
					GameVars.achievementBlameTheLeaderObtained = true;
					showAchievement("Blame The Leader.", "5x Game Over.", 100);
				}
				
				m_endGameTimer.addEventListener(TimerEvent.TIMER, gameOver);
				m_endGameTimer.start();
			}
			
			
		}
		
		public function showAchievement(title:String, desc:String, bonus:int):void
		{
			trace("Achievement Obtained:", title);
			TweenMax.killTweensOf( m_GUI.achievement, true );
			
			m_GUI.achievement.titleText.htmlText = "Achievement: " + title;
			m_GUI.achievement.descText.htmlText = desc;
			m_GUI.achievement.bonusText.htmlText = "Bonus +" + String(bonus);
			GameVars.achievementPermanentPoint += bonus;
			GameVars.achievementPermanentXP += 250;
			GameVars.currentScore += bonus;
			GameVars.countUnlock++;
			SoundManager.getInstance().playSFX( "AchievementObtained" );
			
			
			m_GUI.achievement.x = 1500;
			TweenMax.to( m_GUI.achievement, 1, 
							{ x:0, ease:Back.easeOut,
								onComplete:function():void 
								{
									TweenMax.to( m_GUI.achievement, 2, 
													{ onComplete:function():void
														{
																TweenMax.to( m_GUI.achievement, 1, { x: -1500, ease:Back.easeIn } );
														}
													}
												)
								} 
							} );
		}
		
		public function powerUpStart( event: PowerUpEvent ): void
		{
			switch( event.powerup )
			{
				case FOODTYPE.POWERUP_POINT_X3:		m_indicatorMultiplier.visible = true; break;
				case FOODTYPE.POWERUP_INVINCIBLE:	m_indicatorInvincible.visible = true; break;
			}
		}
		
		public function powerUpEnd( event: PowerUpEvent ): void
		{
			switch( event.powerup )
			{
				case FOODTYPE.POWERUP_POINT_X3:		m_indicatorMultiplier.visible = false; break;
				case FOODTYPE.POWERUP_INVINCIBLE:	m_indicatorInvincible.visible = false; break;
			}
		}
		
		public function hitStream(event: SwarmEvent ): void
		{
			m_surfed = true;
			GameVars.onStream = true;
			GameVars.currCameraScrollSpeed = GameVars.streamCameraScrollSpeed;
			
			m_checkpointModifier = m_checkpointModifierStream;
			
			TweenMax.killTweensOf(this);			
			TweenMax.to( this, event.lifeTime / 1000, 
						 { onComplete:function():void 
							{ 
								GameVars.currCameraScrollSpeed = GameVars.normalCameraScrollSpeed;
								GameVars.onStream = false;
								
								m_checkpointModifier = m_checkpointModifierNormal;
							} 
						} );
		}
		
		override public function update(elapsedTime:int):void 
		{
			if( !m_paused )
			{
				/* update countdown and checkpoint*/
				if( !m_checkpointReached && !m_timeUp )
				{
					updateTimer(elapsedTime);
					if ( m_checkpoint > 0 ) 
						updateCheckpoint(elapsedTime);
				}
				
				
				/* update camera state */
				if ( m_cameraZoomedOut && !SwarmManager.getInstance().isPanic() )
				{
					m_cameraZoomedOut = false;
					TweenMax.killTweensOf(m_virtualCamera);			
					TweenMax.to(m_virtualCamera, 2, { scaleX:1, scaleY:1 } );
					
					TweenMax.killTweensOf(GameVars.seaWater);
					TweenMax.to(GameVars.seaWater, 2, { scaleX:1 } );
				}
				
				/* translate camera horizontally */
				GameVars.cameraPos.x += GameVars.currCameraScrollSpeed * elapsedTime * GameVars.speedMultiplier;
				
				var cameraHalfWidth:int = m_virtualCamera.width >> 1;
				var cameraHalfHeight:int = m_virtualCamera.height >> 1;
				
				/* translate camera vertically */
				if ( m_cursorPos.y < 100 && GameVars.cameraPos.y > 240 )			
				{
					GameVars.scrollingUp = true;
					GameVars.cameraPos.y -= elapsedTime * 0.25;
				}
				else if ( m_cursorPos.y > 380 && GameVars.cameraPos.y < 960 )		
				{
					GameVars.scrollingDown = true;
					GameVars.cameraPos.y += elapsedTime * 0.25;
				}
				else
				{
					GameVars.scrollingDown = false;
					GameVars.scrollingUp = false;
				}
							
				m_seaWater.x = m_virtualCamera.x = GameVars.cameraPos.x;
				
				/* clip y */
				if ( GameVars.cameraPos.y < cameraHalfHeight + 20 )
					GameVars.cameraPos.y = cameraHalfHeight + 20;
				else if	( GameVars.cameraPos.y > m_seaWater.height - cameraHalfHeight - 20 )
					GameVars.cameraPos.y = m_seaWater.height - cameraHalfHeight - 20;
									
				m_virtualCamera.y = GameVars.cameraPos.y;
				
				/* translate attractor relative to camera coords */
				if ( !GameVars.gameOver )
				{
					m_attractorPos.x = GameVars.cameraPos.x - cameraHalfWidth + m_cursorPos.x;
					m_attractorPos.y = GameVars.cameraPos.y - cameraHalfHeight + m_cursorPos.y;
				}
				else
				{
					m_attractorPos.x = GameVars.cameraPos.x + 1000;
					m_attractorPos.y = GameVars.cameraPos.y;
				}
				
				m_swarmAttractor.setPosition(m_attractorPos);
				
				Gameplay_UI(m_GUI).score.htmlText = "SCORE: " + String(GameVars.currentScore);
			
				SwarmManager.getInstance().update(elapsedTime);
				ParticleManager.getInstance().update(elapsedTime);
				SeaManager.getInstance().update(elapsedTime);
				FoodManager.getInstance().update(elapsedTime);
				PredatorManager.getInstance().update(elapsedTime);
				FloatingTextManager.getInstance().update(elapsedTime);
			}
			else
			{
				TweenMax.killTweensOf(m_virtualCamera);	
				
				if ( GameVars.cameraPos.y < cameraHalfHeight + 20 )
					GameVars.cameraPos.y = cameraHalfHeight + 20;
				else if	( GameVars.cameraPos.y > m_seaWater.height - cameraHalfHeight - 20 )
					GameVars.cameraPos.y = m_seaWater.height - cameraHalfHeight - 20;
				
				m_virtualCamera.y = GameVars.cameraPos.y;	
			}
			
			
			/* point counter */
			if( m_countingScore )
			{
				countScore(elapsedTime);
			}
		}
		
		private function updateTimer(elapsedTime:int):void
		{
			GameVars.millisecond -= elapsedTime;
			
			if( GameVars.millisecond <= 0 )
			{
				GameVars.millisecond = 999;
				GameVars.second--;
				
				if ( GameVars.minute == 0 && GameVars.second == 0 )
				{
					/* achievement */
					GameVars.gameOverCounter++;
					if( GameVars.gameOverCounter == 5 &&
						!GameVars.achievementBlameTheLeaderObtained &&
						GameVars.gameMode == 0 )
					{
						GameVars.achievementBlameTheLeaderObtained = true;
						showAchievement("Blame The Leader.", "5x Game Over.", 100);
					}
					
					
					/* message */
					Gameplay_UI(m_GUI).timer.htmlText = "TIME IS UP!";
					m_timeUp = true;
					m_endGameTimer.addEventListener(TimerEvent.TIMER, gameOver);
					m_endGameTimer.start();
					return;
				}
			}
			
			if( GameVars.second <= 0 && GameVars.minute > 0)
			{
				GameVars.second = 59;
				GameVars.minute--;
			}
			
			var sec_str:String = String(GameVars.second);
			if ( sec_str.length == 1 )
				sec_str = "0" + String(GameVars.second);
				
			Gameplay_UI(m_GUI).timer.htmlText = "COUNTDOWN: " + String(GameVars.minute) + "\'" + sec_str + "\"";
		}
		
		private function updateCheckpoint(elapsedTime:int):void
		{
			if (m_checkpoint > 0)
			{
				m_checkpoint -= m_checkpointModifier * elapsedTime;
				m_checkpoint = Math.max(0, Math.floor(m_checkpoint));
				m_checkpoint = Math.max(0, m_checkpoint);
				
				updateTravelBar();
			}
			
			if( m_checkpoint < m_halfCheckpoint && !m_factsRevealed && GameVars.enableFunFacts )
			{
				SoundManager.getInstance().playSFX("FunFacts");
				m_GUI.funFacts.factText.htmlText = m_funFacts.getFact();
				m_factAge = 10000;
				m_factsRevealed = true;
				
				TweenMax.killTweensOf(m_GUI.funFacts);			
				TweenMax.to( m_GUI.funFacts, 2, { alpha:1 } );
			}
			
			if( m_factsRevealed && m_factAge > 0 )
			{
				m_factAge -= elapsedTime;
				if( m_factAge <= 0 )
				{
					TweenMax.killTweensOf(m_GUI.funFacts);			
					TweenMax.to( m_GUI.funFacts, 2, { alpha:0 } );
				}
			}
			
			Gameplay_UI(m_GUI).checkpoint.htmlText = "CHECKPOINT: " + String(m_checkpoint) + " Ft.";
			
			if ( m_checkpoint <= 0 )
			{
				GameVars.gameOver = true;
					
				m_GUI.funFacts.alpha = 0;
				m_factAge = 0;
								
				m_checkpointReached = true;
				m_endGameTimer.addEventListener(TimerEvent.TIMER, checkPointReached);
				m_endGameTimer.start();
			}
		}
		
		private function checkPointReached(event:TimerEvent):void
		{
			m_endGameTimer.removeEventListener(TimerEvent.TIMER, checkPointReached);
			
			if( SwarmManager.getInstance().getCount() == 15 && 
				!GameVars.achievementNobodyLeftBehindObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementNobodyLeftBehindObtained = true;
				showAchievement("Leave No Bird Behind.", "Reached Checkpoint With 15 Penguins Survived.", 1000);
			}
			
			if( SwarmManager.getInstance().getCount() == 1 && 
				!GameVars.achievementIllBeBackObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementIllBeBackObtained = true;
				showAchievement("I'll Be Back.", "Reach Checkpoint With Only 1 Penguin Survived.", 300);
			}
			
			if( !m_surfed && 
				!GameVars.achievementSlowHeadObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementSlowHeadObtained = true;
				showAchievement("Slowhead.", "Reach Checkpoint Without Surfing.", 1000);
			}
			
			if( m_flawless &&
				!GameVars.achievementFlawlessObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementFlawlessObtained = true;
				showAchievement("Flawless.", "No Penguin Died.", 1000);
			}
			
			if( !m_intoxicated && 
				!GameVars.achievementNoToxicObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementNoToxicObtained = true;
				showAchievement("We Hate Toxic.", "Successfully Avoid Toxic Bubbles in a Level.", 1000);
			}
			
			if ( GameVars.current_level == GameVars.max_level - 1 && GameVars.gameMode == 0 )
			{
				GameVars.completeGameCounter++;
				
				if( !GameVars.achievementAllHailToTheLeaderObtained )
				{
					GameVars.achievementAllHailToTheLeaderObtained = true;
					showAchievement("All Hail The Leader.", "Completed All Levels.", 2000);
				}
				
				if( GameVars.completeGameCounter == 10 &&
					!GameVars.achievementFanboyObtained )
				{
					GameVars.achievementFanboyObtained = true;
					showAchievement("Fanboy.", "10x Complete All Levels.", 10000);
				}
			}
			
			TweenMax.killTweensOf( m_scoreInfo );
						
			m_paused = true;
			m_allowPauseToggle = false;
			
			stage.removeChild(m_GUI);
			stage.addChild( m_scoreInfo );
			
			m_scoreInfo.x = 315;
			m_scoreInfo.y = -500;
			
			m_scoreInfo.score.textPointAchieved.htmlText = String(GameVars.currentScore);
			
			var sec_str:String = String(GameVars.second);
			if ( sec_str.length == 1 )
				sec_str = "0" + String(GameVars.second);
			
			m_scoreInfo.score.textTimeRemaining.htmlText = String(GameVars.minute) + "\"" + sec_str + "\'";
			m_scoreInfo.score.textSurvivor.htmlText = String( SwarmManager.getInstance().getCount() );
			m_scoreInfo.score.textTotalPoints.htmlText = "0";
			m_scoreInfo.score.textCareerPoints.htmlText = "0";
			m_scoreInfo.score.textXPGained.htmlText = "0";
			m_scoreInfo.score.textTotalXP.htmlText = String(m_tempTotalXP);
			
			m_scoreInfo.score.retryGame.visible = false;
			m_scoreInfo.score.continueGame.visible = false;
			
			m_scoreInfo.score.skipMessage.htmlText = "[ Click to Skip ]";
			
			
			TweenMax.to( m_scoreInfo, 2.5, 
							{ y:175, 
							  ease:Elastic.easeOut,
							  onComplete:function():void 
							  { 
									m_totalScore = 0;
									m_countingScore = true; 
							  } 
							}  );
		}
		
		private function countScore(elapsedTime:int):void 
		{
			m_countScoreDelay += elapsedTime;
			if (  m_countScoreDelay > 5 )
			{
				SoundManager.getInstance().playSFX("Water_03");
				
				/* count point achieved */
				if ( m_countScoreState == 0 )
				{
					var m_point:int;
					
					if ( GameVars.currentScore > 100 )
					{
						GameVars.currentScore -= 100; 
						m_totalScore += 100;
						m_tempCareerScore += 100;
					}
					else
					{
						m_totalScore += GameVars.currentScore;
						m_tempCareerScore += GameVars.currentScore;
						GameVars.currentScore = 0;
					}
					
					m_scoreInfo.score.textPointAchieved.htmlText = String(GameVars.currentScore);
					
					if( GameVars.currentScore == 0 )
						m_countScoreState = 1;
				}
				
				/* count time bonus */
				if ( m_countScoreState == 1 )
				{
					if( GameVars.minute > 0 || GameVars.second > 0 )
					{
						GameVars.second--;
						
						if (GameVars.second <= 0 && GameVars.minute > 0)
						{
							GameVars.second = 59;
							GameVars.minute--;
						}
						
						m_totalScore += 10;
						m_tempCareerScore += 10;
						
						var sec_str:String = String(GameVars.second);
						if( sec_str.length == 1 )
							sec_str = "0" + String(GameVars.second);
				
						m_scoreInfo.score.textTimeRemaining.htmlText = String(GameVars.minute) + "\"" + sec_str + "\'";
					}
					else
					{
						m_countScoreState = 2;
						m_buffSurvivorCount = SwarmManager.getInstance().getCount();
					}
				}
				
				// count survivor
				if ( m_countScoreState == 2 )
				{
					if ( m_buffSurvivorCount > 0 )
					{
						m_buffSurvivorCount--;
						m_totalScore += 100;
						m_tempCareerScore += 100;
						
						m_scoreInfo.score.textSurvivor.htmlText = String( m_buffSurvivorCount );
					}
					else
					{
						stage.mouseChildren = true;
						m_countScoreState = 3;
						m_countingScore = false;
						
						m_scoreInfo.score.skipMessage.htmlText = "";
						
						// TODO: COUNT XP
						var xpGained:int = Math.ceil(m_totalScore * GameVars.XP_GAIN_FACTOR);
						m_tempTotalXP += xpGained;
						
						m_scoreInfo.score.textXPGained.htmlText = String(xpGained);
						m_scoreInfo.score.textTotalXP.htmlText = String(m_tempTotalXP);
						
						m_scoreInfo.score.retryGame.visible = true;
						m_scoreInfo.score.continueGame.visible = true;
						
						m_scoreInfo.score.retryGame.addEventListener(MouseEvent.MOUSE_OVER, scoreButtonHover);
						m_scoreInfo.score.retryGame.addEventListener(MouseEvent.MOUSE_OUT, scoreButtonOut);
						m_scoreInfo.score.retryGame.addEventListener(MouseEvent.CLICK, scoreButtonClick);
						
						m_scoreInfo.score.continueGame.addEventListener(MouseEvent.MOUSE_OVER, scoreButtonHover);
						m_scoreInfo.score.continueGame.addEventListener(MouseEvent.MOUSE_OUT, scoreButtonOut);
						m_scoreInfo.score.continueGame.addEventListener(MouseEvent.CLICK, scoreButtonClick);
					}
				}
			
				m_scoreInfo.score.textTotalPoints.htmlText = String(m_totalScore);
				m_scoreInfo.score.textCareerPoints.htmlText = String(m_tempCareerScore);
									
				m_countScoreDelay = 0;
			}
		}
		
		private function scoreButtonHover(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_05");
			MovieClip(event.currentTarget).scaleX = MovieClip(event.currentTarget).scaleY = 1.2;
		}
		
		private function scoreButtonOut(event:MouseEvent):void
		{
			MovieClip(event.currentTarget).scaleX = MovieClip(event.currentTarget).scaleY = 1;
		}
		
		private function scoreButtonClick(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_06");
			
			/* remove listeners */
			m_scoreInfo.score.retryGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonHover);
			m_scoreInfo.score.retryGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonOut);
			m_scoreInfo.score.retryGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonClick);
			
			m_scoreInfo.score.continueGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonHover);
			m_scoreInfo.score.continueGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonOut);
			m_scoreInfo.score.continueGame.removeEventListener(MouseEvent.MOUSE_OVER, scoreButtonClick);
					
			if ( event.currentTarget == m_scoreInfo.score.retryGame )
			{
				/* RETRY LEVEL */
				
				GameStateManager.getInstance().setState(this);
			}
			else 
			{
				/* CONTINUE GAME */
			
				/* update score */
				GameVars.careerScore = m_tempCareerScore;
				GameVars.totalXP = m_tempTotalXP;
				
				if ( GameVars.current_level != GameVars.max_level - 1 )
				{
					if ( GameVars.gameMode == 1 )
						GameStateManager.getInstance().setState( GameSelectLevel.getInstance() );
					else	
						GameStateManager.getInstance().setState( GameUpgrade.getInstance() );
				}
				else
				{
					if ( GameVars.gameMode == 0 && GameVars.loggedIn == true )
					{
						stage.addChild(m_submitDialog);
						
						m_submitState = SUBMIT_ENDGAME;
						m_submitDialog.x = 320;
						m_submitDialog.y = 240;
						m_submitDialog.submitDialog.y = -600;
						m_submitDialog.submitDialog.pointText.text = "You got " + String(GameVars.careerScore) + " points.";
					
						TweenMax.to( m_submitDialog.submitDialog, 1, { y:0, ease:Elastic.easeOut } );
					}
					else
					{
						GameStateManager.getInstance().setState( InGameCredits.getInstance() );
					}
				}
			}
		}
		
		private function gameOver(event:TimerEvent): void
		{
			m_endGameTimer.removeEventListener(TimerEvent.TIMER, gameOver);
			GameVars.gameOver = true;
			
			TweenMax.killTweensOf( m_gameOverScreen );
						
			m_paused = true;
			m_allowPauseToggle = false;
			
			stage.removeChild(m_GUI);
			stage.addChild( m_gameOverScreen );
			
			m_gameOverScreen.x = 328;
			m_gameOverScreen.y = -500;
			
			stage.mouseChildren = true;
						
			TweenMax.to( m_gameOverScreen, 2.5, 
							{ y:203, 
							  ease:Elastic.easeOut,
								onComplete:function():void 
								{
									m_gameOverScreen.container.retry.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover); 
									m_gameOverScreen.container.retry.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave); 
									m_gameOverScreen.container.retry.addEventListener(MouseEvent.CLICK, menuMouseClick); 
									
									m_gameOverScreen.container.quit.addEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
									m_gameOverScreen.container.quit.addEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
									m_gameOverScreen.container.quit.addEventListener(MouseEvent.CLICK, menuMouseClick); 
								}
							}  );
		}
		
		private function menuMouseHover(event:MouseEvent): void
		{
			SoundManager.getInstance().playSFX("Water_05");
			event.currentTarget.scaleX = event.currentTarget.scaleY = 1.2;
		}
	
		private function menuMouseLeave(event:MouseEvent): void
		{
			event.currentTarget.scaleX = event.currentTarget.scaleY = 1;
		}
		
		private function menuMouseClick(event:MouseEvent): void
		{
			SoundManager.getInstance().playSFX("Water_06");
			
			m_gameOverScreen.container.retry.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover); 
			m_gameOverScreen.container.retry.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave); 
			m_gameOverScreen.container.retry.removeEventListener(MouseEvent.CLICK, menuMouseClick); 
			
			m_gameOverScreen.container.quit.removeEventListener(MouseEvent.MOUSE_OVER, menuMouseHover);
			m_gameOverScreen.container.quit.removeEventListener(MouseEvent.MOUSE_OUT, menuMouseLeave);
			m_gameOverScreen.container.quit.removeEventListener(MouseEvent.CLICK, menuMouseClick); 
			
			switch( event.currentTarget )
			{
				case m_gameOverScreen.container.retry:
							GameStateManager.getInstance().setState(this);
							break;
				case m_gameOverScreen.container.quit:
							GameStateManager.getInstance().setState(GameMenu.getInstance());
							break;
			}
		}
		
		private function registerPauseEventHandlers():void
		{
			m_inGamePause.resume.addEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.resume.addEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.resume.addEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.options.addEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.options.addEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.options.addEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.restart.addEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.restart.addEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.restart.addEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.mainmenu.addEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.mainmenu.addEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.mainmenu.addEventListener(MouseEvent.CLICK, pauseItemClick);
		}
		
		private function unregisterPauseEventHandlers():void
		{
			m_inGamePause.resume.removeEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.resume.removeEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.resume.removeEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.options.removeEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.options.removeEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.options.removeEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.restart.removeEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.restart.removeEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.restart.removeEventListener(MouseEvent.CLICK, pauseItemClick);
			
			m_inGamePause.mainmenu.removeEventListener(MouseEvent.MOUSE_OVER, pauseItemHover);
			m_inGamePause.mainmenu.removeEventListener(MouseEvent.MOUSE_OUT, pauseItemLeave);
			m_inGamePause.mainmenu.removeEventListener(MouseEvent.CLICK, pauseItemClick);
		}
		
		private function pauseItemHover(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_05");
			MovieClip(event.currentTarget).filters = [ m_glow ];
		}
		
		private function pauseItemLeave(event:MouseEvent):void
		{
			MovieClip(event.currentTarget).filters = null;
		}
		
		private function pauseItemClick(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_06");
			pauseItemLeave(event);
			if (event.currentTarget == m_inGamePause.resume)
			{
				unpause();
			}
			else if (event.currentTarget == m_inGamePause.options)
			{
				m_inGamePause.visible = false;
				GameOptions.getInstance().show(stage, true, 320, 220);
			}
			else if (event.currentTarget == m_inGamePause.restart)
			{
				m_GUI.visible = true;
				stage.mouseChildren = false;
			
				GameStateManager.getInstance().setState(this);
			}
			else if (event.currentTarget == m_inGamePause.mainmenu)
			{
				stage.removeChild(m_GUI);
				stage.mouseChildren = true;
			
				
				
				
				// if career score is not zero then ask to submit score
				if ( GameVars.careerScore > 0 && GameVars.gameMode == 0 && GameVars.loggedIn == true )
				{
					stage.addChild(m_submitDialog);
					
					m_submitState = SUBMIT_INGAME;
					m_submitDialog.x = 320;
					m_submitDialog.y = 240;
					m_submitDialog.submitDialog.y = -600;
					m_submitDialog.submitDialog.pointText.text = "You got " + String(GameVars.careerScore) + " points.";
					
					TweenMax.to( m_submitDialog.submitDialog, 1, { y:0, ease:Elastic.easeOut } );
				}
				else
				{
					GameStateManager.getInstance().setState(GameMenu.getInstance());
				}
			}
		}
		
		private function afterGameOptionsHidden(event:Event):void
		{
			m_inGamePause.visible = true;
		}
		
		private function toxicEaten(event:Event):void
		{
			m_intoxicated = true;
			
			GameVars.toxicCounter++;
			if( GameVars.toxicCounter == 50 &&
				!GameVars.achievementToxifiedObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementToxifiedObtained = true;
				showAchievement("Toxic Junkie.", "50x Toxic Bubbles Hit.", 500);
			}
		}
		
		override public function exit(): void
		{
			/* save serializer */
			//Serializer.getInstance().saveData();
			
			/* flush tweens */
			TweenMax.killAllTweens();
			
			/* event listeners */
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.CLICK, resignButtonClick);
			
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.CLICK, resignButtonClick);
			
			stage.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
						
			/* custom event listeners */
			SwarmManager.getInstance().removeEventListener( SwarmManager.RAPID_STREAM, hitStream );
			SwarmManager.getInstance().removeEventListener( SwarmManager.BOID_ADDED, boidAdded );
			SwarmManager.getInstance().removeEventListener( SwarmManager.BOID_REMOVED, boidDied );
			FoodManager.getInstance().removeEventListener( FoodManager.POWERUP_START, powerUpStart );
			FoodManager.getInstance().removeEventListener( FoodManager.POWERUP_END, powerUpEnd );
			FoodManager.getInstance().removeEventListener( FoodManager.BAD_FOOD_EATEN, toxicEaten );
			
			/* stop music */
			m_musicChannel.stop();
			
			/* detach objects */
			removeChild(m_seaWater);
			
			stage.removeChild( m_inGamePause );
			unregisterPauseEventHandlers();
			
			if( m_scoreInfo.parent )
				stage.removeChild(m_scoreInfo);
				
			if( m_gameOverScreen.parent )	
				stage.removeChild(m_gameOverScreen);
			
			/* reset camera	*/
			m_virtualCamera.x = 320;
			m_virtualCamera.y = 240;
			removeChild(m_virtualCamera);	
			m_virtualCamera = null;
			
			/*
			stage.removeChild( m_indicatorMultiplier );
			stage.removeChild( m_indicatorInvincible );
			*/
			m_GUI.removeChild( m_indicatorMultiplier );
			m_GUI.removeChild( m_indicatorInvincible );
			//stage.removeChild( m_fpsCounter );
		
			PredatorManager.getInstance().clear();
			SwarmManager.getInstance().clear();
			SeaManager.getInstance().clear();
			FoodManager.getInstance().clear();
			FloatingTextManager.getInstance().clear();
			
			ParticleManager.getInstance().clear();
			ParticleManager.getInstance().detach();
		}
		
		protected function updateTravelBar():void
		{
			var distPercentage:Number = m_checkpoint / m_maxCheckpoint;
			var iconPos:int = m_GUI.TravelIndicator.width - (m_GUI.TravelIndicator.width * distPercentage);
			
			if ( iconPos < 0 )
				iconPos = 0;
			else if ( iconPos > 595 )
				iconPos = 595;
			
			TweenMax.killTweensOf(m_GUI.TravelIndicator.Icon, true);
			TweenMax.to( m_GUI.TravelIndicator.Icon, 0.2, { x: iconPos } );
		}
		
		
		/* ============================
		 * 			DEV DATA
		 * ============================
		 */
		
		private function levelDataLoaded(/*e:Event=*/):void
		{
			//m_levelData = new XML(e.target.data); 
			m_levelData = LevelData.getInstance().getData();
			
			m_GUI.messageOfAct.text.htmlText = m_levelData.children()[GameVars.current_level].attribute("id");
			
			GameVars.max_level = m_levelData.children().length();
			
			GameVars.minute = m_levelData.children()[GameVars.current_level].misc.countdown.attribute("minute");
			GameVars.second = m_levelData.children()[GameVars.current_level].misc.countdown.attribute("second");
			GameVars.millisecond = 0;
			
			m_maxCheckpoint = m_checkpoint = m_levelData.children()[GameVars.current_level].misc.checkpoint.attribute("length");
			m_halfCheckpoint = m_maxCheckpoint >> 1;
			m_penguinStartCount = m_levelData.children()[GameVars.current_level].misc.penguin.attribute("count");
			
			GameVars.bystanders_spawn_rate = m_levelData.children()[GameVars.current_level].misc.bystanders.attribute("spawn_rate");
			GameVars.bystanders_interval = m_levelData.children()[GameVars.current_level].misc.bystanders.attribute("interval");
			GameVars.krill_tier_one = m_levelData.children()[GameVars.current_level].food.krill.attribute("tier_one");
			GameVars.krill_tier_two = m_levelData.children()[GameVars.current_level].food.krill.attribute("tier_two");
			GameVars.krill_tier_three = m_levelData.children()[GameVars.current_level].food.krill.attribute("tier_three");
			GameVars.smallfish_spawn_rate = m_levelData.children()[GameVars.current_level].food.smallfish.attribute("spawn_rate");
			GameVars.smallfish_interval = m_levelData.children()[GameVars.current_level].food.smallfish.attribute("interval");
			GameVars.invincible_spawn_rate = m_levelData.children()[GameVars.current_level].powerup.invincible.attribute("spawn_rate");
			GameVars.invincible_interval = m_levelData.children()[GameVars.current_level].powerup.invincible.attribute("interval");
			GameVars.multiplier_spawn_rate = m_levelData.children()[GameVars.current_level].powerup.multiplier.attribute("spawn_rate");
			GameVars.multiplier_interval = m_levelData.children()[GameVars.current_level].powerup.multiplier.attribute("interval");
			GameVars.stream_interval = m_levelData.children()[GameVars.current_level].powerup.stream.attribute("interval");
			GameVars.stream_tier_one = m_levelData.children()[GameVars.current_level].powerup.stream.attribute("tier_one");
			GameVars.stream_tier_two = m_levelData.children()[GameVars.current_level].powerup.stream.attribute("tier_two");
			GameVars.stream_tier_three = m_levelData.children()[GameVars.current_level].powerup.stream.attribute("tier_three");
			GameVars.anchor_spawn_rate = m_levelData.children()[GameVars.current_level].obstacle.anchor.attribute("spawn_rate");
			GameVars.anchor_interval = m_levelData.children()[GameVars.current_level].obstacle.anchor.attribute("interval");
			GameVars.shard_spawn_rate = m_levelData.children()[GameVars.current_level].obstacle.shard.attribute("spawn_rate");
			GameVars.shard_interval = m_levelData.children()[GameVars.current_level].obstacle.shard.attribute("interval");
			GameVars.jellyfish_spawn_rate = m_levelData.children()[GameVars.current_level].obstacle.jellyfish.attribute("spawn_rate");
			GameVars.jellyfish_interval = m_levelData.children()[GameVars.current_level].obstacle.jellyfish.attribute("interval");
			GameVars.toxic_tier_one = m_levelData.children()[GameVars.current_level].obstacle.toxic.attribute("tier_one");
			GameVars.toxic_tier_two = m_levelData.children()[GameVars.current_level].obstacle.toxic.attribute("tier_two");
			GameVars.predator_interval_min = m_levelData.children()[GameVars.current_level].predator.attribute("interval_min");
			GameVars.predator_interval_max = m_levelData.children()[GameVars.current_level].predator.attribute("interval_max");
			GameVars.shark_spawn_rate = m_levelData.children()[GameVars.current_level].predator.shark.attribute("spawn_rate");
			GameVars.seal_spawn_rate = m_levelData.children()[GameVars.current_level].predator.seal.attribute("spawn_rate");
		}
		
		private function loadLevelData():void
		{
			levelDataLoaded();
		}
		
		private function resignButtonOver(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.scaleX = mc.scaleY = 1.1;
		}
		
		private function resignButtonOut(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.scaleX = mc.scaleY = 1.0;
		}
		
		private function resignButtonClick(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if ( mc ==  m_submitDialog.submitDialog.buttonYes )
			{
				var o:Object = { n: [14, 5, 12, 9, 7, 1, 3, 13, 4, 5, 12, 2, 12, 12, 8, 4], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
				var boardID:String = o.f(0, "");
				//MochiScores.showLeaderboard({boardID: boardID, score: GameVars.careerScore});
			}
			
			stage.removeChild(m_submitDialog);
			
			switch( m_submitState )
			{
				case SUBMIT_INGAME:
						GameStateManager.getInstance().setState( GameMenu.getInstance() );
						break;
				case SUBMIT_ENDGAME:
						GameStateManager.getInstance().setState( InGameCredits.getInstance() );
						break;
			}
		}
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		 */
		
		static public function getInstance(): GameLoop
		{
			if( m_instance == null ){
				m_instance = new GameLoop( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}