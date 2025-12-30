module ViewHelpers

  def big_text
    h1 class: 'big' do
      yield
    end
  end

end
