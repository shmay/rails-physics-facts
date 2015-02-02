class CreateStarrings < ActiveRecord::Migration
  def change
    create_table :starrings do |t|
      t.integer :user_id
      t.integer :fact_id

      t.timestamps null: false
    end
  end
end
