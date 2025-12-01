require 'lib/post'

ul do
  @posts.each do |post|
    li do
      Post.new(post).render
    end
  end
end

