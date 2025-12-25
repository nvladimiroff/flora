module Flora::Engine::Page::Html

  TAGS = %i[
    a abbr address area article aside audio
    b bdi bdo blockquote body br button
    canvas caption cite code col colgroup command
    datalist dd del details dfn div dl dt
    em embed
    fieldset figcaption figure footer form
    h1 h2 h3 h4 h5 h6 head header hr html i iframe img input ins
    kbd keygen
    label legend li link
    main map mark menu meter
    nav
    object ol optgroup option output
    p param pre progress
    q
    rp rt ruby
    s samp section select small source span strong sub summary sup
    table tbody td textarea tfoot th thead time tr track
    u ul
    var video
    wbr
  ]


  class << self

    def to_html(tree)
      document = Nokogiri::HTML5::Document.new
      root = to_html_inner(tree, document)
      document.add_child(root)
      document.to_html
    end


    private

      def to_html_inner(tree, document)
        if tree[:text]
          return document.create_text_node(tree[:text])
        end

        if tree[:html]
          return document.fragment("<div>#{tree[:html]}</div>")
        end

        node = document.create_element(tree[:tag].to_s, **tree[:opts])

        tree[:children].each do |child|
          child_node = to_html_inner(child, document)
          node.add_child(child_node)
        end

        node
      end

  end


  TAGS.each do |tag|
    define_method(tag) do |*args, **opts, &block|
      children = []

      if block
        old_added = $flora_added
        $flora_added = []
        result = block.call
        if result.is_a?(String)
          children = [{ tag: 'text', opts: {}, text: result, children: [] }]
        else
          children = $flora_added
        end
        $flora_added = old_added
      end

      node = { tag:, opts:, children: }
      $flora_added << node
      node
    end
  end


  def raw_html(string)
    node = { tag: 'raw', opts: {}, html: string, children: [] }
    $flora_added << node
    node
  end

end
