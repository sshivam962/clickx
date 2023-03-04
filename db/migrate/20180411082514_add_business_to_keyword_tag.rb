class AddBusinessToKeywordTag < ActiveRecord::Migration[5.1]
  def change
    add_reference :keyword_tags, :business, foreign_key: true
  end
end
