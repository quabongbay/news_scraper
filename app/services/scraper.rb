require 'open-uri'

class Scraper

  News = Struct.new(:image, :title, :link, :excerpt)
  BASE_URL = "https://news.ycombinator.com/"

  def initialize page=nil
    if page
      @url = BASE_URL + page
    else
      @url = BASE_URL + "best"
    end
    @reading_result = Nokogiri::HTML(open(@url), nil, Encoding::UTF_8.to_s)
    @news = []
  end

  def execute
    news_urls = @reading_result.css(".title a.storylink")
    threads = []

    news_urls.each do |url|
      cached_news = Rails.cache.read(url);
      if cached_news.blank?
        threads << Thread.new(url) do |i|
          news = get_details(News.new(nil, i.text, construct_link(BASE_URL, i.values.first)))
          Rails.cache.write(url, news)
          @news << news
        end
      else
        @news << cached_news
      end
    end
    threads.each { |thr| thr.join }

    @news
  end

  def construct_link url, link
    unless link.match("http")
      link = url + link
    end
    link
  end

  def get_details news
    uri = news.link
    tries = 3
    begin
      reader = open(uri).read
      news.excerpt = Readability::Document.new(reader, tags: []).content
      Nokogiri::HTML(reader).css('img').each do |n|
        if n.attr("src")
          news.image = construct_link(news.link, n.attr("src"))
          break
        end
      end
      news
    rescue
      uri = uri + "/"
      retry if (tries -= 1) > 0
      raise
    end
  end

  def get_more_link
    @reading_result.css(".title a.morelink").attr("href").value
  end

end
