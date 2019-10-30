class NewsController < ApplicationController
  def index
    scraper = Scraper.new(params[:page])
    @news = scraper.execute
    @more_link = scraper.get_more_link
  end


end
