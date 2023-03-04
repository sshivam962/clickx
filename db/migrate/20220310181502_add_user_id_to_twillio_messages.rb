class AddUserIdToTwillioMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :twillio_messages, :user_id, :integer
  end
end
