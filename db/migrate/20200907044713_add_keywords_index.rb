class AddKeywordsIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :keywords, :name
  end
end
