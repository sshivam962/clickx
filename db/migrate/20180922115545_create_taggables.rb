class CreateTaggables < ActiveRecord::Migration[5.1]
  def change
    create_table :taggables do |t|
      t.integer :keyword_id
      t.integer :keyword_tag_id

      t.timestamps
    end
  end
end
