class AddMcqChoicesToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :mcq_choices, :string, array: true, default: []
  end
end
