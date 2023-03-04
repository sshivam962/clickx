class RemoveAccentColorFromAgencies < ActiveRecord::Migration[5.1]
  def change
    remove_column :agencies, :accent_color, :string
  end
end
