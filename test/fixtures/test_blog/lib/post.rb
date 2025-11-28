module Post

  def self.render(post)
    a href: post.url do
      post.title
    end
  end

end
