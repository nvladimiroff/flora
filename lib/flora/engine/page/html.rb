class Flora::Engine::Page::Html

  def initialize
    @added = []
  end


  def method_missing(tag, *args, **opts, &block)
    children = []

    if block
      old_added = @added
      @added = []
      result = block.call
      if result.is_a?(String)
        children = [{ tag: 'text', opts: {}, text: result, children: [] }]
      else
        children = @added
      end
      @added = old_added
    end

    node = { tag:, opts:, children: }
    @added << node
    node
  end

end
