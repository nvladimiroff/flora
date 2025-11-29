# frozen_string_literal: true

require "test_helper"

class TestFlora < Minitest::Test

  def test_single_page_website
    build('single_page_website')

    assert_css('body', 'Hello world')
  end


  def test_two_page_website
    build('two_page_website')

    assert_css('body', 'About!', 'about.html')
  end


  def test_links
    build('two_page_website')

    assert_equal('/about', css('body a')['href'])
  end


  def test_markdown
    build('markdown_website')

    assert_css('p strong', 'Hello world', 'post-1.html')
  end

end
