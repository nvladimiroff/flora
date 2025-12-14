class Flora::Engine::Page::RubyPage < Flora::Engine::Page

  def render
    super
    instance_eval(@file.read)
  end

end
