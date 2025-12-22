module FloraBlog

  module RubyPage

    def render
      @posts = @root.glob('posts/**').map { Post.new(it) }

      super
    end

  end

end
