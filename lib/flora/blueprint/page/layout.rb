class Flora::Blueprint::Page::Layout

  def initialize(layouts)
    @layouts = layouts
  end


  def render(&block)
    render_internal(@layouts.size - 1, &block)
  end


  private

    def render_internal(i, &block)
      if i <= 0
        return block.call
      end

      cont = -> { render_internal(i-1, &block) }
      eval_with_block(@layouts[i].read, &cont)
    end


    def eval_with_block(str, &block)
      eval(str)
    end

end
