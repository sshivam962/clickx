class AddSuccessMessageToPageForm < ActiveRecord::Migration[4.2]
  def change
    add_column :page_forms, :success_message, :text
  end
end
