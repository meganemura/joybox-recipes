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
    layer.schedule('update')

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

  def update
    # Get monkey sprite (identified by tag=1)
    player = self.getChildByTag(1)
    # Detection region
    player_rect = [
      player.position.x - player.contentSize.width / 4,
      player.position.y - player.contentSize.height / 4,
      player.contentSize.half_width,
      player.contentSize.half_height,
    ].to_rect

    # Get hamburger sprite (identified by tag=2)
    food = self.getChildByTag(2)
    return unless food
    food_rect = [
      food.position.x - food.contentSize.half_width,
      food.position.y - food.contentSize.half_height,
      food.contentSize.width,
      food.contentSize.height,
    ].to_rect

    # Collision detection
    if CGRectIntersectsRect(player_rect, food_rect)
      self.removeChild(food)

      # Change monkey image to eat one
      player.texture = CCTextureCache.sharedTextureCache.addImage('recipes/recipe03/monkey02.png')

      # Call HelloWorld.eat after 0.1 second.
      self.scheduleOnce('eat', delay:0.1)
    end

  end

  def eat
    # Change monkey image to normal one
    player = self.getChildByTag(1)
    player.texture = CCTextureCache.sharedTextureCache.addImage('recipes/recipe03/monkey01.png')
  end

end
