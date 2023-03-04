class AddShortDescToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :short_desc, :text
  end
end
