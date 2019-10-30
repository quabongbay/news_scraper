require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get news_index_path
    assert_response :success
    assert_equal "index", @controller.action_name
    assert_match "News Scraper", @response.body
  end

end
