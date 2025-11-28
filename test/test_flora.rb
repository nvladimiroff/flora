# frozen_string_literal: true

require "test_helper"

class TestFlora < Minitest::Test

  def test_it_does_something_useful
    Flora.build('fixtures/test_blog')
  end

end
