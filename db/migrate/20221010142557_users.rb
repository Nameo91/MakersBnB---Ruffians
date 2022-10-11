class Users < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email
      t.string :mobile_number
      t.string :password_digest
      t.integer :request_id
    end
  end
end
