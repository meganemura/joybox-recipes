class HelloWorldLayer < Joybox::Core::Layer

  scene

  def self.new
    player = Sprite.new(
      :file_name => 'recipes/recipe03/monkey01.png',
      :rect => [[0, 0], [100, 135]]
    )
    player.position = [player.contentSize.width.half * 3, Screen.half_height]
    player.tag = 2
    layer = super
    layer << player

    layer
  end

end
