package com.sound
{
    import aurora.com.effects.TweenLite;
    import aurora.core.GlobalSetting;
    import aurora.event.events.SoundEvent;
    import aurora.media.sound.SoundManager;
    import aurora.timer.TimerManager;
    
    import com.preloader.PreUrl;
    
    import flash.events.TimerEvent;
    import flash.media.SoundMixer;
    import flash.utils.Timer;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
	/**
	 * 维护游戏中所有可能用到的音效和背景音乐播放 
	 * @author kevin
	 * 
	 */	
    public class MusicManager
    {
        /**
         * 当前音乐路径
         */
        public static var url:String;
		public static var fightMp3:String = "bg_fight.mp3";
		public static var soundMp3Url:String = "";
		public static var sceneVolume:Number = 80;
		public static var gameVolume:Number = 80;
		public static var openBackSound:Boolean = true;
		public static var openGameSound:Boolean = true;
		
		private static var index:int = 1;
		public static var maxNum:int = 2;
		
        public static function init():void
        {
            SoundManager.getInstance().registerScene(GlobalSetting.mainGame);
//			SoundManager.getInstance().setSoundAssetUrl(PreUrl.SOUND_ASSET);
			SoundManager.getInstance().setSoundUrl(PreUrl.SOUND_URL);
            SoundManager.getInstance().addEventListener(SoundEvent.PLAY_START, onStartPlay);
            SoundManager.getInstance().addEventListener(SoundEvent.PLAY_COMPLETE, onPlayComplete);
        }

		private static function onStartPlay(event:SoundEvent):void
		{
			SoundManager.getInstance().musicVolume = 0;
			TweenLite.killTweensOf(SoundManager.getInstance());
			TweenLite.to(SoundManager.getInstance(), 3, {musicVolume:sceneVolume/100});
		}
		
		private static function onPlayComplete(event:SoundEvent):void
		{
			++index;
			if(index >maxNum)
			{
				index = 1;
			}
			playMusic();
		}
		
        /**
         * 播放场景音乐
         */
        public static function playMusic():void
        {
			if(openBackSound)
			{
				if(index <=maxNum)
				{
					url = PreUrl.MUSICS_URL + "bg0" + index + ".mp3";
					SoundManager.getInstance().musicVolume = sceneVolume/100;
					SoundManager.getInstance().playMusic(url); 
				}
			}
        }

        public static function stopMusic():void
        {
			SoundManager.getInstance().musicVolume = 0;
			SoundManager.getInstance().stopMusic();
			url = "";
        }

		/**
		 * 播放音效 
		 * @param type
		 * @param isMp3
		 * @param suffix 后缀 .mp3 ,.wav
		 * @param soundVolume 单独控制音量 0~1 默认采用系统音量
		 * 
		 */		
        public static function playSound(type:String, isMp3:Boolean = true, suffix:String = ".mp3", soundVolume:Number = -1):void
        {
            if(openGameSound)
            {
                SoundManager.getInstance().soundVolume = gameVolume / 100;
                SoundManager.getInstance().playSound(type, isMp3, suffix, soundVolume);
            }
        }
		
		public static function stopSound():void
		{
			SoundManager.getInstance().soundVolume = 0;
		}
    }
}
