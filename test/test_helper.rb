$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'flora'
require 'minitest/autorun'
require 'debug'

class Minitest::Test

  def teardown
    `rm tmp/test/*`
  end


  def build(name)
    @flora = Flora::Engine.new("test/fixtures/#{name}", 'tmp/test')
    @flora.build
  end


  def css(selector, file: nil)
    file ||= 'index.html'
    doc = Nokogiri::HTML5(@flora.out_dir.join(file).read)
    doc.css(selector)[0]
  end


  def assert_css(selector, expected, file: nil)
    assert_equal(expected, css(selector, file:).text)
  end

end
