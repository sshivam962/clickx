class AddPositionToFaqs < ActiveRecord::Migration[5.1]
  def change
    add_column :faqs, :position, :integer
  end
end
