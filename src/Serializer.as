package  
{
	import flash.net.SharedObject;
	//import mochi.as3.*;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class Serializer
	{
		static private var m_instance:Serializer;
		
		public function Serializer(lock:SingletonLock) {}
		/*
		public function saveData():void
		{
			if( !GameVars.loggedIn )
				return;
				
			// upgrade data
			saveUpgrades();
			
			// achievements
			saveAchievements();
			
			// save free roam levels
			if( GameVars.freeRoamLevel )
				MochiUserData.put("freeRoamLevels", GameVars.freeRoamLevel, setUserData);
		}*/
		/*
		private function setUserData(userData:MochiUserData):void 
		{
			if (userData.error) 
			{
				trace("[ERROR] could not set user data: " + userData.error);
                return;
            }
            trace("Successfully set user data : ", userData.key);
        }
		*/
		
		/* mochi getter callback */
		/*
		private function saveUpgrades():void 	
		{
			var upgrades:Array = [];
			
			upgrades["speedMultiplier"] = GameVars.speedMultiplier;
			upgrades["maximumStamina"] = GameVars.maximumStamina;
			upgrades["disperseDistance"] =  GameVars.disperseDistance;
			upgrades["luckFactor"] = GameVars.luckFactor;
			upgrades["wanderOverride"] = GameVars.wanderOverride;
			upgrades["upgradePanicObtained"] = GameVars.upgradePanicObtained;
			upgrades["upgradeFarsightObtained"] = GameVars.upgradeFarsightObtained;
			upgrades["upgradeImmunityObtained"] = GameVars.upgradeImmunityObtained;
			upgrades["upgradeLuckObtained"] = GameVars.upgradeLuckObtained;
			upgrades["upgradeFriendFinderObtained"] = GameVars.upgradeFriendFinderObtained;
			upgrades["upgradeSpeed1Obtained"] = GameVars.upgradeSpeed1Obtained;
			upgrades["upgradeSpeed2Obtained"] = GameVars.upgradeSpeed2Obtained;
			upgrades["upgradeSpeed3Obtained"] = GameVars.upgradeSpeed3Obtained;
			upgrades["upgradeFollowTheLeader1Obtained"] = GameVars.upgradeFollowTheLeader1Obtained;
			upgrades["upgradeFollowTheLeader2Obtained"] = GameVars.upgradeFollowTheLeader2Obtained;
			upgrades["upgradeParanoid1Obtained"] = GameVars.upgradeParanoid1Obtained;
			upgrades["upgradeParanoid2Obtained"] = GameVars.upgradeParanoid2Obtained;
			upgrades["upgradeEnergize1Obtained"] = GameVars.upgradeEnergize1Obtained;
			upgrades["upgradeEnergize2Obtained"] = GameVars.upgradeEnergize2Obtained;
			upgrades["upgradeEnergize3Obtained"] = GameVars.upgradeEnergize3Obtained;
			
			MochiUserData.put("upgrades", upgrades, setUserData);
		}
		*/
		/*
		
		private function saveAchievements():void 	
		{
			var achievements:Array = [];
			
			achievements["achievementISeeDeadPenguinObtained"] = GameVars.achievementISeeDeadPenguinObtained;
			achievements["achievementNobodyLeftBehindObtained"] = GameVars.achievementNobodyLeftBehindObtained;
			achievements["achievementNobodyLovesMeObtained"] = GameVars.achievementNobodyLovesMeObtained;
			achievements["achievementMassSuicideObtained"] = GameVars.achievementMassSuicideObtained;
			achievements["achievementHahaYouCantGetMeObtained"] = GameVars.achievementHahaYouCantGetMeObtained;
			achievements["achievementEatMyTrailObtained"] = GameVars.achievementEatMyTrailObtained;
			achievements["achievementWhoaThatWasCloseObtained"] = GameVars.achievementWhoaThatWasCloseObtained;
			achievements["achievementIAmGooodObtained"] = GameVars.achievementIAmGooodObtained;
			achievements["achievementElectrifiedObtained"] = GameVars.achievementElectrifiedObtained;
			achievements["achievementLetsDoItAgainObtained"] = GameVars.achievementLetsDoItAgainObtained;
			achievements["achievementIllBeBackObtained"] = GameVars.achievementIllBeBackObtained;
			achievements["achievementBlameTheLeaderObtained"] = GameVars.achievementBlameTheLeaderObtained;
			achievements["achievementSlowHeadObtained"] = GameVars.achievementSlowHeadObtained;
			achievements["achievementFlawlessObtained"] = GameVars.achievementFlawlessObtained;
			achievements["achievementTotalParanoidObtained"] = GameVars.achievementTotalParanoidObtained;
			achievements["achievementToxifiedObtained"] = GameVars.achievementToxifiedObtained;
			achievements["achievementNoToxicObtained"] = GameVars.achievementNoToxicObtained;
			achievements["achievementSurfFreakObtained"] = GameVars.achievementSurfFreakObtained;
			achievements["achievementFanboyObtained"] = GameVars.achievementFanboyObtained;
			achievements["achievementPenguliciousObtained"] = GameVars.achievementPenguliciousObtained;
			achievements["achievementHeartOfSteelObtained"] = GameVars.achievementHeartOfSteelObtained;
			achievements["achievementDidSomeoneOrderFrozenPenguinObtained"] = GameVars.achievementDidSomeoneOrderFrozenPenguinObtained;
			achievements["achievementAllHailToTheLeaderObtained"] = GameVars.achievementAllHailToTheLeaderObtained;
			
			achievements["deadCounter"] = GameVars.deadCounter;
			achievements["evadeWithPanicCounter"] = GameVars.evadeWithPanicCounter;
			achievements["evadeWithoutPanicCounter"] = GameVars.evadeWithoutPanicCounter;
			achievements["eatenCounter"] = GameVars.eatenCounter;
			achievements["newGameCounter"] = GameVars.newGameCounter;
			achievements["completeGameCounter"] = GameVars.completeGameCounter;
			achievements["gameOverCounter"] = GameVars.gameOverCounter;
			achievements["surfCounter"] = GameVars.surfCounter;
			achievements["panicCounter"] = GameVars.panicCounter;
			achievements["stingCounter"] = GameVars.stingCounter;
			achievements["achievementPermanentPoint"] = GameVars.achievementPermanentPoint;
			achievements["achievementPermanentXP"] = GameVars.achievementPermanentXP;
			achievements["toxicCounter"] = GameVars.toxicCounter;
			achievements["countUnlock"] = GameVars.countUnlock;
	
			MochiUserData.put("achievements", achievements, setUserData);
		}
		*/
		/*
		private function getUpgrades(userData:MochiUserData):void 	
		{
			if( userData.error )
				return;
			
			var upgrades:Array = userData.data;
			
			GameVars.speedMultiplier = upgrades["speedMultiplier"];
			GameVars.maximumStamina = upgrades["maximumStamina"];
			GameVars.disperseDistance = upgrades["disperseDistance"];
			GameVars.luckFactor = upgrades["luckFactor"];
			GameVars.wanderOverride = upgrades["wanderOverride"];
			GameVars.countUnlock = upgrades["countUnlock"];
			GameVars.upgradePanicObtained = upgrades["upgradePanicObtained"];
			GameVars.upgradeFarsightObtained = upgrades["upgradeFarsightObtained"];
			GameVars.upgradeImmunityObtained = upgrades["upgradeImmunityObtained"];
			GameVars.upgradeLuckObtained = upgrades["upgradeLuckObtained"];
			GameVars.upgradeFriendFinderObtained = upgrades["upgradeFriendFinderObtained"];
			GameVars.upgradeSpeed1Obtained = upgrades["upgradeSpeed1Obtained"]; 
			GameVars.upgradeSpeed2Obtained = upgrades["upgradeSpeed2Obtained"];
			GameVars.upgradeSpeed3Obtained = upgrades["upgradeSpeed3Obtained"];
			GameVars.upgradeFollowTheLeader1Obtained = upgrades["upgradeFollowTheLeader1Obtained"];
			GameVars.upgradeFollowTheLeader2Obtained = upgrades["upgradeFollowTheLeader2Obtained"];
			GameVars.upgradeParanoid1Obtained = upgrades["upgradeParanoid1Obtained"];
			GameVars.upgradeParanoid2Obtained = upgrades["upgradeParanoid2Obtained"];
			GameVars.upgradeEnergize1Obtained = upgrades["upgradeEnergize1Obtained"]; 
			GameVars.upgradeEnergize2Obtained = upgrades["upgradeEnergize2Obtained"];
			GameVars.upgradeEnergize3Obtained = upgrades["upgradeEnergize3Obtained"];
		}
		*/
		/*
		private function getAchievements(userData:MochiUserData):void 	
		{
			if( userData.error )
				return;
			
			var achievements:Array = userData.data;
				
			GameVars.achievementISeeDeadPenguinObtained = achievements["achievementISeeDeadPenguinObtained"];
			GameVars.achievementNobodyLeftBehindObtained = achievements["achievementNobodyLeftBehindObtained"];
			GameVars.achievementNobodyLovesMeObtained = achievements["achievementNobodyLovesMeObtained"];
			GameVars.achievementMassSuicideObtained = achievements["achievementMassSuicideObtained"];
			GameVars.achievementHahaYouCantGetMeObtained = achievements["achievementHahaYouCantGetMeObtained"];
			GameVars.achievementEatMyTrailObtained = achievements["achievementEatMyTrailObtained"];
			GameVars.achievementWhoaThatWasCloseObtained = achievements["achievementWhoaThatWasCloseObtained"];
			GameVars.achievementIAmGooodObtained = achievements["achievementIAmGooodObtained"];
			GameVars.achievementElectrifiedObtained = achievements["achievementElectrifiedObtained"];
			GameVars.achievementLetsDoItAgainObtained = achievements["achievementLetsDoItAgainObtained"];
			GameVars.achievementIllBeBackObtained = achievements["achievementIllBeBackObtained"];
			GameVars.achievementBlameTheLeaderObtained = achievements["achievementBlameTheLeaderObtained"];
			GameVars.achievementSlowHeadObtained = achievements["achievementSlowHeadObtained"];
			GameVars.achievementTotalParanoidObtained = achievements["achievementTotalParanoidObtained"];
			GameVars.achievementFlawlessObtained = achievements["achievementFlawlessObtained"];
			GameVars.achievementToxifiedObtained = achievements["achievementToxifiedObtained"];
			GameVars.achievementNoToxicObtained = achievements["achievementNoToxicObtained"];
			GameVars.achievementSurfFreakObtained = achievements["achievementSurfFreakObtained"];
			GameVars.achievementFanboyObtained = achievements["achievementFanboyObtained"];
			GameVars.achievementPenguliciousObtained = achievements["achievementPenguliciousObtained"];
			GameVars.achievementHeartOfSteelObtained = achievements["achievementHeartOfSteelObtained"];
			GameVars.achievementDidSomeoneOrderFrozenPenguinObtained = achievements["achievementDidSomeoneOrderFrozenPenguinObtained"];
			GameVars.achievementAllHailToTheLeaderObtained = achievements["achievementAllHailToTheLeaderObtained"];
			
			GameVars.deadCounter = achievements["deadCounter"];
			GameVars.evadeWithPanicCounter = achievements["evadeWithPanicCounter"];
			GameVars.evadeWithoutPanicCounter = achievements["evadeWithoutPanicCounter"];
			GameVars.eatenCounter = achievements["eatenCounter"];
			GameVars.newGameCounter = achievements["newGameCounter"];
			GameVars.completeGameCounter = achievements["completeGameCounter"];
			GameVars.gameOverCounter = achievements["gameOverCounter"];
			GameVars.surfCounter = achievements["surfCounter"];
			GameVars.panicCounter = achievements["panicCounter"];
			GameVars.stingCounter = achievements["stingCounter"];
			GameVars.achievementPermanentPoint = achievements["achievementPermanentPoint"];
			GameVars.achievementPermanentXP = achievements["achievementPermanentXP"];
			GameVars.toxicCounter = achievements["toxicCounter"];
		}
		*/
		/*
		private function getFreeRoam(userData:MochiUserData):void 	
		{
			if( userData.error )
				return;
			
			if( userData.data is Array )
				GameVars.freeRoamLevel = userData.data;
		}
		*/
		/*
		public function loadData():void
		{
			if( !GameVars.loggedIn )
				return;
			
			// upgrade data
			MochiUserData.get("upgrades", getUpgrades);
			
			// achievements
			MochiUserData.get("achievements", getAchievements);
			
			
			// free roam
			MochiUserData.get("freeRoamLevels", getFreeRoam);
		}
		*/
		static public function getInstance(): Serializer
		{
			if( m_instance == null ){
				m_instance = new Serializer( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}