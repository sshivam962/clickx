class AddAccessTipToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :access_tip, :string
  end
end
