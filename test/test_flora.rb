# frozen_string_literal: true

require "test_helper"

class TestFlora < Minitest::Test

  def test_single_path_website
    build('single_page_website')

    assert_css('body', 'Hello world')
  end

end
