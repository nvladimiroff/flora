class Flora::Engine::Page::MarkdownPage < Flora::Engine::Page

  def render
    Kramdown::Document.new(@file.read).to_html
  end

end
