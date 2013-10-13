class HelloWorldLayer < Joybox::Core::Layer

  scene

  def self.new
    layer = super
    player = Sprite.new(
      :file_name => 'recipes/recipe03/monkey01.png',
      :rect => [[0, 0], [100, 135]]
    )
    player.position = [player.contentSize.width.half * 3, Screen.half_height]
    player.tag = 1
    layer << player

    layer.schedule('game_logic', :interval => 3.0)
  end

  def game_logic
    add_food
  end

  def add_food
    food = Sprite.new(
      :file_name => 'recipes/recipe03/hamburger.png',
      :rect => [[0, 0], [36, 30]]
    )
    height = rand(Screen.height)
    food.position = [Screen.width + food.contentSize.half_width, height]
    food.tag = 2
    self << food

    # action continuous time
    duration = 2.0
    # create action
    move = Move.to(:position => [food.contentSize.half_width * 3, food.position.y], :duration => duration)
    food.run_action(move)
  end

end
