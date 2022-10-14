class Spaces < ActiveRecord::Migration[7.0]
  def change
    create_table :spaces do |t|
      t.string :space_name
      t.text :description
      t.money :price_per_night
      t.text :image
      t.integer :user_id
      t.integer :request_id
    end
  end
end
