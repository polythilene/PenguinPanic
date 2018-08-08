package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	 import mochi.as3.*;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class Preloader extends MovieClip 
	{
		private var m_preloaderScreen:PreloaderScreen;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			
			m_preloaderScreen = new PreloaderScreen();
			addChild(m_preloaderScreen);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			var perc:Number = e.bytesLoaded / e.bytesTotal * 100;
			m_preloaderScreen.progressText.htmlText = String(Math.floor(perc)) + "%";
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void 
		{
			// hide loader
			removeChild(m_preloaderScreen);
			m_preloaderScreen = null;
			
			stop();
			
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	}
}