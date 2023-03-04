class AddPositionToAdminFaq < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_faqs, :position, :integer
  end
end
