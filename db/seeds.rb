return unless File.exist?('tmp/wod_data.json')
wod_data = []
File.open('tmp/wod_data.json') do |file|
  wod_data = JSON.load(file)
end

is_succeeded = true
Wod.transaction do
  wod_data.each do |attributes|
    wod = Wod.new(date: Date.parse(attributes["date"]), content: attributes["content"])
    unless wod.save
      is_succeeded = false
      puts "#{attributes["date"]}のWODの保存に失敗しました"
      puts "#{wod.errors.full_messages}"
      raise ActiveRecord::Rollback
    end
  end
end

if is_succeeded
  puts "全てのWODのデータの挿入に成功しました。"
end