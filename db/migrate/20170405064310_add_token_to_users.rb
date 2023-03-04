class AddTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :token, :string
  end

  def up
    User.find_each.map(&:regenerate_token)
  end
end
