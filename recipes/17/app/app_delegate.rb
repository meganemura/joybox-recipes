class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @director = Joybox::Configuration.setup do
      director display_stats: true
    end

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@director)
    @navigation_controller.navigationBarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.setRootViewController(@navigation_controller)
    @window.makeKeyAndVisible


    # Recipe: 17
    @director << Joybox::Core::LayerColor.new(:color => [  0,   0,   0])
    next_scene = Joybox::Core::LayerColor.new(:color => [255, 255, 255])
    ## Recipe: 17-2
    # scene = CCTransitionZoomFlipX.transitionWithDuration(1.0, :scene => next_scene)
    scene = CCTransitionMoveInT.transitionWithDuration(1.0, :scene => next_scene)
    @director.replace_scene(scene)


    true
  end

  def applicationWillResignActive(app)
    @director.pause if @navigation_controller.visibleViewController == @director
  end

  def applicationDidBecomeActive(app)
    @director.resume if @navigation_controller.visibleViewController == @director
  end

  def applicationDidEnterBackground(app)
    @director.stop_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillEnterForeground(app)
    @director.start_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillTerminate(app)
    @director.end
  end

  def applicationDidReceiveMemoryWarning(app)
    @director.purge_cached_data
  end

  def applicationSignificantTimeChange(app)
    @director.set_next_delta_time_zero true
  end
end
