module TestPlugin

  module Page

    def before_render
      @plugin_data = 'Hello plugin'
    end

  end

end
