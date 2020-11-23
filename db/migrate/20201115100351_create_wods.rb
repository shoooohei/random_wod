class CreateWods < ActiveRecord::Migration[6.0]
  def change
    create_table :wods do |t|
      t.date :date, null: false
      t.string :content
      t.string :note

      t.timestamps
    end

    add_index :wods, :date, unique: true
  end
end
