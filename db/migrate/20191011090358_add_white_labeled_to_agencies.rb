class AddWhiteLabeledToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :white_labeled, :boolean, default: false
  end
end
