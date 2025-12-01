require 'zeitwerk'
require 'nokogiri'
require 'kramdown'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

module Flora
end
