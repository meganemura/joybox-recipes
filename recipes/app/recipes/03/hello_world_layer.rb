class HelloWorldLayer < Joybox::Core::LayerColor

  scene

  def on_enter
    player = Sprite.new(
      :file_name => 'recipes/recipe03/monkey01.png',
      :rect => [[0, 0], [100, 135]]
    )
    player.position = [player.contentSize.width.half * 3, Screen.half_height]
    player.tag = 1
    self << player

    schedule('game_logic', :interval => 3.0)
    schedule('update')

    self.TouchMode = KCCTouchesAllAtOnce
    self.TouchEnabled = true # No need for Joybox (called in "on_touches_*" methods)

    on_touches_began do |touches, event|
      touches_began(touches, event)
    end


    # MenuImage button (recipe 10)
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


    # Sprite button (recipe 10)
    item_1 = Sprite.new(:file_name => 'recipes/recipe10/button_close.png')
    item_2 = Sprite.new(:file_name => 'recipes/recipe10/button_close.png')
    item_2.color = [102, 102, 102]
    close_item_2 = CCMenuItemSprite.itemWithNormalSprite(item_1, selectedSprite: item_2, block: lambda {|menu_item| menu_close })
    close_item_2.position = [Screen.width - close_item_2.contentSize.half_width * 3, close_item_2.contentSize.half_height]
    menu_2 = Menu.new(:items => [close_item_2])
    menu_2.position = [0, 0]
    self << menu_2


    # Toggle button (recipe 11)
    item_off_1 = Sprite.new(:file_name => 'recipes/recipe11/button_check_off.png')
    item_off_2 = Sprite.new(:file_name => 'recipes/recipe11/button_check_off.png')
    item_off_2.color = [102, 102, 102]
    menu_item_off = CCMenuItemSprite.itemWithNormalSprite(item_off_1, selectedSprite: item_off_2)

    item_on_1 = Sprite.new(:file_name => 'recipes/recipe11/button_check_on.png')
    item_on_2 = Sprite.new(:file_name => 'recipes/recipe11/button_check_on.png')
    item_on_2.color = [102, 102, 102]
    menu_item_on = CCMenuItemSprite.itemWithNormalSprite(item_on_1, selectedSprite: item_on_2)

    # toggle_item = CCMenuItemToggle.itemWithTarget(, selector: 'change_mode', items: [menu_item_off, menu_item_on])
    toggle_item = CCMenuItemToggle.itemWithItems([menu_item_off, menu_item_on], block: lambda {|item| change_mode(item) })
    toggle_item.position = [close_item.contentSize.half_width, Screen.height - close_item.contentSize.half_height]

    toggle_menu = Menu.new(:items => [toggle_item])
    toggle_menu.position = [0, 0]
    toggle_menu.tag = 3
    self << toggle_menu

  end

  def menu_close
    Joybox.director.end
    exit
  end

  def change_mode(item)
    selected_index = item.selectedIndex
    puts selected_index
    player = self.getChildByTag(1)
    player.visible = (selected_index == 0)
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
