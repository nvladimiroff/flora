require 'zeitwerk'
require 'nokogiri'
require 'kramdown'
require 'fileutils'
require 'logger'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

class Flora

  attr_writer(:logger)


  def initialize(dir)
    dir = Pathname.new(dir)

    @logger = Logger.new(STDOUT, level: ENV['FLORA_LOG'] || 'info')
    @plugin_manager = PluginManager.new

    # Inject Lilac into the Kernel so it's available everywhere. Just
    # instance_eval isn't enough because it'll be missing in lib/ code.
    #
    # TODO: is there a less disruptive way to do this?
    @plugin_manager.global_load(Flora::Lilac)

    # The classes that are pluggable get their own instances to avoid conflicting
    # with other instances of Flora in the same process. This is mostly for the
    # unit tests. Maybe one day we can use Ruby::Box or something here instead.
    @config_class = @plugin_manager.create_pluggable_class(Config)
    @project_class = @plugin_manager.create_pluggable_class(Project)
    @factory_class = @plugin_manager.create_pluggable_class(Factory)

    # This has to be loaded before Config so Config can reference lib/ code.
    @project_loader = Zeitwerk::Loader.new
    if dir.join('lib').exist?
      @project_loader.push_dir(dir.join('lib'))
    end
    @project_loader.enable_reloading
    @project_loader.setup

    @config = @config_class.new(dir.join('_config.rb'), @plugin_manager)
    @config.load

    @project = @project_class.new(dir, @project_loader, @config)
    @factory = @factory_class.new(@project, @config, @logger)
  end


  def build(out)
    duration = bench do
      @factory.assemble(Pathname.new(out))
    end
    @logger.info("[Flora] Built project (#{duration}s)")
  end


  def reload_project
    duration = bench do
      @project.reload
    end
    @logger.info("[Flora] Reloaded project (#{duration}s)")
  end


  private

    def bench
      now = Time.now.utc
      yield
      Time.now.utc - now
    end

end

# Built-in Blueprints need to be explicitly loaded or else they won't show up
# in Blueprint.types.
loader.load_file("#{__dir__}/flora/project/blueprint/ruby_html.rb")
loader.load_file("#{__dir__}/flora/project/blueprint/markdown.rb")
