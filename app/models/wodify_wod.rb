class WodifyWod

  SIGN_IN_URL = Rails.application.credentials.dig(:wodify, :sign_in_url)
  SIGN_IN_EMAIL = Rails.application.credentials.dig(:wodify, :email)
  SING_IN_USER_NAME_ID = Rails.application.credentials.dig(:wodify, :form, :sign_in_username_id)
  SING_IN_USER_NAME_PASSWORD = Rails.application.credentials.dig(:wodify, :form, :sign_in_password_id)
  SIGN_IN_PASSWORD = Rails.application.credentials.dig(:wodify, :password)
  SIGN_IN_BUTTON = Rails.application.credentials.dig(:wodify, :button, :sign_in)
  LOGOUT_BUTTON = Rails.application.credentials.dig(:wodify, :button, :logout)
  DATE_FORM_ID = Rails.application.credentials.dig(:wodify, :form, :wod_date_id)

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
    Capybara.configure do |config|
      config.save_path = "tmp/screenshots/"
    end
    @session = Capybara::Session.new(:selenium)
  end

  def fetch_wods(email, password, _date_1, _date_2, &block)
    date_1 = Date.parse(_date_1)
    date_2 = Date.parse(_date_2)
    if date_1 < date_2
      date_range = (date_1..date_2)
    else
      date_range = (date_2..date_1)
    end
    sign_in(email, password)
    date_range.each do |date|
      block.call(fetch_wod_html_on(date))
    end
    sign_out
  end

  # @params [String or Date] date
  def fetch_wod_html_on(_date)
    if _date.is_a?(String)
      date = Date.parse(_date)
    elsif _date.is_a?(Date)
      date = _date
    else
      raise TypeError "_date must be String or Date object", caller
    end
    set_date(date)
    extract_whole_html
  end

  private

  def sign_in(email, password)
    session.visit SIGN_IN_URL
    sleep(2)
    session.instance_eval do
      fill_in(SING_IN_USER_NAME_ID, with: email)
      fill_in(SING_IN_USER_NAME_PASSWORD, with: password)
      click_on(SIGN_IN_BUTTON)
      sleep(2)
      save_screenshot
    end
  end

  def set_date(date)
    session.instance_eval do
      fill_in(DATE_FORM_ID, with: date.strftime("%Y/%m/%d"))
      sleep(3)
      save_screenshot
    end
  end

  # @return [String]
  def extract_whole_html
    session.html
  end

  def sign_out
    session.instance_eval do
      click_on(LOGOUT_BUTTON)
      sleep(3)
      save_screenshot
    end
  end
end
