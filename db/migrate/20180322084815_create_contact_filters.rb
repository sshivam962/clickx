class CreateContactFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_filters do |t|
      t.belongs_to :business, index: true
      t.string :name
      t.jsonb :filter

      t.timestamps
    end
  end
end