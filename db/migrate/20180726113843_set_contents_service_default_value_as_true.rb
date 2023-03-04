class SetContentsServiceDefaultValueAsTrue < ActiveRecord::Migration[5.1]
  def self.up
    change_column :businesses, :contents_service, :boolean, default: true
  end

  def self.down
    change_column :businesses, :contents_service, :boolean, default: false
  end
end
