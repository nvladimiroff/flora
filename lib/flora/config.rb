# This is the user-visible configuration class. It lives in ROOT/_config.rb.
class Flora::Config

  def initialize(file, plugin_manager)
    @file = file
    @plugin_manager = plugin_manager
  end


  def use(mod)
    @plugin_manager.load(mod)

    # TODO: ideally, this would live in PluginManager, but it needs to pass
    # Config.
    mod.loaded(self) if mod.respond_to?(:loaded)
  end


  def extend_view(mod)
    @plugin_manager.global_load(mod)
  end


  # :nodoc:
  def load
    return unless @file.exist?

    instance_eval(@file.read)
  end

end
