class AddScreennameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :screen_name, :string
  end
end
