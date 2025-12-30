module Flora::Plugins::Blog

  class BlogPost < Flora::Project::Blueprint::Markdown

    def self.recognize(file, config)
      file.fnmatch?('posts/*.md')
    end


    def initialize(file, project)
      super(file, project)

      @post = Post.new(file, project.dir)
    end


    private

      def render_tree
      end

  end


  module ProjectMethods

    def posts
      @dir.glob('posts/**.md').map { Post.new(it, @dir) }.sort_by(&:date).reverse
    end

  end


  module BlueprintMethods

    def posts
      @project.posts
    end

  end

end
