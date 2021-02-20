class CreateWods < ActiveRecord::Migration[6.0]
  def change
    create_table :wods do |t|
      t.date :date
      t.string :name
      t.string :content
      t.string :note

      t.timestamps
    end
  end
end
