class CreateBusinessHours < ActiveRecord::Migration[4.2]
  def change
    create_table :business_hours do |t|
      t.string :days
      t.string :status
      t.time :from
      t.time :to
      t.references :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
