class AddLeoProjectIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :leo_project_id, :string
  end
end
