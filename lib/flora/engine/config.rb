class Flora::Engine::Config

  def initialize(plugin_loader)
    @plugin_loader = plugin_loader
  end


  def plugin(mod)
    @plugin_loader.load_plugin(mod)
  end

end
