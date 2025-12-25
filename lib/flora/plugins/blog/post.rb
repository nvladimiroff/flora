class Flora::Plugins::Blog::Post

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


  def method_missing(name, ...)
    return @frontmatter[name] if @frontmatter[name]

    super(name, ...)
  end


  private

    def parse_frontmatter
      page_data = @page.read

      return {} unless page_data.start_with?('---')
      /(?<=---\n)(?<yaml>.*)(?=---\n)/m =~ @page.read

      YAML.load(yaml)
    end

end
