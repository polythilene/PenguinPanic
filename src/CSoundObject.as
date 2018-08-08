package  
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSoundObject
	{
		private var m_sound:Sound;
		private var m_soundChannel:SoundChannel;
		private var m_isMusic:Boolean;
		private var m_isLoop:Boolean;
		
		public function CSoundObject(sound:Sound, isMusicData:Boolean=false) 
		{
			m_sound = sound;
			m_isMusic = isMusicData;
		}
		
		public function play(loop:int, transformer:SoundTransform):void
		{
			m_soundChannel = m_sound.play(0, loop, transformer);
			SoundManager.getInstance().addEventListener(SoundManager.MUSIC_VOLUME, volumeChanged);
		}
		
		private function volumeChanged(event:SoundEvent):void
		{
			var transform:SoundTransform = m_soundChannel.soundTransform;
            transform.volume = event.volume;
            m_soundChannel.soundTransform = transform;
		}
				
		public function stop():void
		{
			SoundManager.getInstance().removeEventListener(SoundManager.MUSIC_VOLUME, volumeChanged);
			m_soundChannel.stop();
		}
	}
}