require_relative 'lib/post'

ul do
  @posts.each do |post|
    li do
      Post.render(post)
    end
  end
end

