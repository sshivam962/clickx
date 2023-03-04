class AddIndexToTaggable < ActiveRecord::Migration[5.1]
  def change
    add_index :taggables, [:keyword_id, :keyword_tag_id], unique: true
    add_index :taggables, :keyword_id
  end
end
