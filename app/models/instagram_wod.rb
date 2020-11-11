class InstagramWod
  attr_accessor :session, :doc, :video_url, :image_url

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
    self.doc = parse_top_page(url)
    sleep 2
    set_video_url
    set_image_url
    puts "video_url"
    puts "#{video_url}"
    puts "image_url"
    puts "#{image_url}"
  end

  private

  def parse_top_page(url)
    session.visit url
    Nokogiri::HTML.parse(@session.html) # Nokogiri::HTML::Document
  end

  def set_video_url
    self.video_url = doc.at_css('video.tWeCl').attributes["src"].value
  end

  def set_image_url
    self.image_url = doc.at_css('img._8jZFn').attributes["src"].value
  end
end