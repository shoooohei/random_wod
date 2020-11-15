class CreateWods < ActiveRecord::Migration[6.0]
  def change
    create_table :wods do |t|
      t.date :date, null: false
      t.string :strength
      t.string :strength_record
      t.string :conditioning
      t.string :conditioning_reocrd
      t.string :wod
      t.string :wod_record
      t.float :rate
      t.string :note

      t.timestamps
    end

    add_index :wods, :date, unique: true
  end
end
