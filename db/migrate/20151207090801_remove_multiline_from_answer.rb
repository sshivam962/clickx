class RemoveMultilineFromAnswer < ActiveRecord::Migration[4.2]
  def change
    remove_column :answers, :multiline, :string
    remove_column :answers, :boolean_ans, :boolean
  end
end
