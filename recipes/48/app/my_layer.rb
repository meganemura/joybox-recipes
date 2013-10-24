class MyLayer < Joybox::Core::Layer

  scene

  def on_enter
    audio_effect = AudioEffect.new
    audio_effect.add(:effect => :sound, :file_name => 'key_flanger.caf')
    id = audio_effect.play(:sound)
    sleep 1
    audio_effect.volume = 0.5
    sleep 1
    audio_effect.stop(id)
    audio_effect.remove(id)
  end
end
