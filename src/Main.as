package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.system.Security;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	
	import com.shade.math.OpMath;
	
	//import mochi.as3.*;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class Main extends MovieClip
	{
		
		public static var GAME_OPTIONS:Object = {id: "e1984e04a1356679", res:"640x480"};
		
		private var m_lastFrameTime:int;
		
		public function Main():void 
		{
			super();
            // This initializes if the preloader is turned off.
            if (stage != null) {
                init(false);
            }
		}
		
		public function init(did_load:Boolean):void 
		{
           	//MochiSocial.addEventListener(MochiSocial.LOGGED_IN, onLogin);
            //MochiSocial.addEventListener(MochiSocial.LOGGED_OUT, onLogout);
			//MochiSocial.addEventListener(MochiSocial.ERROR, onError);
			
			//MochiServices.connect("e1984e04a1356679", root);
			
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			mouseChildren = true;

			/* init sub engines */
			GameVars.rootClip = this;
			OpMath.initialize();
			SoundManager.getInstance().sfxVolume = 0.5;
			SoundManager.getInstance().musicVolume = 0.75;
			ParticleManager.getInstance().initialize( stage.stageWidth, stage.stageHeight );
			
			/* initialize game state */
			GameMenu.getInstance().initialize(this);
			GameLoop.getInstance().initialize(this);
			GameUpgrade.getInstance().initialize(this);
			EmptyState.getInstance().initialize(this);
			InGameCredits.getInstance().initialize(this);
			AchievementMenu.getInstance().initialize(this);
			GameHowToPlay.getInstance().initialize(this);
			SiteLockScreen.getInstance().initialize(this);
			GameSelectLevel.getInstance().initialize(this);
			
			/* load serializer data */
			//Serializer.getInstance().loadData();
			
			/* set starting state */
			GameStateManager.getInstance().setState( GameMenu.getInstance() );
			
			/* start simulation */
			m_lastFrameTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, updateScene);
		}
		
		private function updateScene(event:Event):void 
		{
			var elapsedTime:int=getTimer()-m_lastFrameTime;
			m_lastFrameTime += elapsedTime;
			
			GameStateManager.getInstance().update(elapsedTime);
		}
		
		private function siteLockTest(host:String):Boolean
		{
			var url:String=stage.loaderInfo.url;
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			
			// disable this section for subdomain
			var lastDot:Number = domain.lastIndexOf(".")-1;
			var domEnd:Number = domain.lastIndexOf(".", lastDot)+1;
			domain = domain.substring(domEnd, domain.length);
			
			return ( domain == host );
		}
		
		private function onLogin(event:Object):void 
		{
			GameVars.loggedIn = true;
			//Serializer.getInstance().loadData();
        }

        private function onLogout(event:Object):void 
		{
			GameVars.loggedIn = false;
        }
		
		private function onError(event:Object):void
		{
			trace("login error");
		}
	}
}