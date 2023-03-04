class AddEnableDummyBusinessToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :enable_dummy_business, :boolean, default: false
  end
end
