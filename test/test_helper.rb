$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'flora'
require 'minitest/autorun'
require 'debug'

class Minitest::Test

  OUT_DIR = Pathname.new('tmp/test')


  def teardown
    `rm -rf tmp/test/*`
  end


  def build(name)
    @flora = Flora.new("test/fixtures/#{name}")
    @flora.build(OUT_DIR.to_s)
  end


  def css(selector, file: nil)
    file ||= 'index.html'
    doc = Nokogiri::HTML5(OUT_DIR.join(file).read)
    doc.css(selector)[0]
  end


  def assert_css(selector, expected, file: nil)
    assert_equal(expected, css(selector, file:).text)
  end

end
