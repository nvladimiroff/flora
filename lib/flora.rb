require 'zeitwerk'
require 'nokogiri'
require 'kramdown'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

class Flora

  def initialize(dir)
    # A new class so plugins only affect one instance.
    @engine = Class.new(Engine).new(dir)
    @engine.configure
  end


  def build(out)
    @engine.build(out)
  end


  def reload_website_code
    @engine.website_loader.reload
  end

end
