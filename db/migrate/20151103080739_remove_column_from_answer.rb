class RemoveColumnFromAnswer < ActiveRecord::Migration[4.2]
  def change
    remove_column :answers, :string
  end
end
