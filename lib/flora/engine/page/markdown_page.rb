class Flora::Engine::Page::MarkdownPage < Flora::Engine::Page

  def render(layout)
    # TODO: layouts with markdown.

    silence_warnings do
      Kramdown::Document.new(@file.read).to_html
    end
  end


  private

    # Remove this if kramdown ever fixes its one warning.
    def silence_warnings
      old_verbose, $VERBOSE = $VERBOSE, nil
      yield
    ensure
      $VERBOSE = old_verbose
    end

end
