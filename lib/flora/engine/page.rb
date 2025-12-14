# A page is something can be turned into HTML. It might also have a layout to render into.
class Flora::Engine::Page

  IGNORES = ['.git/*', 'lib/*', '**_layout.rb', '_config.rb']


  class << self

    def each(path)
      path.find do |file|
        next if IGNORES.any? { file.fnmatch((path / it).to_s) }
        next if file.directory?

        yield(self.for(path, file))
      end
    end


    def for(root, file)
      case file.extname
      when '.rb'
        RubyPage.new(root, file)
      when '.md'
        MarkdownPage.new(root, file)
      end
    end

  end


  def initialize(root, file)
    @root = root
    @file = file
  end


  def render
  end


  def outname
    # TODO: this might sub something in the middle instead of just the ext.
    @file.relative_path_from(@root).sub(@file.extname, '.html')
  end


  def url
    @file.relative_path_from(@root).sub(@file.extname, '')
  end


  def dir
    @file.dirname
  end

end
