class FloraBlog::Post

  def initialize(page)
    @page = page
    @frontmatter = parse_frontmatter
  end


  def url
    'https://google.com'
  end


  def title
    'google'
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
