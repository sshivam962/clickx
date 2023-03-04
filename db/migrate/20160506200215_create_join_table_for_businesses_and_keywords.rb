class CreateJoinTableForBusinessesAndKeywords < ActiveRecord::Migration[4.2]
  def change
    create_table :business_keywords do |t|
      t.integer :business_id, :keyword_id
    end
    add_index :business_keywords, [ :business_id, :keyword_id ], unique: true, name: 'by_business_and_keyword'
  end
end
