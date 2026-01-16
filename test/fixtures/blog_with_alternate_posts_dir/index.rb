html do
  body do
    ul do
      posts.each do |post|
        li do
          Post.new(post).render
        end
      end
    end
  end
end
