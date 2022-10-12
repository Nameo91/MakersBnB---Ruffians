class Requests < ActiveRecord::Migration[7.0]
  def change
    p 'Migrating'
    create_table :requests do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :approval_status
      t.integer :space_id
      t.integer :user_id
    end
  end
end
