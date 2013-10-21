class MyLayer < Joybox::Core::Layer

  scene

  def on_enter
    300.times do
      sprite = Sprite.new(
        :file_name => 'recipes/recipe30/recipe30_uhhoi.png',
        :position  => [rand(Screen.width), rand(Screen.height)]
      )
      self << sprite

      fade = Fade.out(:duration => rand(100) / 10.0)
      sprite.run_action(fade)
    end
  end
end

class MyBatchNodeLayer < Joybox::Core::Layer

  scene

  def on_enter
    sprite_batch = SpriteBatch.new(
      :file_name => 'recipes/recipe30/recipe30_uhhoi.png',
      :capacity => 300
    )
    self << sprite_batch

    300.times do
      sprite = Sprite.new(:texture => sprite_batch.texture)
      sprite.position = [rand(Screen.width), rand(Screen.height)]
      sprite_batch << sprite

      fade = Fade.out(:duration => rand(100) / 10.0)
      sprite.run_action(fade)
    end
  end
end

