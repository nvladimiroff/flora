class FloraBlog::Post

  def initialize(page, frontmatter)
    @page = page
    @frontmatter = @frontmatter
  end


  def url
    @page.url
  end


  def method_missing(name, ...)
    return @frontmatter[name] if @frontmatter[name]

    super(name, ...)
  end

end
