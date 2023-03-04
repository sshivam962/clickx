class AddProjectTypeToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :project_type, :string
  end
end
