class AddColumnOrderToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :order, :integer
  end
end
