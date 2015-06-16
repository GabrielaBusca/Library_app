class AddAdressAndTelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :telephone, :string
    add_column :users, :address, :string
  end
end
