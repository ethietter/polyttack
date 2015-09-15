package 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class SoundHandler 
	{
		private var sound_effects_muted:Boolean = false;// false;
		private var music_muted:Boolean = false;// false;
		public var theme_song_playing:Boolean = false;
		
		private var music_pause_point:Object = {
			theme_song:Number,
			menu_song:Number
		};
		private var sounds_object:Object = {
			bullet_sound:BulletSound,
			grenade_sound:GrenadeSound,
			machine_gun_sound:MachineGunSound,
			spitter_sound:SpitterSound,
			freeze_sound:FreezeSound,
			switch_item_sound:SwitchItemSound,
			menu_song:MenuSong,
			theme_song:ThemeSong
		};
		private var sound_channels_object:Object = {
			bullet_sound:SoundChannel,
			grenade_sound:SoundChannel,
			machine_gun_sound:SoundChannel,
			spitter_sound:SoundChannel,
			freeze_sound:SoundChannel,
			switch_item_sound:SoundChannel,
			menu_song:SoundChannel,
			theme_song:SoundChannel
		}
		
		public function SoundHandler() {
			music_pause_point.theme_song = 0;
			music_pause_point.menu_song = 0;
			
			sound_channels_object.bullet_sound = new SoundChannel();
			sound_channels_object.grenade_sound = new SoundChannel();
			sound_channels_object.machine_gun_sound = new SoundChannel();
			sound_channels_object.spitter_sound = new SoundChannel();
			sound_channels_object.freeze_sound = new SoundChannel();
			sound_channels_object.switch_item_sound = new SoundChannel();
			sound_channels_object.menu_song = new SoundChannel();
			sound_channels_object.theme_song = new SoundChannel();
			
			sounds_object.bullet_sound = new BulletSound();
			sounds_object.grenade_sound = new GrenadeSound();
			sounds_object.machine_gun_sound = new MachineGunSound();
			sounds_object.spitter_sound = new SpitterSound();
			sounds_object.freeze_sound = new FreezeSound();
			sounds_object.switch_item_sound = new SwitchItemSound();
			sounds_object.menu_song = new MenuSong();
			sounds_object.theme_song = new ThemeSong();
		}
		
		public function playSound(key:String, loop:Boolean) {
			var repeats:int = 0;
			if (!sound_effects_muted) {
				if (loop) {
					repeats = 999999;
				}
				sound_channels_object[key] = sounds_object[key].play(0, repeats);
			}
		}
		
		public function toggleSoundEffects() {
			sound_effects_muted = !sound_effects_muted;
			return sound_effects_muted;
		}
		
		public function toggleMusic(key:String) {
			music_muted = !music_muted;
			if (music_muted) {
				pauseMusic(key);
			}
			else {
				resumeMusic(key);
			}
			return music_muted;
		}
		
		private function pauseMusic(key:String) {
			music_pause_point[key] = sound_channels_object[key].position;
			sound_channels_object[key].stop();
			if (key == "theme_song") {
				theme_song_playing = false;
			}
		}
		
		public function resumeMusic(key:String) {
			sound_channels_object[key] = sounds_object[key].play(music_pause_point[key], 999999);
			if (key == "theme_song") {
				theme_song_playing = true;
			}
		}
		
		public function stopSound(key:String) {
			sound_channels_object[key].stop();
			if (key == "theme_song") {
				theme_song_playing = false;
			}
		}
		
		public function musicMuted() {
			return music_muted;
		}
		
		public function sfxMuted() {
			return sound_effects_muted;
		}
		
	}
	
}