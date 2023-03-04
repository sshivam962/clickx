class CreateBlacklistedDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :blacklisted_domains do |t|
      t.string :name, null: false
      
      t.timestamps
    end
  end
end
