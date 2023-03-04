class AddTagsToBusinessKeyword < ActiveRecord::Migration[4.2]
  def change
    add_column :business_keywords, :tags, :string
  end
end
