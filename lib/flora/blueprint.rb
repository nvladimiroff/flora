# A Blueprint is a project made with Flora. Blueprints can be turned into websites
# with a Factory.
class Flora::Blueprint

  attr_reader(:dir)

  IGNORES = ['.git/*', 'lib/*', '**_layout.rb', '_config.rb']


  def initialize(dir, config, page_modules = nil)
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


  # TODO: What do Blueprints have? Is it Pages? Is it Files? It it something else?
  # Good question to ask: what does a Factory need to assemble a Website? What does a Blueprint
  # tell it about? Pages are all (right now) the base class has, but consider static files too.
  # schematic?
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

        page = Page.for(file).new(file, self)
        @page_modules.each { |mod| page.extend(mod) }
        pages << page
      end

      pages
    end


    # TODO: this is duplicating logic from Page::for.
    def supported_file_type?(file)
      file.extname == '.rb' || file.extname == '.md'
    end


    def has_supporting_code?
      @dir.join('lib').exist?
    end

end
