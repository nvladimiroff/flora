class Flora::Blueprint::Page::RubyPage < Flora::Blueprint::Page

  private

    def render_tree
      instance_eval(@file.read)
    end

end
