# Factories assemble Projects into Websites.
class Flora::Factory

  def initialize(project, config)
    @project = project
    @config = config
  end


  # Assemble the Project into a Website, and put it into out_dir.
  def assemble(out_dir)
    out_dir.mkdir unless out_dir.exist?

    @project.blueprints.each do |blueprint|
      out_filename = out_dir.join(blueprint.page_name)
      out_filename.dirname.mkdir unless out_filename.dirname.exist?
      out_filename.write(blueprint.render)
    end
  end

end
