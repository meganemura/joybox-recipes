class HelloWorldLayer < Joybox::Core::LayerColor

  scene

  attr_accessor :points

  def on_enter

    # Recipe: 03
    player = Sprite.new(
      :file_name => 'recipes/recipe03/monkey01.png',
      :rect => [[0, 0], [100, 135]]
    )
    player.position = [player.contentSize.width.half * 3, Screen.half_height]
    player.tag = 1
    self << player


    # Recipe: 04
    schedule('game_logic', :interval => 3.0)


    # Recipe: 09
    schedule('update')


    # Recipe: 07
    self.TouchMode = KCCTouchesAllAtOnce
    self.TouchEnabled = true # No need for Joybox (called in "on_touches_*" methods)

    on_touches_began do |touches, event|
      touches_began(touches, event)
    end


    # Recipe: 10
    #   Using MenuImage button
    close_item = MenuImage.new(
      :image_file_name => 'recipes/recipe10/button_close.png',
      :selected_image_file_name => 'recipes/recipe10/button_close_pressed.png',
      :disabled_image_file_name => 'recipes/recipe10/button_close_pressed.png') do |menu_item|
        menu_close
    end
    close_item.position = [Screen.width - close_item.contentSize.half_width, close_item.contentSize.half_height]
    menu = Menu.new(:items => [close_item])
    menu.position = [0, 0]
    self << menu

    #   Using Sprite button
    item_1 = Sprite.new(:file_name => 'recipes/recipe10/button_close.png')
    item_2 = Sprite.new(:file_name => 'recipes/recipe10/button_close.png')
    item_2.color = [102, 102, 102]
    close_item_2 = CCMenuItemSprite.itemWithNormalSprite(item_1, selectedSprite: item_2, block: lambda {|menu_item| menu_close })
    close_item_2.position = [Screen.width - close_item_2.contentSize.half_width * 3, close_item_2.contentSize.half_height]
    menu_2 = Menu.new(:items => [close_item_2])
    menu_2.position = [0, 0]
    self << menu_2


    # Recipe: 11
    #   Toggle button
    item_off_1 = Sprite.new(:file_name => 'recipes/recipe11/button_check_off.png')
    item_off_2 = Sprite.new(:file_name => 'recipes/recipe11/button_check_off.png')
    item_off_2.color = [102, 102, 102]
    menu_item_off = CCMenuItemSprite.itemWithNormalSprite(item_off_1, selectedSprite: item_off_2)

    item_on_1 = Sprite.new(:file_name => 'recipes/recipe11/button_check_on.png')
    item_on_2 = Sprite.new(:file_name => 'recipes/recipe11/button_check_on.png')
    item_on_2.color = [102, 102, 102]
    menu_item_on = CCMenuItemSprite.itemWithNormalSprite(item_on_1, selectedSprite: item_on_2)

    # TODO: create example using itemWithTarget
    # toggle_item = CCMenuItemToggle.itemWithTarget(self, selector: 'change_mode', items: [menu_item_off, menu_item_on])
    toggle_item = CCMenuItemToggle.itemWithItems([menu_item_off, menu_item_on], block: lambda {|item| change_mode(item) })
    toggle_item.position = [close_item.contentSize.half_width, Screen.height - close_item.contentSize.half_height]

    toggle_menu = Menu.new(:items => [toggle_item])
    toggle_menu.position = [0, 0]
    toggle_menu.tag = 3
    self << toggle_menu


    # Recipe: 12
    #   Score strings
    score_label = Label.new(:text => 'SCORE', :font_name => 'arial', :font_size => 48)
    score_label.position = [Screen.half_width, Screen.height - score_label.contentSize.half_height]
    score_label.tag = 10
    self << score_label

    #   Score point
    points_label = Label.new(:text => '0', :fond_name => 'arial', :font_size => 48)
    points_label.position = [score_label.position.x + score_label.contentSize.width, Screen.height - points_label.contentSize.half_height]
    points_label.tag = 11
    self << points_label

    @points ||= 0
  end

  # Recipe: 10
  def menu_close
    Joybox.director.end
    exit
  end

  # Recipe: 11
  def change_mode(item)
    player = self.getChildByTag(1)
    player.visible = (item.selectedIndex == 0)
  end

  def game_logic
    add_food
  end

  def add_food

    # Recipe: 04
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


    # Recipe: 13

    # Recipe: 13-2
    #   scale_action = Scale.to(:scale => 4.0, :duration => duration)
    #   rotate_action = Rotate.by(:angle => 360, :duration => duration)
    # Run each actions
    #   food.run_action(scale_action)
    #   food.run_action(rotate_action)
    # or run multiple by using Spawn
    #   scale_rotate_actions = Spawn.with(:actions => [scale_action, rotate_action])
    #   food.run_action(scale_rotate_actions)

    @action_type ||= 0
    case @action_type
    when 1
      action_1 = Scale.to(:scale => 4.0, :duration => duration)
      food.run_action(action_1)
    when 2
      action_1 = Rotate.by(:angle => 360, :duration => duration)
      food.run_action(action_1)
    when 3
      action_1 = Scale.to(:scale => 4.0, :duration => duration)
      action_2 = Rotate.by(:angle => 360, :duration => duration)
      food.run_action(action_1)
      food.run_action(action_2)
    when 4
      action_1 = Rotate.by(:angle => 360, :duration => duration)
      action_2 = Repeat.forever(:action => action_1) # ?
      food.run_action(action_2)
    when 5
      action_1 = Jump.by(:position => [0, 0], :height => 100, :jumps => 5, :duration => duration)
      food.run_action(action_1)
    when 6
      action_1 = Scale.to(:scale => 4.0, :duration => duration / 2.0)
      action_2 = Jump.by(:position => [0, 0], :height => 100, :jumps => 3, :duration => duration / 2.0)
      action_sequence = Sequence.with(:actions => [action_1, action_2])
      food.run_action(action_sequence)
    when 7
      action_1 = Fade.in(:duration => duration / 2.0)
      action_2 = Fade.out(:duration => duration / 2.0) # Joybox doesn't support #reverse
      action_sequence = Sequence.with(:actions => [action_1, action_2])
      food.run_action(action_sequence)
    when 8
      food.stopAllActions()
      p1 = [Screen.width, Screen.height]
      p2 = [Screen.half_width, - Screen.height]
      p3 = [0, Screen.height]
      action_1 = Bezier.to(:bezier => [p1, p2, p3], :duration => duration)
      action_sequence = Sequence.with(:actions => [action_1, move_action_done])
      food.run_action(action_sequence)


    # Recipe: 14
    when 9
      food.stopAllActions()
      action_1 = Ease.in_out(:action => move_action, :rate => 3.0)
      action_sequence = Sequence.with(:actions => [action_1, move_action_done])
      food.run_action(action_sequence)
    when 10
      food.stopAllActions()
      action_1 = Ease.bounce_out(:action => move_action)
      action_sequence = Sequence.with(:actions => [action_1, move_action_done])
      food.run_action(action_sequence)
    when 11
      food.stopAllActions()
      action_1 = Ease.bounce_out(:action => move_action)
      action_sequence = Sequence.with(:actions => [action_1, move_action_done])
      food.run_action(action_sequence)

      action_2 = Jump.by(:position => [0, 0], :height => 100, :jumps => 5, :duration => duration)
      food.run_action(action_2)
    else
    end
    @action_type = (@action_type + 1) % 12

  end

  def sprite_move_finished(sender)
    sprite = sender

    # Recipe: 05-3
    self.removeChild(sprite)

    # Recipe: 05-4
    # sprite.visible = false

    # Recipe: 05-5
    # sprite.opacity = 0
  end

  # Recipe: 07
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
    # Recipe: 08
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


      # Recipe: 09
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

    @points += player.position.x / (Screen.width / 4) + 1
    label = self.getChildByTag(11)
    label.string = @points.to_i.to_s
  end

end
