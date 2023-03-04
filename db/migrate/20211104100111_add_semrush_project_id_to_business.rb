class AddSemrushProjectIdToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :semrush_project_id, :string
    add_column :businesses, :semrush_project_url, :string
  end
end
