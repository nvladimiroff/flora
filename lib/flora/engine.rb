class Flora::Engine

  attr_reader(:out_dir)


  def initialize(path, out_dir)
    @path = Pathname.new(path)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?
    @config = Config.new

    Kernel.prepend(Flora::Engine::Page::Html)
  end


  def build
    with_load_path(@path) do
      config_file = @path.join('_config.rb')
      @config.instance_eval(config_file.read)  if config_file.exist?

      init_plugins

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

    Dir[@path.join('public/**')].each do |public_file|
      out_filename = @out_dir.join(Pathname.new(public_file).relative_path_from(@path))
      out_filename.dirname.mkdir unless out_filename.dirname.exist?
      out_filename.write(File.read(public_file))
    end
  end


  private

    def with_load_path(path)
      $LOAD_PATH << path.to_s
      yield
      $LOAD_PATH.delete(path.to_s)
    end


    def init_plugins
      @config.plugins.each do |plugin|
        Page.include(plugin::Page) if self.class.const_defined?("#{plugin}::Page")
        Page::RubyPage.include(plugin::RubyPage) if self.class.const_defined?("#{plugin}::RubyPage")
      end
    end

end
