class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :dir
      t.integer :user_id
      t.integer :fact_id

      t.timestamps null: false
    end
  end
end
