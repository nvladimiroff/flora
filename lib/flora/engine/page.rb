# A page is something can be turned into HTML. It might also have a layout to render into.
class Flora::Engine::Page

  IGNORES = ['.git/*', 'lib/*', '**_layout.rb', '_config.rb']

  include PluginHooks


  class << self

    def each(path)
      path.find do |file|
        next if IGNORES.any? { file.fnmatch((path / it).to_s) }
        next if file.directory?

        yield(self.for(file))
      end
    end


    def for(path)
      case path.extname
      when '.rb'
        RubyPage.new(path)
      when '.md'
        MarkdownPage.new(path)
      end
    end

  end


  def initialize(file)
    @file = file
  end


  def outname(root)
    # TODO: this might sub something in the middle instead of just the ext.
    @file.relative_path_from(root).sub(@file.extname, '.html')
  end


  def dir
    @file.dirname
  end

end
