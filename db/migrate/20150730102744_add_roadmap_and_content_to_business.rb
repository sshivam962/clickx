class AddRoadmapAndContentToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :roadmap_service, :boolean, default: false
    add_column :businesses, :contents_service, :boolean, default: false
  end
end
