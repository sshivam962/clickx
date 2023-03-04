class AddFreeToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :free, :boolean, default: false
  end
end
