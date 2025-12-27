class Flora::Engine

  def initialize(path)
    @path = Pathname.new(path)
    @config = Config.new(self)

    Kernel.prepend(Flora::Engine::Page::Html)
  end


  def configure
    with_load_path(@path) do
      config_file = @path.join('_config.rb')
      @config.instance_eval(config_file.read)  if config_file.exist?
    end
  end


  def build(out_dir)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?

    with_load_path(@path) do
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

  end


  def load_plugin(mod)
    self.class.include(mod::EngineMethods) if defined?(mod::EngineMethods)
    Page::RubyPage.include(mod::PageMethods) if defined?(mod::PageMethods)
    Config.include(mod::Config) if defined?(mod::Config)
  end


  private

    def with_load_path(path)
      $LOAD_PATH << path.to_s
      yield
      $LOAD_PATH.delete(path.to_s)
    end

end
