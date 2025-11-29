class Flora::Engine

  attr_reader(:out_dir)


  def initialize(path, out_dir)
    @path = Pathname.new(path)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?

    Kernel.include(Flora::Engine::Page::Html)
  end


  def build
    with_load_path(@path) do
      Page.each(@path) do |page|
        @out_dir.join(page.outname).write(page.render)
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
