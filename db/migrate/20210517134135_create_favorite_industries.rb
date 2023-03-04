class CreateFavoriteIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :favorite_industries do |t|
      t.references :industry, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
