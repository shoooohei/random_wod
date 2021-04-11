require 'net/http'

class CreateMaebashiWod

  prepend SimpleCommand
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :target_date, :date, default: Date.current

  validate :must_be_correct_date

  def initialize(*)
    super
    @logger = Rails.logger
  end

  def must_be_correct_date
    errors.add(:target_date, :invalid) unless target_date.is_a?(Date)
    # MARK: CrossfitMaebashiに同じ日のWODは存在しない
    errors.add(:target_date, "日付が重複しています。") if Wod.exists?(date: target_date)
  end

  def call_init_wod
    @wod = Wod.new
  end

  def output_request_log(uri)
    @logger.info(<<~LOG)
      =================================
      通信開始
      URI: #{uri}
      =================================
    LOG
  end

  def output_response_log(response)
    @logger.info(<<~LOG)
      =================================
      通信終了
      response.code: #{response.code}
      =================================
    LOG
  end

  def fetch_wod
    target_date_str = target_date.strftime('%Y年%-m月%-d日')
    prev_date_str = target_date.prev_day.strftime('%Y/%m/%d')
    uri = URI.parse(URI.encode("http://crossfit-gunma.com/#{prev_date_str}/#{target_date_str}/"))
    http = Net::HTTP.new(uri.host, uri.port)

    # 通信設定
    http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.read_timeout = 100
    http.open_timeout = 100

    # 送信内容設定
    req = Net::HTTP::Get.new(uri.request_uri)
    headers = { "Content-Type" => "application/json; charset=utf8" }
    req.initialize_http_header(headers)

    output_request_log(uri)

    # 送信
    begin
      response = http.request(req)
    rescue => e
      logger.error("#{self.class.name}.#{method_name} : #{[uri, e.class, e].join(" : ")}")
      return
    end

    output_response_log(response)
    response
  end

  def set_wod_data(response)
    if response.code_type == Net::HTTPOK
      @logger.info("#{target_date}のWODの取得に成功")
      doc = Nokogiri::HTML.parse(response.body)
      entry_content = doc.css('.entry-content').first
      entry_content.css('#quads-ad2').remove
      @wod.date = target_date
      @wod.name = target_date.to_s
      # MARK: textを呼び出すとbrタグの改行が消えてしまうため予め改行コードに変換しておく
      entry_content.search('br').each { |br| br.replace("\n") }
      @wod.content = entry_content.text.strip.gsub(/\n+/, "\n")
    elsif response.code_type == Net::HTTPNotFound
      message = "#{target_date}のWODは存在しません。"
      errors.add(:base, message)
      @logger.info(message)
    else
      raise "Unexpected Error"
    end
  end

  def call
    return nil if invalid?

    call_init_wod
    set_wod_data(fetch_wod)
    @wod.save! if errors.blank?
    @wod
  end
end
