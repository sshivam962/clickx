class AddFreeServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :free_service, :boolean, default: :false
  end
end
