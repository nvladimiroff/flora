module Flora::Plugins::Blog

  module ProjectMethods

    def posts
      @dir.glob('posts/**').map { Post.new(it, @dir) }.sort_by(&:date).reverse
    end

  end


  module BlueprintMethods

    def posts
      @project.posts
    end

  end

end
