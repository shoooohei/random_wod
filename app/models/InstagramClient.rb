class InstagramClient
  attr_accessor :session

  def initialize
    Capybara.register_driver :selenium do |app|
      options = ::Selenium::WebDriver::Chrome::Options.new

      options.add_argument('--no-sandbox')
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--window-size=1680,1050')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end
    Capybara.javascript_driver = :selenium
    @session = Capybara::Session.new(:selenium)
  end

  def crawl!(url)
    parse_top_page(url)
    sleep 2
  end

  private

  def parse_top_page(url)
    session.visit url
    doc = Nokogiri::HTML.parse(@session.html) # Nokogiri::HTML::Document
    puts "video_url"
    puts "#{doc.at_css('video.tWeCl').attributes["src"].value}"
    puts "image_url"
    puts "#{doc.at_css('img._8jZFn').attributes["src"].value}"
  end
end