class AddDetailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gender, :string
    add_column :users, :dob, :string
    add_column :users, :place, :string
    add_column :users, :avatar, :string
  end
end
