class Flora::Blueprint::Page::MarkdownPage < Flora::Blueprint::Page

  private

    def render_tree
      silence_warnings do
        raw_html(Kramdown::Document.new(@file.read).to_html)
      end
    end


    # Remove this if kramdown ever fixes its one warning.
    def silence_warnings
      old_verbose, $VERBOSE = $VERBOSE, nil
      yield
    ensure
      $VERBOSE = old_verbose
    end

end
