module Flora::Plugins::Blog

  class BlogPost < Flora::Project::Blueprint::Markdown

    def self.recognize(file, config)
      file.fnmatch?("#{config.blog[:dir] || 'posts'}/*.md")
    end


    def initialize(file, project)
      super(file, project)

      @post = Post.new(file, project.dir)
    end

  end


  class Feed

    def initialize(posts, config)
      @posts = posts
      @config = config
    end


    def render
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.feed(xmlns: 'http://www.w3.org/2005/Atom') do
          xml.generator('Flora')
          nokogiri_tag(xml, :title, @config.blog[:title])
          xml.updated(last_updated.iso8601)
          nokogiri_tag(xml, :link, href: @config.blog[:url])
          xml.id(@config.blog[:url])
          xml.author do
            xml.name(@config.blog[:author])
          end

          @posts.each { to_entry(xml, it) }
        end
      end

      builder.to_xml
    end


    private

      def full_url(post)
        @config.blog[:url] + post.url
      end


      def last_updated
        @posts[0].date
      end


      def to_entry(xml, post)
        xml.entry do
          xml.id(full_url(post))
          nokogiri_tag(xml, :title, post.title)
          # TODO: actually support published vs updated.
          xml.updated(post.date.iso8601)
          xml.published(post.date.iso8601)
          nokogiri_tag(xml, :link, rel: 'alternate', href: full_url(post))
        end
      end


      # Nokogiri's builder uses method_missing, and some of Lilac's tags are
      # named the same as some of the Atom tags we want to use which causes
      # conflicts. Use this method to get around that!
      def nokogiri_tag(xml, tag, *args, **opts, &block)
        xml.method_missing(tag, *args, **opts, &block)
      end

  end


  module ProjectMethods

    def self.included(base)
      base.class_eval do
        blueprint_classes.prepend(Flora::Plugins::Blog::BlogPost)
      end
    end


    def posts
      @dir.glob("#{@config.blog[:dir] || 'posts'}/**.md").map do |p|
        Post.new(p, @dir)
      end.sort_by(&:date).reverse
    end

  end


  module FactoryMethods

    def assemble(out_dir)
      super

      feed = Feed.new(@project.posts, @config)
      out_dir.join('feed.xml').write(feed.render)
    end

  end


  module ConfigMethods

    def self.included(base)
      base.class_eval do
        attr_accessor(:blog)
      end
    end

  end


  module ViewExtensions

    def posts
      @project.posts
    end

  end


  def self.loaded(config)
    config.extend_view(ViewExtensions)
  end

end
