class AddTagToKeyword < ActiveRecord::Migration[5.1]
  def change
    add_reference :keywords, :keyword_tag, foreign_key: true
  end
end
