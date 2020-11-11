class WodifyWod

  SIGN_IN_URL = Rails.application.credentials.dig(:wodify, :sign_in_url)
  SIGN_IN_EMAIL = Rails.application.credentials.dig(:wodify, :email)
  SING_IN_USER_NAME_ID = Rails.application.credentials.dig(:wodify, :form, :sign_in_username_id)
  SING_IN_USER_NAME_PASSWORD = Rails.application.credentials.dig(:wodify, :form, :sign_in_password_id)
  SIGN_IN_PASSWORD = Rails.application.credentials.dig(:wodify, :password)
  SIGN_IN_BUTTON = Rails.application.credentials.dig(:wodify, :button, :sign_in)
  LOGOUT_BUTTON = Rails.application.credentials.dig(:wodify, :button, :logout)

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

  def fetch_wods(start_date, end_date)
    sign_in
    sign_out
  end

  private

  def sign_in
    session.visit SIGN_IN_URL
    sleep(2)
    session.instance_eval do
      fill_in(SING_IN_USER_NAME_ID, with: SIGN_IN_EMAIL)
      fill_in(SING_IN_USER_NAME_PASSWORD, with: SIGN_IN_PASSWORD)
      click_on(SIGN_IN_BUTTON)
      sleep(2)
      save_and_open_screenshot
    end
  end

  def sign_out
    session.instance_eval do
      click_on(LOGOUT_BUTTON)
      sleep(3)
      save_and_open_screenshot
    end
  end
end
