class CreateBusinessSearchTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :business_search_terms do |t|
      t.references :business
      t.references :search_term
      t.timestamps
    end
  end
end
