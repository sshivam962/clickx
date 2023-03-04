class CreateSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :skills do |t|
      t.references :network_profile, foreign_key: true
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
