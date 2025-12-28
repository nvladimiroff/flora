# A page is something can be turned into HTML.
class Flora::Blueprint::Page

  attr_reader(:blueprint, :file, :route)


  def self.for(file)
    # TODO: make this a little more extensible so plugins can implement new page
    # types.
    case file.extname
    when '.rb'
      RubyPage
    when '.md'
      MarkdownPage
    end
  end


  def initialize(blueprint, file, route)
    @blueprint = blueprint
    @file = file
    @route = route
    @layout = find_layouts
  end


  def render
    tree = @layout.render do
      render_tree
    end

    Html.to_html(tree)
  end


  private

    def find_layouts
      layouts = []

      @file.ascend do |dir|
        maybe_layout = dir.join('_layout.rb')
        layouts << maybe_layout if maybe_layout.exist?
      end

      Layout.new(layouts)
    end

end
