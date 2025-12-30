# A Blueprint that includes Nestable is something that can be nested into a
# Lilac-based layout.
module Flora::Project::Blueprint::Nestable

  def render
    # The Html DSL uses a global variable internally that needs to be reset every time.
    $flora_added = []

    layouts = find_layouts
    tree = render_internal(layouts, layouts.size) do
      render_lilac
    end

    Flora::Lilac.to_html(tree)
  end


  private

    def find_layouts
      layouts = []
      current = @file.parent

      loop do
        maybe_layout = current.join('./_layout.rb')
        layouts << maybe_layout if maybe_layout.exist?

        break if current == @project.dir
        current = current.parent
      end

      layouts
    end


    def render_internal(layouts, i, &block)
      if i <= 0
        return block.call
      end

      cont = -> { render_internal(layouts, i-1, &block) }
      eval_with_block(layouts[i-1].read, &cont)
    end


    def eval_with_block(str, &block)
      eval(str)
    end

end
