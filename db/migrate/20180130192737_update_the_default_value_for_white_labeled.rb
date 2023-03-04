class UpdateTheDefaultValueForWhiteLabeled < ActiveRecord::Migration[5.1]
  def self.up
    # change_column :agencies, :white_labeled, :boolean, default: true
  end

  def self.down
    # change_column :agencies, :white_labeled, :boolean, default: false
  end
end
