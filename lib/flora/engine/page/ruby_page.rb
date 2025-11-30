class Flora::Engine::Page::RubyPage < Flora::Engine::Page

  def initialize(file)
    super(file)
  end


  def render(layout)
    $flora_added = []
    body = layout.render do
      instance_eval(@file.read)
    end

    page = Nokogiri::HTML5::Document.new
    root = to_html(body, page)
    page.add_child(root)
    page.to_html
  end


  private

    def to_html(tree, document)
      if tree[:text]
        return document.create_text_node(tree[:text])
      end

      node = document.create_element(tree[:tag].to_s, **tree[:opts])

      tree[:children].each do |child|
        child_node = to_html(child, document)
        node.add_child(child_node)
      end

      node
    end

end
