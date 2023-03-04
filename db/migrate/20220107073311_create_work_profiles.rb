class CreateWorkProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :work_profiles do |t|
      t.references :network_profile, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
