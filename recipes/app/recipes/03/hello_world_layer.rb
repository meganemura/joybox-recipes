class HelloWorldLayer < Joybox::Core::LayerColor

  scene

  def self.new(options = {})
    layer = super(options)
    player = Sprite.new(
      :file_name => 'recipes/recipe03/monkey01.png',
      :rect => [[0, 0], [100, 135]]
    )
    player.position = [player.contentSize.width.half * 3, Screen.half_height]
    player.tag = 1
    layer << player

    layer.schedule('game_logic', :interval => 3.0)
    layer.TouchMode = KCCTouchesAllAtOnce
    layer.TouchEnabled = true # No need for Joybox (called in "on_touches_*" methods)

    layer.on_touches_began do |touches, event|
      layer.touches_began(touches, event)
    end

    layer
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
    move_action = Move.to(
      :position => [food.contentSize.half_width * 3, food.position.y],
      :duration => duration
    )
    move_action_done = Callback.with do |node|
      sprite_move_finished(node)
    end
    move_sequence= Sequence.with(:actions => [move_action, move_action_done])
    food.run_action(move_sequence)
  end

  def sprite_move_finished(sender)
    sprite = sender

    # Recipe 05-3
    self.removeChild(sprite)

    # Recipe 05-4
    # sprite.visible = false

    # Recipe 05-5
    # sprite.opacity = 0
  end

  def touches_began(touches, event)
    touch = touches.any_object
    location = Joybox.director.convertTouchToGL(touch)

    player = self.getChildByTag(1)

    length = jbpDistance(
      jbp(location.x, location.y),
      jbp(player.position.x, player.position.y)
    )
    duration = length / Screen.width * 1.5

    move_action = Move.to(:position => location, :duration => duration)
    player.run_action(move_action)
  end

end
