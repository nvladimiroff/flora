class Post

  def initialize(post)
    @post = post
  end


  def render
    a href: @post.url do
      @post.title
    end
  end

end
