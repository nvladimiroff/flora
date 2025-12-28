class Flora::Blueprint::Page::RubyPage < Flora::Blueprint::Page

  private

    def render_tree
      # The Html DSL uses a global variable internally that needs to be reset every time.
      $flora_added = []

      instance_eval(@file.read)
    end

end
