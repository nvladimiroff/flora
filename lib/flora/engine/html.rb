class Flora::Engine::Html

  def initialize
    @added = []
  end

  %w[html head body].each do |tag|
    define_method(tag) do |**opts, &block|
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

end
