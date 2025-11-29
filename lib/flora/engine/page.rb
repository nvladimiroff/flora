class Flora::Engine::Page

  IGNORES = ['.git/*', 'lib/*']


  def self.each(path)
    path.find do |file|
      next if IGNORES.any? { file.fnmatch((path / it).to_s) }
      next if file.directory?

      yield(self.for(file))
    end
  end


  def self.for(path)
    case path.extname
    when '.rb'
      RubyPage.new(path)
    when '.md'
      MarkdownPage.new(path)
    end
  end


  def initialize(file)
    @file = file
  end


  def outname
    # TODO: this might sub something in the middle instead of just the ext.
    @file.basename.sub(@file.extname, '.html')
  end

end
