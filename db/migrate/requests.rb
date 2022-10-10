class Requests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.date :date
      t.boolean :approval_status
      t.integer :space_id
      t.integer :user_id
    end
  end
end
