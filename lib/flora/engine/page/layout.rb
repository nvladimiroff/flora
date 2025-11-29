class Flora::Engine::Page::Layout

  def initialize(layouts)
    @layouts = layouts
  end


  def render(&block)
    render_internal(0, &block)
  end


  private

    def render_internal(i, &block)
      if i == @layouts.size
        return block.call
      end

      eval(@layouts[i].read)
    end

end
