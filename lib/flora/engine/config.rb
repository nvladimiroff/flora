class Flora::Engine::Config

  attr_reader(:plugins)


  def initialize
    @plugins = []
  end


  def plugin(mod)
    @plugins << mod
  end

end
