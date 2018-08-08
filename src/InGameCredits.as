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
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class InGameCredits extends CGameState
	{
		static private var m_instance:InGameCredits;
		
		/* buffers */
		private var m_virtualCamera:VirtualCamera;
		private var m_musicChannel:CSoundObject;
		private var m_swarmAttractor:CSwarmAttractor;
		private var m_seaWater:DeepSea;
		private var m_creditsPlate:ScrollingCreditsPlate;
		private var m_timer:Timer;
			
		/* parameters */
		private var m_cameraZoomedOut:Boolean;
		private var m_allowPauseToggle:Boolean;
				
		public function InGameCredits(lock:SingletonLock) {}
		
		override public function enter(): void
		{
			m_seaWater = new DeepSea();								// create water BG
			
			/* Sea Water */
			m_seaWater.cacheAsBitmap = true;
			addChild(m_seaWater);
			GameVars.seaWater = m_seaWater;
			m_seaWater.y = 0;
			
			/* create camera */
			m_virtualCamera = new VirtualCamera();
			m_virtualCamera.width = 640;
			m_virtualCamera.height = 480;
			GameVars.cameraPos.y = 1200;
			addChild(m_virtualCamera);
			
			m_timer = new Timer(5000, 1000);
			m_timer.addEventListener(TimerEvent.TIMER, onTimer);
			m_timer.start();
			
			/* init particle manager */
			ParticleManager.getInstance().attach(m_owner);
			
			/* setup camera scroll */
			GameVars.currCameraScrollSpeed = GameVars.normalCameraScrollSpeed = 0.2;
			GameVars.streamCameraScrollSpeed = GameVars.normalCameraScrollSpeed * 1.55;
			
			/* event listeners */
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			/* play in-game sound */
			if( GameStateManager.getInstance().lastState == GameMenu.getInstance() )
				GameVars.menuMusic.stop();
			
			
			m_musicChannel = SoundManager.getInstance().playMusic("InGame_01", 1000);
			
			/* credits plate */
			m_creditsPlate = new ScrollingCreditsPlate();
			m_creditsPlate.x = 350;
			m_creditsPlate.y = 240;
			m_creditsPlate.alpha = 0.85;
			m_creditsPlate.gotoAndPlay(2);
			m_creditsPlate.scroller.thankyou.visible = true;
			stage.addChild(m_creditsPlate);
			
			FoodManager.getInstance().reset();
			PredatorManager.getInstance().reset();
			
			setCreditParams();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var tweenPos:int = OpMath.randomRange(0, 1200);
			TweenMax.to(GameVars.cameraPos, 4, { y:tweenPos } );
			
			if ( OpMath.randomNumber(100) < 30 )
			{
				var scale:Number = OpMath.randomRange(1, 1.25);
				TweenMax.to(m_virtualCamera, 4, { scaleX:scale, scaleY:scale } );
				TweenMax.to(GameVars.seaWater, 4, { scaleX:scale } );
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if( event.charCode == Keyboard.ESCAPE )
				GameStateManager.getInstance().setState( GameMenu.getInstance() );
		}
		
		override public function exit(): void
		{
			
			/* remove timer */
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			m_timer.stop();
			m_timer = null;
						
			/* event listeners */
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			/* stop music */
			m_musicChannel.stop();
			
			/* detach objects */
			stage.removeChild(m_creditsPlate);
			removeChild(m_seaWater);
			
			/* reset camera	*/
			m_virtualCamera.x = 320;
			m_virtualCamera.y = 240;
			removeChild(m_virtualCamera);	
			m_virtualCamera = null;
			
			PredatorManager.getInstance().clear();
			SeaManager.getInstance().clear();
			FoodManager.getInstance().clear();
			
			ParticleManager.getInstance().clear();
			ParticleManager.getInstance().detach();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
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
			m_seaWater.x = m_virtualCamera.x = GameVars.cameraPos.x;
				
			/* clip y */
			if ( GameVars.cameraPos.y < cameraHalfHeight + 20 )
				GameVars.cameraPos.y = cameraHalfHeight + 20;
			else if	( GameVars.cameraPos.y > m_seaWater.height - cameraHalfHeight - 20 )
				GameVars.cameraPos.y = m_seaWater.height - cameraHalfHeight - 20;
			
			m_virtualCamera.y = GameVars.cameraPos.y;
						
			ParticleManager.getInstance().update(elapsedTime);
			SeaManager.getInstance().update(elapsedTime);
			FoodManager.getInstance().update(elapsedTime);
			PredatorManager.getInstance().update(elapsedTime);
			
				
			if ( GameVars.cameraPos.y < cameraHalfHeight + 20 )
				GameVars.cameraPos.y = cameraHalfHeight + 20;
			else if	( GameVars.cameraPos.y > m_seaWater.height - cameraHalfHeight - 20 )
				GameVars.cameraPos.y = m_seaWater.height - cameraHalfHeight - 20;
				
			m_virtualCamera.y = GameVars.cameraPos.y;	
		}
		
		
		private function setCreditParams():void
		{
			GameVars.currCameraScrollSpeed = 0.1;
			GameVars.speedMultiplier = 1.0;
			
			
			GameVars.upgradeFriendFinderObtained = false;
			GameVars.minute = 10;
			GameVars.bystanders_spawn_rate = 50;
			GameVars.bystanders_interval = 5000;
			GameVars.krill_tier_one = 10;
			GameVars.krill_tier_two = 10;
			GameVars.krill_tier_three = 20;
			GameVars.smallfish_spawn_rate = 20;
			GameVars.smallfish_interval = 15000;
			GameVars.invincible_spawn_rate = 0;
			GameVars.invincible_interval = 10000;
			GameVars.multiplier_spawn_rate = 0;
			GameVars.multiplier_interval = 10000;
			GameVars.stream_interval = 10000;
			GameVars.stream_tier_one = 0;
			GameVars.stream_tier_two = 0;
			GameVars.stream_tier_three = 0;
			GameVars.anchor_spawn_rate = 0;
			GameVars.anchor_interval = 10000;
			GameVars.shard_spawn_rate = 10;
			GameVars.shard_interval = 10000;
			GameVars.jellyfish_spawn_rate = 30;
			GameVars.jellyfish_interval = 5000;
			GameVars.toxic_tier_one = 10;
			GameVars.toxic_tier_two = 10;
			GameVars.predator_interval_min = 25000;
			GameVars.predator_interval_max = 30000;
			GameVars.shark_spawn_rate = 5;
			GameVars.seal_spawn_rate = 5;
		}
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		 */
		
		static public function getInstance(): InGameCredits
		{
			if( m_instance == null ){
				m_instance = new InGameCredits( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}