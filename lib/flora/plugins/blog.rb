module Flora::Plugins::Blog

  module RubyPage

    def render
      @posts = @root.glob('posts/**').map { Post.new(it, @root) }

      super
    end

  end

end
