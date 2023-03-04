class AddKdiToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :kdi, :float
    add_column :keywords, :kdi_updated_at, :datetime
  end
end
