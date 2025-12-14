module TestPlugin

  module RubyPage

    def render
      @plugin_data = 'Hello plugin'
      super
    end

  end

end
