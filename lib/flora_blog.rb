module FloraBlog

  module Page

    def before_render
      super

      return unless @path.fnmatch('index.rb')
      @posts =
    end

  end

end
