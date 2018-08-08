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
	import gs.easing.Elastic;
	
	import com.shade.math.OpMath;
	//import mochi.as3.*;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class GameUpgrade extends CGameState
	{
		static private var m_instance:GameUpgrade;
		
		/* buffers */
		private var m_upgradeMenu:UpgradeMenu;
		private var m_mouseX:int;
		private var m_mouseY:int;
		private var m_upgradeCost:Array;
		private var m_buttonGlow:GlowFilter;
		private var m_textGlow:GlowFilter;
		private var m_calmGlow:GlowFilter;
		private var m_tips:Array;
		private var m_submitDialog:SubmitScreen;
			
		public function GameUpgrade(lock:SingletonLock) 
		{
		}
		
		override public function initialize(owner:DisplayObjectContainer): void
		{
			super.initialize(owner);
			
			m_upgradeMenu = new UpgradeMenu();
			m_upgradeMenu.x = m_upgradeMenu.y = 0;
			
			m_upgradeCost = new Array();
			m_upgradeCost["panic"] 	= 100 ;
			m_upgradeCost["farsight"] = 100;
			m_upgradeCost["immunity"] = 200;
			m_upgradeCost["luck"] = 500;
			m_upgradeCost["friendfinder"] = 500;
			m_upgradeCost["speed1"] = 100;
			m_upgradeCost["speed2"] = 350;
			m_upgradeCost["speed3"] = 700;
			m_upgradeCost["followtheleader1"] = 300;
			m_upgradeCost["followtheleader2"] = 500;
			m_upgradeCost["paranoid1"] = 200;
			m_upgradeCost["paranoid2"] = 400;
			m_upgradeCost["energize1"] = 300;
			m_upgradeCost["energize2"] = 500;
			m_upgradeCost["energize3"] = 700;
			
			m_tips = [];
			m_tips.push( "Be cautious when the warning sign appears on the penguins, it means a predator is lurking nearby." );
			m_tips.push( "Jellyfish may sting the penguins, be careful." );
			m_tips.push( "Anchors are deadly, as they may kill all your penguins at once." );
			m_tips.push( "Powerups spawn randomly, but they do occasionally spawn at upper area of the water." );
			m_tips.push( "Surface area is challenging, as obstacles spawn more often around this zone." );
			m_tips.push( "You can surf in rapid stream to reach checkpoint faster." );
			m_tips.push( "If you have the panic ability, use it when predator is nearby (left click)." );
			m_tips.push( "When panic is active, the penguins will be cautious of its surrounding, they will avoid predators and obstacles.");
			m_tips.push( "Panic requires stamina, so use it wisely." );
			m_tips.push( "The deep water is relatively safer zone, but scarce of foods." );
			m_tips.push( "When you unlock an achievement you will be given a bonus point, this point is permanent everytime you start a new game, so try to unlock them all." );
						
			m_buttonGlow = new GlowFilter(0x66CAFF, 1, 5, 5, 3.5, 3);
			m_textGlow = new GlowFilter(0x66CAFF, 1, 3, 3, 2.5, 3);
			m_calmGlow = new GlowFilter(0x00FFFF, 1, 0, 0, 1, 3);
			
			SoundManager.getInstance().addSFX( "upgrade_click", new Sound_Upgrade_Click() );
			SoundManager.getInstance().addSFX( "upgrade_abort", new Sound_Upgrade_Abort() );
			
			m_submitDialog = new SubmitScreen();
		}
		
		override public function enter(): void
		{
			addChild(m_upgradeMenu);
			
			if( GameVars.gameMode == 1 )
				GameVars.totalXP = GameVars.achievementPermanentXP;
			
			/* init state */
			m_upgradeMenu.currentXP.htmlText = String(GameVars.totalXP);
			m_upgradeMenu.trainPanic.gotoAndStop( GameVars.upgradePanicObtained ? 2 : 1 );
			m_upgradeMenu.trainFarsight.gotoAndStop( GameVars.upgradeFarsightObtained ? 2 : 1 );
			m_upgradeMenu.trainImmunity.gotoAndStop( GameVars.upgradeImmunityObtained ? 2 : 1 );
			m_upgradeMenu.trainLuck.gotoAndStop( GameVars.upgradeLuckObtained ? 2 : 1 );
			m_upgradeMenu.trainFriendFinder.gotoAndStop( GameVars.upgradeFriendFinderObtained ? 2 : 1 );
			m_upgradeMenu.trainSpeed1.gotoAndStop( GameVars.upgradeSpeed1Obtained ? 2 : 1 );
			m_upgradeMenu.trainSpeed2.gotoAndStop( GameVars.upgradeSpeed2Obtained ? 2 : 1 );
			m_upgradeMenu.trainSpeed3.gotoAndStop( GameVars.upgradeSpeed3Obtained ? 2 : 1 );
			m_upgradeMenu.trainFollowTheLeader1.gotoAndStop( GameVars.upgradeFollowTheLeader1Obtained ? 2 : 1 );
			m_upgradeMenu.trainFollowTheLeader2.gotoAndStop( GameVars.upgradeFollowTheLeader2Obtained ? 2 : 1 );
			m_upgradeMenu.trainParanoid1.gotoAndStop( GameVars.upgradeParanoid1Obtained ? 2 : 1 );
			m_upgradeMenu.trainParanoid2.gotoAndStop( GameVars.upgradeParanoid2Obtained ? 2 : 1 );
			m_upgradeMenu.trainEnergize1.gotoAndStop( GameVars.upgradeEnergize1Obtained ? 2 : 1 );
			m_upgradeMenu.trainEnergize2.gotoAndStop( GameVars.upgradeEnergize2Obtained ? 2 : 1 );
			m_upgradeMenu.trainEnergize3.gotoAndStop( GameVars.upgradeEnergize3Obtained ? 2 : 1 );
			
			/* register events */
			m_upgradeMenu.menuBack.addEventListener(MouseEvent.MOUSE_OVER, menuOver);
			m_upgradeMenu.menuBack.addEventListener(MouseEvent.MOUSE_OUT, menuOut);
			m_upgradeMenu.menuBack.addEventListener(MouseEvent.CLICK, menuClick);
			
			m_upgradeMenu.menuContinue.addEventListener(MouseEvent.MOUSE_OVER, menuOver);
			m_upgradeMenu.menuContinue.addEventListener(MouseEvent.MOUSE_OUT, menuOut);
			m_upgradeMenu.menuContinue.addEventListener(MouseEvent.CLICK, menuClick);
			
			registerEvents( m_upgradeMenu.trainPanic );
			registerEvents( m_upgradeMenu.trainFarsight );
			registerEvents( m_upgradeMenu.trainImmunity );
			registerEvents( m_upgradeMenu.trainLuck );
			registerEvents( m_upgradeMenu.trainFriendFinder );
			registerEvents( m_upgradeMenu.trainSpeed1 );
			registerEvents( m_upgradeMenu.trainSpeed2 );
			registerEvents( m_upgradeMenu.trainSpeed3 );
			registerEvents( m_upgradeMenu.trainFollowTheLeader1 );
			registerEvents( m_upgradeMenu.trainFollowTheLeader2 );
			registerEvents( m_upgradeMenu.trainParanoid1 );
			registerEvents( m_upgradeMenu.trainParanoid2 );
			registerEvents( m_upgradeMenu.trainEnergize1 );
			registerEvents( m_upgradeMenu.trainEnergize2 );
			registerEvents( m_upgradeMenu.trainEnergize3 );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			
			m_owner.mouseChildren = true;
			m_upgradeMenu.tooltip.visible = false;
			
			m_upgradeMenu.trainPanic.mouseChildren = false;
			m_upgradeMenu.trainFarsight.mouseChildren = false;
			m_upgradeMenu.trainImmunity.mouseChildren = false;
			m_upgradeMenu.trainLuck.mouseChildren = false;
			m_upgradeMenu.trainFriendFinder.mouseChildren = false;
			m_upgradeMenu.trainSpeed1.mouseChildren = false;
			m_upgradeMenu.trainSpeed2.mouseChildren = false;
			m_upgradeMenu.trainSpeed3.mouseChildren = false;
			m_upgradeMenu.trainFollowTheLeader1.mouseChildren = false;
			m_upgradeMenu.trainFollowTheLeader2.mouseChildren = false;
			m_upgradeMenu.trainParanoid1.mouseChildren = false;
			m_upgradeMenu.trainParanoid2.mouseChildren = false;
			m_upgradeMenu.trainEnergize1.mouseChildren = false;
			m_upgradeMenu.trainEnergize2.mouseChildren = false;
			m_upgradeMenu.trainEnergize3.mouseChildren = false;
			
			// play music
			//m_musicChannel = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			if ( GameVars.gameMode == 0 )
				GameVars.menuMusic = SoundManager.getInstance().playMusic( "MainMenu_01", 1000 );
			
			/* show tips */
			m_upgradeMenu.tips.htmlText = m_tips[Math.floor(OpMath.randomNumber(m_tips.length))];
			
			GameVars.menuBackground = m_upgradeMenu.background;
			SeaManager.getInstance().changeSet(1);
			
			for( var i:int = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUBUBBLES, OpMath.randomRange( 0, 640 ), 480 );
				
			for( i = 0; i < 3; i++ )
				SeaManager.getInstance().add( OBJECTTYPE.MENUPENGUIN, OpMath.randomRange( 0, 640 ), 480 );	
				
			/* MOCHI AD */
			//MochiAd.showClickAwayAd( { clip:m_upgradeMenu.adBox.adContainer, id:"e1984e04a1356679" } );
			
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonYes.addEventListener(MouseEvent.CLICK, resignButtonClick);
			
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonNo.addEventListener(MouseEvent.CLICK, resignButtonClick);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			m_mouseX = event.stageX;
			m_mouseY = event.stageY;
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			MovieClip(event.currentTarget).filters = [ m_buttonGlow ];
			
			/* show description */
			switch( event.currentTarget )
			{
				case m_upgradeMenu.trainPanic:
						m_upgradeMenu.trainPanic.icon.gotoAndPlay(2);
						m_upgradeMenu.tooltip.abilityName.htmlText = "Panic";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["panic"]);
						m_upgradeMenu.tooltip.description.htmlText = "Give the ability to avoid nearby predator and obstacles (left click to activate).";
						break;
				case m_upgradeMenu.trainFarsight:
						m_upgradeMenu.trainFarsight.icon.gotoAndPlay(2);
						m_upgradeMenu.tooltip.abilityName.htmlText = "Farsight";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Panic";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["farsight"]);
						m_upgradeMenu.tooltip.description.htmlText = "Give the ability to zoom out the camera when panic button is activated.";
						break;
				case m_upgradeMenu.trainImmunity:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Immunity";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["immunity"]);
						m_upgradeMenu.tooltip.description.htmlText = "Toxic bubbles will also energize the penguins.";
						break;
				case m_upgradeMenu.trainLuck:
						m_upgradeMenu.trainLuck.icon.gotoAndPlay(2);
						m_upgradeMenu.tooltip.abilityName.htmlText = "Luck";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["luck"]);
						m_upgradeMenu.tooltip.description.htmlText = "Give more chances to spawn more powerups and/or cheating deaths.";
						break;
				case m_upgradeMenu.trainFriendFinder:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Friend Finder";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["friendfinder"]);
						m_upgradeMenu.tooltip.description.htmlText = "Locate nearby friendly penguins.";
						break;
				case m_upgradeMenu.trainSpeed1:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Speed I";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["speed1"]);
						m_upgradeMenu.tooltip.description.htmlText = "Increase penguin swim speed.";
						break;
				case m_upgradeMenu.trainSpeed2:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Speed II";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Speed I";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["speed2"]);
						m_upgradeMenu.tooltip.description.htmlText = "Further increase penguin swim speed.";
						break;
				case m_upgradeMenu.trainSpeed3:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Speed III";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Speed II";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["speed3"]);
						m_upgradeMenu.tooltip.description.htmlText = "Greatly increase penguin swim speed.";
						break;
				case m_upgradeMenu.trainFollowTheLeader1:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Follow The Leader I";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["followtheleader1"]);
						m_upgradeMenu.tooltip.description.htmlText = "Improve flock formation, making the penguins less to wander.";
						break;
				case m_upgradeMenu.trainFollowTheLeader2:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Follow The Leader II";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Follow The Leader I";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["followtheleader2"]);
						m_upgradeMenu.tooltip.description.htmlText = "Greatly improve flock formation, making the penguins less to wander.";
						break;
				case m_upgradeMenu.trainParanoid1:
						m_upgradeMenu.trainParanoid1.icon.gotoAndPlay(2);
						m_upgradeMenu.tooltip.abilityName.htmlText = "Paranoid I";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["paranoid1"]);
						m_upgradeMenu.tooltip.description.htmlText = "Increase disperse distance when avoiding predators";
						break;
				case m_upgradeMenu.trainParanoid2:
						m_upgradeMenu.trainParanoid2.icon.gotoAndPlay(2);
						m_upgradeMenu.tooltip.abilityName.htmlText = "Paranoid II";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Paranoid I";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["paranoid2"]);
						m_upgradeMenu.tooltip.description.htmlText = "Greatly increase disperse distance when avoiding predators";
						break;
				case m_upgradeMenu.trainEnergize1:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Energize I";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["energize1"]);
						m_upgradeMenu.tooltip.description.htmlText = "Increase stamina caps.";
						break;
				case m_upgradeMenu.trainEnergize2:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Energize II";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Energize I";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["energize2"]);
						m_upgradeMenu.tooltip.description.htmlText = "Further increase stamina caps.";
						break;
				case m_upgradeMenu.trainEnergize3:
						m_upgradeMenu.tooltip.abilityName.htmlText = "Energize III";
						m_upgradeMenu.tooltip.abilityRequirement.htmlText = "Requirement: Energize II";
						m_upgradeMenu.tooltip.abilityCost.htmlText = String(m_upgradeCost["energize3"]);
						m_upgradeMenu.tooltip.description.htmlText = "Greatly increase stamina caps.";
						break;
			}
			
			/* show tooltip */
			m_upgradeMenu.tooltip.visible = true;
			m_upgradeMenu.tooltip.x = m_mouseX + 10;
			m_upgradeMenu.tooltip.y = m_mouseY + 10;
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if ( event.currentTarget == m_upgradeMenu.trainPanic )
				m_upgradeMenu.trainPanic.icon.gotoAndStop(1);
			else if ( event.currentTarget == m_upgradeMenu.trainFarsight )
				m_upgradeMenu.trainFarsight.icon.gotoAndStop(1);
			else if ( event.currentTarget == m_upgradeMenu.trainParanoid1 )
				m_upgradeMenu.trainParanoid1.icon.gotoAndStop(1);
			else if ( event.currentTarget == m_upgradeMenu.trainParanoid2 )
				m_upgradeMenu.trainParanoid2.icon.gotoAndStop(1);
			else if ( event.currentTarget == m_upgradeMenu.trainLuck )
				m_upgradeMenu.trainLuck.icon.gotoAndPlay(1);
			
			MovieClip(event.currentTarget).filters = null;
			m_upgradeMenu.tooltip.visible = false;
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			
			
			if ( event.currentTarget == m_upgradeMenu.trainPanic  )
			{
				if ( !GameVars.upgradePanicObtained && 
					 GameVars.totalXP >= m_upgradeCost["panic"] )
				{
					m_upgradeMenu.trainPanic.gotoAndStop(2);
					GameVars.upgradePanicObtained = true;
					GameVars.totalXP -= m_upgradeCost["panic"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainFarsight )
			{
				if ( !GameVars.upgradeFarsightObtained && 
					 m_upgradeMenu.trainPanic &&
					 GameVars.totalXP >= m_upgradeCost["farsight"] )
				{
					m_upgradeMenu.trainFarsight.gotoAndStop(2);
					GameVars.upgradeFarsightObtained = true;
					GameVars.totalXP -= m_upgradeCost["farsight"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainImmunity )
			{
				if ( !GameVars.upgradeImmunityObtained &&
					 GameVars.totalXP >= m_upgradeCost["immunity"] )
				{
					m_upgradeMenu.trainImmunity.gotoAndStop(2);
					GameVars.upgradeImmunityObtained = true;
					GameVars.totalXP -= m_upgradeCost["immunity"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainLuck )
			{
				if ( !GameVars.upgradeLuckObtained &&
					 GameVars.totalXP >= m_upgradeCost["luck"] )
				{
					m_upgradeMenu.trainLuck.gotoAndStop(2);
					GameVars.upgradeLuckObtained = true;
					GameVars.luckFactor = 1.5;
					GameVars.totalXP -= m_upgradeCost["luck"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainFriendFinder  )
			{
				if ( !GameVars.upgradeFriendFinderObtained &&
					 GameVars.totalXP >= m_upgradeCost["friendfinder"] )
				{
					m_upgradeMenu.trainFriendFinder.gotoAndStop(2);
					GameVars.upgradeFriendFinderObtained = true;
					GameVars.totalXP -= m_upgradeCost["friendfinder"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainSpeed1 )
			{
				if ( !GameVars.upgradeSpeed1Obtained &&
					  GameVars.totalXP >= m_upgradeCost["speed1"] )
				{
					m_upgradeMenu.trainSpeed1.gotoAndStop(2);
					GameVars.upgradeSpeed1Obtained = true;
					GameVars.speedMultiplier = 1.1;
					GameVars.totalXP -= m_upgradeCost["speed1"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainSpeed2 )
			{
				if ( !GameVars.upgradeSpeed2Obtained && 
					 GameVars.upgradeSpeed1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["speed2"])
				{
					m_upgradeMenu.trainSpeed2.gotoAndStop(2);
					GameVars.upgradeSpeed2Obtained = true;
					GameVars.speedMultiplier = 1.5;
					GameVars.totalXP -= m_upgradeCost["speed2"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainSpeed3 )
			{
				if ( !GameVars.upgradeSpeed3Obtained && 
					 GameVars.upgradeSpeed2Obtained &&
					 GameVars.totalXP >= m_upgradeCost["speed3"] )
				{
					m_upgradeMenu.trainSpeed3.gotoAndStop(2);
					GameVars.upgradeSpeed3Obtained = true;
					GameVars.speedMultiplier = 1.5;
					GameVars.totalXP -= m_upgradeCost["speed3"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainFollowTheLeader1 )
			{
				if ( !GameVars.upgradeFollowTheLeader1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["followtheleader1"] )
				{
					m_upgradeMenu.trainFollowTheLeader1.gotoAndStop(2);
					GameVars.upgradeFollowTheLeader1Obtained = true;
					GameVars.wanderOverride = 0.7;
					GameVars.totalXP -= m_upgradeCost["followtheleader1"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainFollowTheLeader2 )
			{
				if ( !GameVars.upgradeFollowTheLeader2Obtained && 
					 GameVars.upgradeFollowTheLeader1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["followtheleader2"] )
				{
					m_upgradeMenu.trainFollowTheLeader2.gotoAndStop(2);
					GameVars.upgradeFollowTheLeader2Obtained = true;
					GameVars.wanderOverride = 0.5;
					GameVars.totalXP -= m_upgradeCost["followtheleader2"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainParanoid1 )
			{
				if ( !GameVars.upgradeParanoid1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["paranoid1"] )
				{
					m_upgradeMenu.trainParanoid1.gotoAndStop(2);
					GameVars.upgradeParanoid1Obtained = true;
					GameVars.disperseDistance = 350;
					GameVars.totalXP -= m_upgradeCost["paranoid1"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainParanoid2 )
			{
				if ( !GameVars.upgradeParanoid2Obtained && 
					 GameVars.upgradeParanoid1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["paranoid2"] )
				{
					m_upgradeMenu.trainParanoid2.gotoAndStop(2);
					GameVars.upgradeParanoid2Obtained = true;
					GameVars.disperseDistance = 400;
					GameVars.totalXP -= m_upgradeCost["paranoid2"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainEnergize1 )
			{
				if ( !GameVars.upgradeEnergize1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["energize1"] )
				{
					m_upgradeMenu.trainEnergize1.gotoAndStop(2);
					GameVars.upgradeEnergize1Obtained = true;
					GameVars.maximumStamina = 150;
					GameVars.totalXP -= m_upgradeCost["energize1"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainEnergize2 )
			{
				if ( !GameVars.upgradeEnergize2Obtained && 
					 GameVars.upgradeEnergize1Obtained &&
					 GameVars.totalXP >= m_upgradeCost["energize2"] )
				{
					m_upgradeMenu.trainEnergize2.gotoAndStop(2);
					GameVars.upgradeEnergize2Obtained = true;
					GameVars.maximumStamina = 200;
					GameVars.totalXP -= m_upgradeCost["energize2"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			else if ( event.currentTarget == m_upgradeMenu.trainEnergize3 )
			{
				if ( !GameVars.upgradeEnergize3Obtained && 
					 GameVars.upgradeEnergize2Obtained &&
					 GameVars.totalXP >= m_upgradeCost["energize3"] )
				{
					m_upgradeMenu.trainEnergize3.gotoAndStop(2);
					GameVars.upgradeEnergize3Obtained = true;
					GameVars.maximumStamina = 250;
					GameVars.totalXP -= m_upgradeCost["energize3"];
					SoundManager.getInstance().playSFX("upgrade_click");
				}
				else 
				{
					SoundManager.getInstance().playSFX("upgrade_abort");
				}
			}
			
			m_upgradeMenu.currentXP.htmlText = String(GameVars.totalXP);
		}
		
		override public function exit(): void
		{
			SeaManager.getInstance().clear();
			
			/* stop music */
			//m_musicChannel.stop();
			
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonYes.removeEventListener(MouseEvent.CLICK, resignButtonClick);
			
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.MOUSE_OVER, resignButtonOver);
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.MOUSE_OUT, resignButtonOut);
			m_submitDialog.submitDialog.buttonNo.removeEventListener(MouseEvent.CLICK, resignButtonClick);
			
			
			m_upgradeMenu.menuBack.removeEventListener(MouseEvent.MOUSE_OVER, menuOver);
			m_upgradeMenu.menuBack.removeEventListener(MouseEvent.MOUSE_OUT, menuOut);
			m_upgradeMenu.menuBack.removeEventListener(MouseEvent.CLICK, menuClick);
			
			m_upgradeMenu.menuContinue.removeEventListener(MouseEvent.MOUSE_OVER, menuOver);
			m_upgradeMenu.menuContinue.removeEventListener(MouseEvent.MOUSE_OUT, menuOut);
			m_upgradeMenu.menuContinue.removeEventListener(MouseEvent.CLICK, menuClick);
			
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			unregisterEvents( m_upgradeMenu.trainPanic );
			unregisterEvents( m_upgradeMenu.trainFarsight );
			unregisterEvents( m_upgradeMenu.trainImmunity );
			unregisterEvents( m_upgradeMenu.trainLuck );
			unregisterEvents( m_upgradeMenu.trainFriendFinder );
			unregisterEvents( m_upgradeMenu.trainSpeed1 );
			unregisterEvents( m_upgradeMenu.trainSpeed2 );
			unregisterEvents( m_upgradeMenu.trainSpeed3 );
			unregisterEvents( m_upgradeMenu.trainFollowTheLeader1 );
			unregisterEvents( m_upgradeMenu.trainFollowTheLeader2 );
			unregisterEvents( m_upgradeMenu.trainParanoid1 );
			unregisterEvents( m_upgradeMenu.trainParanoid2 );
			unregisterEvents( m_upgradeMenu.trainEnergize1 );
			unregisterEvents( m_upgradeMenu.trainEnergize2 );
			unregisterEvents( m_upgradeMenu.trainEnergize3 );
			
			removeChild(m_upgradeMenu);
			m_owner.mouseChildren = false;
		}
		
		private function registerEvents(mc:MovieClip):void
		{
			mc.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			mc.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			mc.addEventListener( MouseEvent.CLICK, mouseClickHandler );
		}
		
		private function unregisterEvents(mc:MovieClip):void
		{
			mc.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			mc.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			mc.removeEventListener( MouseEvent.CLICK, mouseClickHandler );
		}
		
		private function menuOver(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_05");
			MovieClip(event.currentTarget).filters = [ m_textGlow ];
		}
		
		private function  menuOut(event:MouseEvent):void
		{
			MovieClip(event.currentTarget).filters = [ m_calmGlow ];
		}
		
		private function menuClick(event:MouseEvent):void
		{
			SoundManager.getInstance().playSFX("Water_06");
			TweenMax.killAllTweens(true);
			
			menuOut(event);
			
			switch( event.currentTarget )
			{
				case m_upgradeMenu.menuBack: 
				
						if ( GameVars.gameMode == 0 && GameVars.loggedIn )
						{
							stage.addChild( m_submitDialog );
							
							m_submitDialog.x = 320;
							m_submitDialog.y = 240;
							m_submitDialog.submitDialog.y = -600;
							m_submitDialog.submitDialog.pointText.text = "You got " + String(GameVars.careerScore) + " points.";
					
							TweenMax.to( m_submitDialog.submitDialog, 1, { y:0, ease:Elastic.easeOut } );
						}
						else
						{
							GameStateManager.getInstance().setState( GameMenu.getInstance() );
						}
						break;
				case m_upgradeMenu.menuContinue: 
						if( GameVars.gameMode == 0 )
							GameVars.current_level++;
							
						GameVars.menuMusic.stop();	
						GameStateManager.getInstance().setState( GameLoop.getInstance() );
						break;		
			}
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
			GameStateManager.getInstance().setState( GameMenu.getInstance() );
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			SeaManager.getInstance().update(elapsedTime);
		}
		
		static public function getInstance(): GameUpgrade
		{
			if( m_instance == null ){
				m_instance = new GameUpgrade( new SingletonLock() );
			}
			return m_instance;
		}
	}
}


class SingletonLock{}
