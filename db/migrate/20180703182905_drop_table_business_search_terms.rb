class DropTableBusinessSearchTerms < ActiveRecord::Migration[5.1]
  def change
    drop_table :business_search_terms
  end
end
