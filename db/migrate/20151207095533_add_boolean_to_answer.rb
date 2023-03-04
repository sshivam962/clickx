class AddBooleanToAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :boolean_ans, :boolean
  end
end
