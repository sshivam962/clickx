class AddMcqToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :mcq, :string
  end
end
