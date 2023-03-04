class AddIsSectionToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :enable_challenge, :boolean, default: false
  end
end
