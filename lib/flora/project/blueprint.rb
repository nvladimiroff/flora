# A Blueprint is something can be rendered into a page. Sometimes a Blueprint
# looks very different than the page it renders into, but other times (like for
# static files), nothing changes.
class Flora::Project::Blueprint

  attr_reader(:file)


  # Returns true if this Blueprint is appropriate for the file.
  #
  # TODO: should this be an instance method somewhere instead?
  def self.recognize(file, config)
    # Override in subclasses!

    false
  end


  def initialize(file, project)
    @file = file
    @project = project
  end


  # The name of the page this Blueprint makes. By default this is just the
  # filename, but .html, but subclasses can override this.
  def page_name
    @file.relative_path_from(@project.dir).sub_ext('.html').to_s
  end


  # Render a Blueprint into a page for a Website. This is the String contents
  # of whatever the page in the final Website looks like.
  def render
    # Override in subclasses!
  end

end
