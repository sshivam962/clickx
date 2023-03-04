class CreateNetworkProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :network_profiles do |t|
      t.references :user, foreign_key: true
      t.text :description
      t.string :available_hours
      t.string :time_period
      t.string :cv
      t.integer :hours_of_work, default: 0
      t.integer :happy_client, default: 0
      t.integer :finished_project, default: 0
      t.integer :cups_of_coffee, default: 0
      t.string :background_image

      t.timestamps
    end
  end
end
