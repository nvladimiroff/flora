class Flora::PluginManager

  def initialize(logger)
    @logger = logger
    @pluggables = {}
  end


  def create_pluggable_class(klass)
    @pluggables[klass] = Class.new(klass)
  end


  def load(mod)
    @pluggables.each do |base_class, anon_class|
      name = "#{base_class.name.split('::').last}Methods"
      anon_class.include(mod.const_get(name)) if mod.const_defined?(name)
    end

    @logger.debug("[Flora] Plugin #{mod} loaded")
  end


  def global_load(mod)
    Kernel.include(mod)
  end

end
