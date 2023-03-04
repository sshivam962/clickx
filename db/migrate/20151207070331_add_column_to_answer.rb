class AddColumnToAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :paragraph, :text
  end
end
