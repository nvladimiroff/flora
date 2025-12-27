class Flora::Engine

  def initialize(path)
    @path = Pathname.new(path)
    @config = Config.new(self)

    @site_loader = Zeitwerk::Loader.new

    if site_has_supporting_code?
      setup_site_loader
    end

    Kernel.prepend(Flora::Engine::Page::Html)
  end


  def configure
    config_file = @path.join('_config.rb')
    @config.instance_eval(config_file.read)  if config_file.exist?
  end


  def build(out_dir)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?

    Page.each(@path) do |page|
      layouts = []
      page.dir.ascend do |dir|
        maybe_layout = dir.join('_layout.rb')
        layouts << maybe_layout if maybe_layout.exist?
        break if dir == @path
      end

      $flora_added = []
      tree = Page::Layout.new(layouts).render do
        page.render
      end
      html = Page::Html.to_html(tree)

      out_filename = @out_dir.join(page.outname)
      out_filename.dirname.mkdir unless out_filename.dirname.exist?
      out_filename.write(html)
    end

  end


  def load_plugin(mod)
    self.class.include(mod::EngineMethods) if defined?(mod::EngineMethods)
    Page::RubyPage.include(mod::PageMethods) if defined?(mod::PageMethods)
    Config.include(mod::Config) if defined?(mod::Config)
  end


  private

    def site_has_supporting_code?
      @path.join('lib').exist?
    end


    def setup_site_loader
      @site_loader.push_dir(@path.join('lib').to_s)
      @site_loader.enable_reloading
      @site_loader.setup
    end

end
