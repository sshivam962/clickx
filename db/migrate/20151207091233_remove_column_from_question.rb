class RemoveColumnFromQuestion < ActiveRecord::Migration[4.2]
  def change
    remove_column :questions, :min_ans_req, :integer
  end
end
