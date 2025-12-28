module Flora::Plugins::Blog

  module PageMethods

    def posts
      @blueprint.dir.glob('posts/**').map { Post.new(it, @blueprint.dir) }
    end

  end

end
