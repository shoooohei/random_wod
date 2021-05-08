class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.references :wod, null: false, foreign_key: true
      t.date :date
      t.string :result
      t.string :memo
      t.float :rate

      t.timestamps
    end
  end
end
