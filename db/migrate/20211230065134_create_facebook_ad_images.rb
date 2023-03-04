class CreateFacebookAdImages < ActiveRecord::Migration[5.1]
  def change
    create_table :facebook_ad_images do |t|
      t.string :file
      t.boolean :heading, :default => false
      
      t.references :facebook_ad, foreign_key: true

      t.timestamps
    end
  end
end
