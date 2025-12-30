require 'zeitwerk'
require 'nokogiri'
require 'kramdown'
require 'fileutils'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

class Flora

  def initialize(dir)
    dir = Pathname.new(dir)

    # Inject Lilac into the Kernel so it's available everywhere. Just
    # instance_eval isn't enough because it'll be missing in lib/ code.
    #
    # TODO: is there a less disruptive way to do this?
    Kernel.prepend(Flora::Lilac)

    # The classes that are pluggable get their own instances to avoid conflicting
    # with other instances of Flora in the same process. This is mostly for the
    # unit tests. Maybe one day we can use Ruby::Box or something here instead.
    @config_class = Class.new(Config)
    @project_class = Class.new(Project)
    @factory_class = Class.new(Factory)

    @config = @config_class.new(dir.join('_config.rb'), self)
    @project = @project_class.new(dir, @config)
    @factory = @factory_class.new(@project, @config)
  end


  def build(out)
    @factory.assemble(Pathname.new(out))
  end


  def reload_project
    @project.reload
  end


  # TODO: it would be nice if this wasn't exposed here. It's just for Config#plugin.
  def load_plugin(mod)
    @config_class.include(mod::Config) if defined?(mod::Config)
    @project_class.include(mod::ProjectMethods) if defined?(mod::ProjectMethods)
    @factory_class.include(mod::FactoryMethods) if defined?(mod::FactoryMethods)

    # TODO: make this a little more resilient (like the other classes).
    Flora::Project::Blueprint.include(mod::BlueprintMethods) if defined?(mod::BlueprintMethods)
  end

end

# Built-in Blueprints need to be explicitly loaded or else they won't show up
# in Blueprint.types.
loader.load_file("#{__dir__}/flora/project/blueprint/ruby_html.rb")
loader.load_file("#{__dir__}/flora/project/blueprint/markdown.rb")
