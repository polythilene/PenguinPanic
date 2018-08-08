package {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import com.shade.geom.CPoint;
	import gs.TweenMax;
	
	public final class GameVars 
	{
		/* constants */
		public static const CHEATH_DEATH_FACTOR:int = 5;
		public static const XP_GAIN_FACTOR:Number = 0.012;
		
		/* buffers */
		public static var rootClip:DisplayObjectContainer = null;
		public static var cameraPos:CPoint = null;
		
		/* mochi highscores */
		public static var loggedIn:Boolean = false;
			
		/* movie clip index for child ordering */
		public static var seaWater:MovieClip;
		public static var gameUI:MovieClip;
		public static var effectLayer:DisplayObject;
		
		/* parameters */
		public static var onStream:Boolean;
		public static var currCameraScrollSpeed:Number;
		public static var normalCameraScrollSpeed:Number;
		public static var streamCameraScrollSpeed:Number;
		public static var scrollingUp:Boolean;
		public static var scrollingDown:Boolean;
		public static var gameOver:Boolean;
				
		/* game buffer */
		public static var minute:int;
		public static var second:int;
		public static var millisecond:int;
		
		/* options parameter */
		public static var enableFunFacts:Boolean = true;
		
		/* game variables */
		public static var gameMode:int;
		public static var scrollSpeed:Number;
		public static var currentScore:int;
		public static var careerScore:int;
		public static var totalXP:int;
		public static var menuBackground:MovieClip;
		public static var menuMusic:CSoundObject;
		
		/* shared objects */
		public static var defaultAttractor:CSwarmAttractor;
		
		/* upgrade data */
		public static var speedMultiplier:Number = 1.0;
		public static var maximumStamina:int = 100;
		public static var disperseDistance:int = 300;
		public static var luckFactor:Number = 1.0;
		public static var wanderOverride:Number = 1.0;
		public static var upgradePanicObtained:Boolean;
		public static var upgradeFarsightObtained:Boolean;
		public static var upgradeImmunityObtained:Boolean;
		public static var upgradeLuckObtained:Boolean;
		public static var upgradeFriendFinderObtained:Boolean;
		public static var upgradeSpeed1Obtained:Boolean;
		public static var upgradeSpeed2Obtained:Boolean;
		public static var upgradeSpeed3Obtained:Boolean;
		public static var upgradeFollowTheLeader1Obtained:Boolean;
		public static var upgradeFollowTheLeader2Obtained:Boolean;
		public static var upgradeParanoid1Obtained:Boolean;
		public static var upgradeParanoid2Obtained:Boolean;
		public static var upgradeEnergize1Obtained:Boolean;
		public static var upgradeEnergize2Obtained:Boolean;
		public static var upgradeEnergize3Obtained:Boolean;
		
		/* achievements */
		public static var achievementISeeDeadPenguinObtained:Boolean;
		public static var achievementNobodyLeftBehindObtained:Boolean;
		public static var achievementNobodyLovesMeObtained:Boolean;
		public static var achievementMassSuicideObtained:Boolean;
		public static var achievementHahaYouCantGetMeObtained:Boolean;
		public static var achievementEatMyTrailObtained:Boolean;
		public static var achievementWhoaThatWasCloseObtained:Boolean;
		public static var achievementIAmGooodObtained:Boolean;
		public static var achievementElectrifiedObtained:Boolean;
		public static var achievementLetsDoItAgainObtained:Boolean;
		public static var achievementIllBeBackObtained:Boolean;
		public static var achievementBlameTheLeaderObtained:Boolean;
		public static var achievementSlowHeadObtained:Boolean;
		public static var achievementFlawlessObtained:Boolean;
		public static var achievementTotalParanoidObtained:Boolean;
		public static var achievementToxifiedObtained:Boolean;
		public static var achievementNoToxicObtained:Boolean;
		public static var achievementSurfFreakObtained:Boolean;
		public static var achievementFanboyObtained:Boolean;
		public static var achievementPenguliciousObtained:Boolean;
		public static var achievementHeartOfSteelObtained:Boolean;
		public static var achievementDidSomeoneOrderFrozenPenguinObtained:Boolean;
		public static var achievementAllHailToTheLeaderObtained:Boolean;
		
		public static var deadCounter:int;
		public static var evadeWithPanicCounter:int;
		public static var evadeWithoutPanicCounter:int;
		public static var eatenCounter:int;
		public static var newGameCounter:int;
		public static var completeGameCounter:int;
		public static var gameOverCounter:int;
		public static var surfCounter:int;
		public static var panicCounter:int;
		public static var stingCounter:int;
		public static var achievementPermanentPoint:int;
		public static var achievementPermanentXP:int;
		public static var toxicCounter:int;
		public static var countUnlock:int;
		
		
		/* level data */
		public static var current_level:int;
		public static var max_level:int;
		
		public static var bystanders_spawn_rate:int;
		public static var bystanders_interval:int;
		public static var krill_tier_one:int;
		public static var krill_tier_two:int;
		public static var krill_tier_three:int;
		public static var smallfish_spawn_rate:int;
		public static var smallfish_interval:int;
		public static var invincible_spawn_rate:int;
		public static var invincible_interval:int;
		public static var multiplier_spawn_rate:int;
		public static var multiplier_interval:int;		
		public static var stream_interval:int;
		public static var stream_tier_one:int;
		public static var stream_tier_two:int;
		public static var stream_tier_three:int;
		public static var anchor_spawn_rate:int;
		public static var anchor_interval:int;
		public static var shard_spawn_rate:int;
		public static var shard_interval:int;
		public static var jellyfish_spawn_rate:int;
		public static var jellyfish_interval:int;
		public static var toxic_tier_one:int;
		public static var toxic_tier_two:int;
		public static var predator_interval_min:int;
		public static var predator_interval_max:int;
		public static var shark_spawn_rate:int;
		public static var seal_spawn_rate:int;
				
		/* stamina */
		public static var maxStamina:Number;
		public static var currentStamina:Number;
		public static var staminaIndicator:MovieClip;
		
		/* free roam level lock */
		public static var freeRoamLevel:Array;
		
		/* reset */
		public static function reset():void
		{
			current_level = 0;
			careerScore = 0;
			
			totalXP = 0;
			speedMultiplier = 1.0;
			maximumStamina = 100;
			disperseDistance = 300;
			luckFactor = 1.0;
			wanderOverride = 1.0;
			upgradePanicObtained = false;
			upgradeFarsightObtained = false;
			upgradeImmunityObtained = false;
			upgradeLuckObtained = false;
			upgradeFriendFinderObtained = false;
			upgradeSpeed1Obtained = false;
			upgradeSpeed2Obtained = false;
			upgradeSpeed3Obtained = false;
			upgradeFollowTheLeader1Obtained = false;
			upgradeFollowTheLeader2Obtained = false;
			upgradeParanoid1Obtained = false;
			upgradeParanoid2Obtained = false;
			upgradeEnergize1Obtained = false;
			upgradeEnergize2Obtained = false;
			upgradeEnergize3Obtained = false;
		}
		
		/* update stamina bar */
		public static function refreshStaminaBar(): void
		{
			var scale:Number = currentStamina / maxStamina; 
			
			if ( staminaIndicator )
			{
				TweenMax.killTweensOf(staminaIndicator);			
				TweenMax.to(staminaIndicator, 2, { scaleX:scale } );
			}
		}
		
		/* powerups point multiply */
		private static var m_powerUpPointMultiplier:int = 1;
		private static var m_powerUpPointMultiplierRemaining:int;
		
		public static function set powerUpPointMultiplier(value:int) : void	
		{
			m_powerUpPointMultiplier = Math.max(1, value);
			m_powerUpPointMultiplierRemaining = (value > 1) ? 10000 : 0;
		}
		
		public static function get powerUpPointMultiplier() : int 
		{
			return m_powerUpPointMultiplier;
		}
		
		/* powerups point invincible */
		
		private static var m_powerUpInvincible:Boolean = false;
		private static var m_powerUpInvincibleRemaining:int;
		
		public static function set powerUpInvincible(value:Boolean) : void	
		{
			m_powerUpInvincible = value;
			m_powerUpInvincibleRemaining = value ? 10000 : 0;
		}
		
		public static function get powerUpInvincible() : Boolean 
		{
			return m_powerUpInvincible;
		}
		
		/* update powerups */
		
		public static function updatePowerUps(elapsedTime:int): void
		{
			/* point multiplier */
			if ( m_powerUpPointMultiplier != 1 )
			{
				m_powerUpPointMultiplierRemaining -= elapsedTime;
				if ( m_powerUpPointMultiplierRemaining <= 0 )
				{
					m_powerUpPointMultiplierRemaining = 0;
					m_powerUpPointMultiplier = 1;
					
					FoodManager.getInstance().signalPowerUpEnd( FOODTYPE.POWERUP_POINT_X3 );
				}
			}
			
			/* invincibility */
			if ( m_powerUpInvincible )
			{
				m_powerUpInvincibleRemaining -= elapsedTime;	
				if ( m_powerUpInvincibleRemaining <= 0 )
				{
					m_powerUpInvincibleRemaining = 0;
					m_powerUpInvincible = false;
					
					FoodManager.getInstance().signalPowerUpEnd( FOODTYPE.POWERUP_INVINCIBLE );
				}
			}
		}
		
		public static function getBoardId(): String
		{
			var o:Object = { n: [14, 5, 12, 9, 7, 1, 3, 13, 4, 5, 12, 2, 12, 12, 8, 4], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0, "");
			return boardID;
		}
		
		/* reset */
		
		public static function resetPowerUps(): void
		{
			/* point multiplier */
			m_powerUpPointMultiplier = 1;
			
			/* invincibility */
			m_powerUpInvincible = false;
		}
	}
}