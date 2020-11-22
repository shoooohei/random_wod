return unless File.exist?('tmp/wod_data.json')
wod_data = []
File.open('tmp/wod_data.json') do |file|
  wod_data = JSON.load(file)
end

Wod.transaction do
  wod_data.each do |attributes|
    wod = Wod.new(date: Date.parse(attributes["date"]), content: attributes["content"])
    if wod.save
      puts "#{attributes["date"]}のWODの保存に成功しました"
    else
      puts "#{attributes["date"]}のWODの保存に失敗しました"
      puts "#{wod.errors.full_messages}"
      raise ActiveRecord::Rollback
    end
  end
end