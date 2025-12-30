class Flora::Project::Blueprint::Markdown < Flora::Project::Blueprint

  include Flora::Project::Blueprint::HasLayout


  def self.recognize(file, config)
    file.extname == '.md'
  end


  private

    def render_lilac
      silence_warnings do
        raw_html(Kramdown::Document.new(skipping_frontmatter(@file.read), input: 'GFM').to_html)
      end
    end


    # Remove this if kramdown ever fixes its one warning.
    def silence_warnings
      old_verbose, $VERBOSE = $VERBOSE, nil
      yield
    ensure
      $VERBOSE = old_verbose
    end


    # TODO: Maybe just make frontmatter fully supported by Markdown?
    def skipping_frontmatter(str)
      str.gsub(/^---\n(.*)---\n/m, '')
    end

end
