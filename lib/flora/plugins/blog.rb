module Flora::Plugins::Blog

  module BlueprintMethods

    def posts
      @dir.glob('posts/**').map { Post.new(it, @dir) }
    end

  end


  module PageMethods

    def posts
      @blueprint.posts
    end

  end

end
