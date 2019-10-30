require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest
  test "can see h1" do
    get "/"
    assert_select "h1", "News Scraper, page 1"
  end
end
