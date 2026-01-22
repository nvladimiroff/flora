class Flora::Plugins::Blog::Post

  attr_reader(:frontmatter)


  def initialize(page, root)
    @page = page
    @root = root
    @frontmatter = parse_frontmatter
  end


  def url
    '/' + @page.relative_path_from(@root).sub(@page.extname, '').to_s
  end


  def title
    @frontmatter['title']
  end


  def date
    @frontmatter['date'].to_time
  end


  def respond_to_missing?(name, *)
    @frontmatter.include?(name.to_s) || super
  end


  def method_missing(name, ...)
    return @frontmatter[name.to_s] if @frontmatter[name.to_s]

    super(name, ...)
  end


  private

    def parse_frontmatter
      page_data = @page.read

      return {} unless page_data.start_with?('---')
      /^(?<=---\n)(?<yaml>.*)(?=---\n)/m =~ @page.read

      YAML.load(yaml, permitted_classes: [Date])
    end

end
