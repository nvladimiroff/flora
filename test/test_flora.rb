require "test_helper"

class TestFlora < Minitest::Test

  def test_single_page_website
    build('single_page_website')

    assert_css('body', 'Hello world')
  end


  def test_two_page_website
    build('two_page_website')

    assert_css('body', 'About!', file: 'about.html')
  end


  def test_links
    build('two_page_website')

    assert_equal('/about', css('body a')['href'])
  end


  def test_markdown
    build('markdown_website')

    assert_css('p strong', 'Hello world', file: 'post-1.html')
  end


  def test_lib_dir
    build('site_with_lib')

    assert_css('body div', 'Hello world from a lib folder')
  end


  def test_layout
    build('site_with_a_layout')

    assert_css('div div', 'Hello world from a layout')
  end


  def test_nested_layout
    build('site_with_nested_layout')

    assert_css('div main div', 'This is a post', file: 'posts/post.html')
  end


  def test_plugins
    build('site_with_a_plugin')

    assert_css('body', 'Hello plugin')
  end


  def test_blog
    build('test_blog')

    assert_css('body li', 'First post title!')
    assert_equal('/posts/post1', css('body li a')['href'])
  end


  def test_public
    build('site_with_public_data')

    assert_match(/font-family: /, OUT_DIR.join('public/app.css').read)
  end


  def test_redirect
    build('site_with_redirects')

    assert_equal('0; url=/', css('head meta', file: 'test/redirect.html')['content'])
    assert_equal('0; url=/', css('head meta', file: 'test2/redirect.html')['content'])
  end

end
