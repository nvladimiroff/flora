$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'flora'
require 'minitest/autorun'
require 'debug'

class Minitest::Test

  def teardown
    `rm -rf tmp/test/*`
  end


  def build(name)
    @flora = Flora.new("test/fixtures/#{name}")
    @flora.build('tmp/test')
  end


  def css(selector, file: nil)
    file ||= 'index.html'
    doc = Nokogiri::HTML5(out_dir.join(file).read)
    doc.css(selector)[0]
  end


  def assert_css(selector, expected, file: nil)
    assert_equal(expected, css(selector, file:).text)
  end


  private

    def out_dir
      @flora.instance_variable_get(:@engine).instance_variable_get(:@out_dir)
    end

end
