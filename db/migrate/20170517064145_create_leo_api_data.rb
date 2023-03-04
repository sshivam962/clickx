class CreateLeoApiData < ActiveRecord::Migration[4.2]
  def change
    create_table :leo_api_data do |t|
      t.integer :business_id
      t.integer :project_id
      t.json :graph_data
      t.json :issues_data
      t.json :duplicates_data

      t.timestamps null: false
    end
    add_index :leo_api_data, :business_id
  end
end
