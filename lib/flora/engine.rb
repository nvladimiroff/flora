class Flora::Engine

  attr_reader(:out_dir)


  def initialize(path, out_dir)
    @path = Pathname.new(path)
    @out_dir = Pathname.new(out_dir)
    @out_dir.mkdir unless @out_dir.exist?
  end


  def build
    Page.each(@path) do |page|
      @out_dir.join(page.outname).write(page.render)
    end
  end

end
