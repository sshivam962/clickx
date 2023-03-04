class RemoveVersionFromQuestion < ActiveRecord::Migration[4.2]
  def change
    remove_column :questions, :version, :integer
  end
end
