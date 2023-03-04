class CreateNegativeDomains < ActiveRecord::Migration[5.1]
  def change
    create_table :negative_domains do |t|
      t.string :name
      t.boolean :ignored, default: false
      t.timestamps
    end
  end
end
