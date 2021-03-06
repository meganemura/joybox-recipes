class AppDelegate

  Settings = NSUserDefaults.standardUserDefaults

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @director = Joybox::Configuration.setup do
      director display_stats: true
    end

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@director)
    @navigation_controller.navigationBarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.setRootViewController(@navigation_controller)
    @window.makeKeyAndVisible

    Settings[:a] = "A"
    p Settings[:a].tap { |x| p x.class }
    # => String
    # => "A"

    Settings[:b] = 1
    p Settings[:b].tap { |x| p x.class }
    # => Fixnum
    # => 1

    Settings[:c] = 1.0
    p Settings[:c].tap { |x| p x.class }
    # => Float
    # => 1.0

    Settings.registerDefaults({:d => :D})
    p Settings[:d].tap { |x| p x.class }
    # => String
    # => "D"

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
