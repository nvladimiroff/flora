module Flora::Plugins::Blog

  module PageMethods

    def posts
      @root.glob('posts/**').map { Post.new(it, @root) }
    end

  end

end
