class Flora::Engine

  attr_reader(:out_dir)


  def initialize(path, out_dir)
    @path = Pathname.new(path)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?

    Kernel.prepend(Flora::Engine::Page::Html)
  end


  def build
    with_load_path(@path) do
      Page.each(@path) do |page|
        layouts = []
        page.dir.ascend do |dir|
          maybe_layout = dir.join('_layout.rb')
          layouts << maybe_layout if maybe_layout.exist?
          break if dir == @path
        end
        html = page.render(Page::Layout.new(layouts))
        out_filename = @out_dir.join(page.outname(@path))
        out_filename.dirname.mkdir unless out_filename.dirname.exist?
        out_filename.write(html)
      end
    end
  end


  private

    def with_load_path(path)
      $LOAD_PATH << path.to_s
      yield
      $LOAD_PATH.delete(path.to_s)
    end

end
