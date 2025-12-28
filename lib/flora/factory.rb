class Flora::Factory

  def initialize(blueprint, config)
    @blueprint = blueprint
    @config = config
  end


  # Assemble a blueprint and put it into a directory.
  def assemble(out_dir)
    out_dir.mkdir unless out_dir.exist?

    @blueprint.each_page do |page|
      relative_path = page.file.relative_path_from(@blueprint.dir)
      out_filename = out_dir.join(relative_path).sub_ext('.html')
      out_filename.dirname.mkdir unless out_filename.dirname.exist?
      out_filename.write(page.render)
    end
  end

end
