class AddPricipalToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :principal, :boolean, default: false
  end
end
