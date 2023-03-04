class RemoveWhiteLabelEnabledFromAgencies < ActiveRecord::Migration[5.1]
  def change
    remove_column :agencies, :white_labeled
  end
end
