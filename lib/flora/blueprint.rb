class Flora::Blueprint

  attr_reader(:dir)

  IGNORES = ['.git/*', 'lib/*', '**_layout.rb', '_config.rb']


  def initialize(dir, config, page_modules)
    @dir = dir
    @config = config
    @page_modules = page_modules

    @pages = load_pages

    @loader = Zeitwerk::Loader.new
    if has_supporting_code?
      @loader.push_dir(@dir.join('lib').to_s)
    end
    @loader.enable_reloading
    @loader.setup
  end


  def each_page(&block)
    @pages.each(&block)
  end


  def reload
    @loader.reload
    @pages = load_pages
  end


  private

    def load_pages
      pages = []

      @dir.find do |file|
        next if IGNORES.any? { file.fnmatch((@dir / it).to_s) }
        next if file.directory?
        next unless supported_file_type?(file)

        route = file.relative_path_from(@dir).sub_ext('.html').to_s
        page = Page.for(file).new(self, file, route)
        @page_modules.each { |mod| page.extend(mod) }
        pages << page
      end

      pages
    end


    def supported_file_type?(file)
      file.extname == '.rb' || file.extname == '.md'
    end


    def has_supporting_code?
      @dir.join('lib').exist?
    end

end
