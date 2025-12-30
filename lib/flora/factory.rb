# Factories assemble Projects into Websites.
class Flora::Factory

  def initialize(project, config, logger)
    @project = project
    @config = config
    @logger = logger
  end


  # Assemble the Project into a Website, and put it into out_dir.
  def assemble(out_dir)
    out_dir.mkdir unless out_dir.exist?

    @project.blueprints.each do |blueprint|
      out_filename = out_dir.join(blueprint.page_name)
      FileUtils.mkdir_p(out_filename.dirname) unless out_filename.dirname.exist?
      out_filename.write(blueprint.render)

      @logger.debug("[Flora] #{blueprint.file} => #{out_filename}")
    end
  end

end
