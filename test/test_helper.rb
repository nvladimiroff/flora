$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'flora'
require 'minitest/autorun'

class Minitest::Test

  def teardown
    `rm tmp/test/*`
  end


  def build(name)
    @flora = Flora::Engine.new("test/fixtures/#{name}", 'tmp/test')
    @flora.build
  end


  def assert_css(selector, expected, file = nil)
    file ||= 'index.html'
    doc = Nokogiri::HTML5(File.read(@flora.out_dir.join(file)))
    result = doc.css(selector)

    assert_equal(expected, result.text)
  end

end
