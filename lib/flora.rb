require 'zeitwerk'
require 'nokogiri'
require 'kramdown'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

class Flora

  def initialize(dir)
    dir = Pathname.new(dir)

    # Inject HTML helpers into Kernel so they're available everywhere. Just
    # instance_eval isn't enough because they'll be missing in lib/ code.
    #
    # TODO: is there a less disruptive way to do this?
    Kernel.prepend(Flora::Blueprint::Page::Html)

    # The classes that are pluggable get their own instances to avoid conflicting
    # with other instances of Flora in the same process. This is mostly for the
    # unit tests. Maybe one day we can use Ruby::Box or something here instead.
    @config_class = Class.new(Config)
    @factory_class = Class.new(Factory)

    # Page plugins get mixed in directly to the page instances by Blueprint.
    @page_modules = []

    @config = @config_class.new(dir.join('_config.rb'), self)
    @blueprint = Blueprint.new(dir, @config, @page_modules)
    @factory = @factory_class.new(@blueprint, @config)
  end


  def build(out)
    @factory.assemble(Pathname.new(out))
  end


  def reload_blueprint
    @blueprint.reload
  end


  # TODO: it would be nice if this wasn't exposed here. It's just for Config#plugin.
  def load_plugin(mod)
    @factory_class.include(mod::FactoryMethods) if defined?(mod::FactoryMethods)
    @config_class.include(mod::Config) if defined?(mod::Config)

    @page_modules << mod::PageMethods if defined?(mod::PageMethods)
  end

end
