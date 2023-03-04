class AddPreviewUserToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :preview_user, :boolean, default: false
  end
end
