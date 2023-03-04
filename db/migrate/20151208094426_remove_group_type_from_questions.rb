class RemoveGroupTypeFromQuestions < ActiveRecord::Migration[4.2]
  def change
    remove_column :questions, :group_type, :string
  end
end
