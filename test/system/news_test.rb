require "application_system_test_case"

class NewsTest < ApplicationSystemTestCase

  test "visiting the index" do
    visit news_index_path
    assert_selector "h1", text: "News Scraper, page 1"
  end

  test "visiting the next page" do
    visit news_index_path
    click_link 'More'
    assert_current_path('/news?page=best%3Fp%3D2')
  end

end
