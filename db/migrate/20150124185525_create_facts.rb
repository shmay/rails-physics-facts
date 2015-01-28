class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.string :title
      t.text :body

      t.integer :impressions_count

      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
